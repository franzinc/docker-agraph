# Makefile
#
# This is supplied for convenience and backward compatibility.

ifndef VERSION
$(error VERSION must be supplied.  Don't include the 'v')
endif

default: build

build:
	./agdock build --version=$(VERSION)

run:
	./agdock run --version=$(VERSION)

push: FORCE
	./agdock push --image=franzinc/agraph:v$(VERSION)

FORCE:
