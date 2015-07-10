
REPO_PREFIX = franzinc
CONTAINERID = agraph

default: 
	docker build -t $(REPO_PREFIX)/$(CONTAINERID) .

FORCE:
