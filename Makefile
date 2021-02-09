SURGE_SUBDOMAIN ?= awesome-name
SURGE_URL = https://${SURGE_SUBDOMAIN}.surge.sh

define SURGE_CMD
	./surge
endef

.PHONY: all
all: index deploy

.PHONY: init
init: createrepo robots.txt 404.html

.PHONY: createrepo
createrepo:
	mkdir -p public/qubes-os/r4.1/testing/packages
	createrepo public/qubes-os/r4.1/testing

robots.txt:
	mkdir -p public
	printf 'User-agent: *\nDisallow: /\n' > public/robots.txt

404.html:
	mkdir -p public
	cp src/404.html public

.PHONY: index
index:
	cd public && for d in $$(find -type d); do (cd $$d && tree -I index.html -H . -T '🌳 Directory Tree' --dirsfirst -r > index.html); done && cd -

.PHONY: deploy
deploy:
	${SURGE_CMD} public ${SURGE_URL}
