SURGE_SUBDOMAIN ?= awesome-name

# Force HTTP to redirect to HTTPS
# see https://surge.sh/help/using-https-by-default
SURGE_URL ?= https://${SURGE_SUBDOMAIN}.surge.sh

# Separate what will be published from the rest of the code
REPO_PREFIX = public/

# Your repository naming conventions are really up to you
REPO_PATH ?= qubes-os/r4.1/testing/

# The ID of you GPG key will likely be different
GPG_NAME ?= Packaging

# I use split-GPG on Qubes OS, replace this by "gpg" if needed
define GPG_CMD
	qubes-gpg-client-wrapper
endef

# I don't usually install the Surge CLI globally, replace by "surge" if needed
define SURGE_CMD
	surge
endef

# Default target, what I'd likely want to do most often
.PHONY: all
all: update sign index deploy

# Initialize your package repository
.PHONY: init
init: createrepo robots.txt 404.html

.PHONY: createrepo
createrepo:
	mkdir -p ${REPO_PREFIX}${REPO_PATH}packages
	createrepo ${REPO_PREFIX}${REPO_PATH}

robots.txt:
	mkdir -p ${REPO_PREFIX}
	# Surge kindly hosts us, let's save bandwidth where we can
	printf 'User-agent: *\nDisallow: /\n' > ${REPO_PREFIX}robots.txt

# Humans may visit too!
404.html:
	mkdir -p ${REPO_PREFIX}
	cp src/404.html ${REPO_PREFIX}

# Update the repository metadata after adding packages
.PHONY: update
update:
	createrepo --update ${REPO_PREFIX}${REPO_PATH}

# Sign the repository metadata with GPG
.PHONY: sign
sign:
	${GPG_CMD} --local-user "${GPG_NAME}" --sign --detach --armor --output ${REPO_PREFIX}${REPO_PATH}repodata/repomd.xml.asc ${REPO_PREFIX}${REPO_PATH}repodata/repomd.xml

# Create some HTML pages to make the repository nice to humans
.PHONY: index
index:
	cd ${REPO_PREFIX} && for d in $$(find -type d); do (cd $$d && tree -I index.html -H . -T '🌳 Directory Tree' --dirsfirst -r > index.html); done && cd -

# Deploy the repository to Surge
.PHONY: deploy
deploy:
	${SURGE_CMD} ${REPO_PREFIX} ${SURGE_URL}

# Tear down the repository from Surge
.PHONY: teardown
teardown:
	${SURGE_CMD} teardown ${SURGE_URL}

# Remove the repository entirely, including the packages
# This doesn't tear the repository down from Surge, though.
.PHONY: clean
clean:
	-rm -r ${REPO_PREFIX}
