#!/bin/bash

LIBRARY_VERSION=8.0.1
OUTPUT_LIBRARY_NAME=proj-${LIBRARY_VERSION}-heroku.tar.gz

# Ref: OSGeo/PROJ#1412
SQLITE3_LIBDIR=`which sqlite3 | sed 's/bin\/sqlite3/lib\/x86_64-linux-gnu/g'`
export SQLITE3_LIBS="-L${SQLITE3_LIBDIR} -l:libsqlite3.so.0.8.6"

curl -O https://ftp.osuosl.org/pub/osgeo/download/proj/proj-${LIBRARY_VERSION}.tar.gz \
  && curl -O https://ftp.osuosl.org/pub/osgeo/download/proj/proj-${LIBRARY_VERSION}.tar.gz.md5 \
  && md5sum -c proj-${LIBRARY_VERSION}.tar.gz.md5 \
  && tar -xvf proj-${LIBRARY_VERSION}.tar.gz \
  && cd proj-${LIBRARY_VERSION} \
  && ./configure --prefix=${HEROKU_VENDOR_DIR} \
  && make && make install \
  && tar -C ${HEROKU_VENDOR_DIR} -czvf ${TARGET_DIR}/${OUTPUT_LIBRARY_NAME} . \
  && (cd ${TARGET_DIR} && exec md5sum ${OUTPUT_LIBRARY_NAME} > ${OUTPUT_LIBRARY_NAME}.md5)
