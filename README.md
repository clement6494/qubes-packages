RPM Repository
==============

A repository of RPM packages for Qubes OS.

Usage
-----

### Initialise the repository

```sh
make init
```

The RPM packages are meant to be stored into the `public/qubes-os/r4.1/testing/packages` directory.

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

