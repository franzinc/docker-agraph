# Makefile
#
# This is supplied for convenience and backward compatibility.

default: build

build:
	./agdock build --version=$(VERSION)

run:
	./agdock run --version=$(VERSION)

push: FORCE
	./agdock push --version=$(VERSION)

FORCE:
