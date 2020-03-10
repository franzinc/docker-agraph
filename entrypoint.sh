#!/bin/bash -e

# Recursively change ownership of the agraph directory (included
# volumes /agraph/data and /agraph/etc).
sudo chown -R agraph:agraph /agraph


# Make sure shared memory requirements are met.
shm_size=$(df -P /dev/shm | grep -v Filesystem | awk '{print $2}')

if [ "$shm_size" -lt 1048576 ]
then
    cat <<EOF
The container for AllegroGraph must be started with the following 
option in order to operate correctly:
--shm-size 1g 
EOF
    exit 1
fi

function file_env {
    local var="$1"
    local file_var="${var}_FILE"
    if [ "${!var:-}" ] && [ "${!file_var:-}" ]; then
      cat >&2 "$var and $file_var are exclusive"
      exit 1
    fi
    local val="${2:-}"
    if [ "${!var:-}" ]; then
      val="${!var}"
    elif [ "${!file_var:-}" ]; then
      val="$(< "${!file_var}")"
    fi
    unset "$file_var"
    export "$var"="$val"
}

AGDATADIR=/agraph/data
AGRAPHCFG=/agraph/etc/agraph.cfg
AGRAPHLOG=/agraph/data/agraph.log

# Configure agraph if $agraphcfg file does not exist.
if [ ! -f $AGRAPHCFG ]
then
    file_env 'AGRAPH_SUPER_USER'
    file_env 'AGRAPH_SUPER_PASSWORD'
    if [ -z "$AGRAPH_SUPER_USER" ] || [ -z "$AGRAPH_SUPER_PASSWORD" ]; then
        AGRAPH_SUPER_USER=admin
        AGRAPH_SUPER_PASSWORD=$(tr -dc _A-Z-a-z-0-9 </dev/urandom | head -c16)
	cat <<EOF
No config file found and AGRAPH_SUPER_USER and AGRAPH_SUPER_PASSWORD
variables are not set. Superuser is configured with the following
generated credentials:

  User:     $AGRAPH_SUPER_USER
  Password: $AGRAPH_SUPER_PASSWORD

EOF
    fi
    /agraph/lib/configure-agraph                  \
        --non-interactive                         \
        --config-file    $AGRAPHCFG               \
        --data-dir       $AGDATADIR               \
        --log-dir        $AGDATADIR               \
        --super-user     "$AGRAPH_SUPER_USER"     \
        --super-password "$AGRAPH_SUPER_PASSWORD" \
        --session-ports  10000-10034              \
        --runas-user     agraph
fi

function terminate {
    echo Shutting down AllegroGraph
    /agraph/bin/agraph-control --config $AGRAPHCFG stop
    exit 0
}

trap "echo Caught signal; terminate" SIGINT SIGTERM SIGQUIT

# If container's entrypoint is run without arguments, start
# AllegroGraph, otherwise interpret the arguments as a command to run.
if [ "$#" -ne "0" ]
then
    # Execute provided arguments.
    exec "$@"
else
    # Start AllegroGraph daemon.
    /agraph/bin/agraph-control --config $AGRAPHCFG start
    # Monitor the logfile.
    # This pattern (& to put the process in the background and
    # then blocking using 'wait') appears to be the most reliable
    # way of getting bash to respond to signals.
    tail -f $AGRAPHLOG &
    wait $!
fi
