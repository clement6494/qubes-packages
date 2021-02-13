SURGE_SUBDOMAIN ?= awesome-name
SURGE_URL ?= https://${SURGE_SUBDOMAIN}.surge.sh

REPO_PATH = public/qubes-os/r4.1/testing/
GPG_NAME ?= Packaging

define GPG_CMD
	qubes-gpg-client-wrapper
endef

define SURGE_CMD
	./surge
endef

.PHONY: all
all: update sign index deploy

.PHONY: init
init: createrepo robots.txt 404.html

.PHONY: createrepo
createrepo:
	mkdir -p ${REPO_PATH}packages
	createrepo ${REPO_PATH}

robots.txt:
	mkdir -p public
	printf 'User-agent: *\nDisallow: /\n' > public/robots.txt

404.html:
	mkdir -p public
	cp src/404.html public

.PHONY: update
update:
	createrepo --update ${REPO_PATH}

.PHONY: sign
sign:
	${GPG_CMD} --local-user "${GPG_NAME}" --sign --detach --armor --output ${REPO_PATH}repodata/repomd.xml.asc ${REPO_PATH}repodata/repomd.xml

.PHONY: index
index:
	cd public && for d in $$(find -type d); do (cd $$d && tree -I index.html -H . -T '🌳 Directory Tree' --dirsfirst -r > index.html); done && cd -

.PHONY: deploy
deploy:
	${SURGE_CMD} public ${SURGE_URL}
