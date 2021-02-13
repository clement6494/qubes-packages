RPM Repository
==============

A repository of RPM packages for Qubes OS.

Usage
-----

### Initialise the repository

```sh
make init
```

### Add packages

The RPM packages are meant to be stored into the `public/qubes-os/r4.1/testing/packages` directory.
Add as many as you want, then update the repository metadata.

```sh
make update
```

Signing the repository allows people to verify that you (and not someone else) updated the repository.

```sh
# Your GPG key name would be different:
GPG_NAME="Packaging" make sign
```

### Deploy

Before deploying, (re-)generate the index files. Those will make browsing nicer for humans.

```sh
make index
```

Install the [`surge` command-line interface](https://surge.sh) if you haven't already.

```sh
sudo dnf install nodejs
npm install surge
```

Then deploy.

```sh
SURGE_SUBDOMAIN='awesome-name' make deploy
```

