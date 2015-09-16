Docker AllegroGraph
===================

Table of contents
-----------------

   * Description
   * Dependencies
   * Installation
   * Configuration
   * Licence

Description
-----------

This software allows running AllegroGraph (any edition) in a Docker
container.

Dependencies
------------

This depends on Docker and AllegroGraph.

Installation
------------

Using the container built by Franz, Inc:

    $ docker pull franzinc/agraph

Building from source:

    $ make

See `run.sh` for details on how to run the container.

Configuration
-------------

The AllegroGraph configuration `agraph.cfg`.  See the AllegroGraph
documentation for more information on configuration options for
AllegroGraph.

Documentation
-------------

The best resource outside of Docker is the AllegroGraph documentation:

http://franz.com/agraph/support/documentation/current/agraph-introduction.html

License
-------

Copyright (c) 2015, Franz, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
