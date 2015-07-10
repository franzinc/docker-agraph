#! /bin/bash

set -eux

docker run -d --name agraph -p 10035:10035 franzinc/agraph
