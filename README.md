RPM Repository
==============

A repository of RPM packages for Qubes OS.

> **Note**: This repository currently contains my packages, but the instructions in this README will allow you to get your own repository set up.

Usage
-----

### Initialize the repository

Remove all my packages and initialize your own repository.

```sh
make clean init
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

Contributions
-------------

Contributions are welcome! Please refer to the [contribution guidelines][contributing] to get started.

Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

  [contributing]: ./CONTRIBUTING.md
  [coc]: ./CODE_OF_CONDUCT.md

License
-------

Copyright © 2021 Gonzalo Bulnes Guilpain

To the exclusion of files contained in the `public/` directory, this project is released under the GNU General Public License v2 (see [LICENSE](LICENSE.md)).

The packages contained in the `public/` directory contain their own licensing information, and the rest is generated automatically by the code in this project.
