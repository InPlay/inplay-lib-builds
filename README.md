# InPlay Preamble

Building custom libraries, namely geos and proj, is a pain on Heroku. You only have access to compile tools during slug compilation, not at runtime, so it's hard to debug library compilation issues. So, we try not to upgrade these packages unless strictly necessary. While 3rd party package maintainers for these have existed, ex. https://github.com/cyberdelia/heroku-geo-buildpack (archived & no longer maintained), we've had issues when either they upgrade or we need to upgrade and they haven't.

So, this is our fork of a project that compiles these packages at slug compilation time, then makes them publically accessible for download. Although we could just let the app serve them for future deploys, for cost savings we then move the compiled binaries to rackspace. THEN our main inplay repo pulls those precompiled binaries to be available for linking by rgeo when the main repo slug gets compiled.

Sort of a rude goldberg machine, but hopefully it works better than other methods we've used.

# Vesuvius, a Vulcan replacement
[![Donate once-off to this project using Bitcoin](https://img.shields.io/badge/bitcoin-donate-blue.svg)](bitcoin:1L6sqoG8xXhYziH9NGjPzgR1dEP2SbJrfM)

Build libraries on Heroku without pain.

## Why Vesuvius?

[Vulcan](https://github.com/heroku/vulcan) has been deprecated and GCC is only available [at build time](https://devcenter.heroku.com/articles/stack-packages) on `heroku-16` stack.

Even with `heroku run bash`, compiling stuff on Heroku was painful, time consuming, and you needed a third-party cloud storage to move your compiled library in order to download it.

With **Vesuvius**, this is no longer the case. During the deploy, **Vesuvius** will run all scripts located in `/scripts/libraries` and will move output files to a public directory.

It comes with [proj.4](http://proj4.org/index.html) and [GEOS](https://trac.osgeo.org/geos/) as examples.

## Automatic Setup

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Manual Setup

1. Clone the repo
2. Create a new Heroku application
3. Set your buildpack to Heroku's apt buildpack
```sh
heroku buildpacks:set https://github.com/heroku/heroku-buildpack-apt
```
4. Add Heroku's Ruby buildpack
```sh
heroku buildpacks:add heroku/ruby
```

Deploy and navigate to your application's root path.

## Example script

All you need to do is create a bash script to compile your library and save it
under the `scripts/libraries` folder.

This is an example for the GEOS library:
```shell
#!/bin/bash

LIBRARY_VERSION=3.9.0

curl -O http://download.osgeo.org/geos/geos-${LIBRARY_VERSION}.tar.bz2 \
  && tar -xjvf geos-${LIBRARY_VERSION}.tar.bz2 \
  && cd geos-${LIBRARY_VERSION} \
  && ./configure --prefix=${HEROKU_VENDOR_DIR} \
  && make && make install \
  && tar -C ${HEROKU_VENDOR_DIR} -czvf ${TARGET_DIR}/geos-${LIBRARY_VERSION}-heroku.tar.gz .
```

## How to use the compiled libraries

Take a look at [heroku-buildpack-vendorbinaries](https://github.com/diowa/heroku-buildpack-vendorbinaries).

## Authors

**Geremia Taglialatela**

+ http://github.com/tagliala
+ http://twitter.com/gtagliala
