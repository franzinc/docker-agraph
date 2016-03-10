
REPO_PREFIX = franzinc
CONTAINERID = agraph

VERSION = 6.0.1
TGZ = agraph-$(VERSION)-linuxamd64.64.tar.gz

default: Dockerfile
	docker build -t $(REPO_PREFIX)/$(CONTAINERID) .

Dockerfile: Dockerfile.in Makefile
	sed -e 's/__TGZ__/$(TGZ)/g' \
	    -e 's/__VERSION__/$(VERSION)/g' \
	    < $< > $@

# Unless you work at Franz, Inc you should ignore this rule:
push: FORCE
	docker login -u $(REPO_PREFIX)
	docker push franzinc/agraph:latest
	docker push franzinc/agraph:v$(VERSION)

FORCE:
