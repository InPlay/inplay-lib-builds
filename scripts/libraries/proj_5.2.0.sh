#!/bin/bash

LIBRARY_VERSION=5.2.0
OUTPUT_LIBRARY_NAME=proj-${LIBRARY_VERSION}-heroku.tar.gz

curl -O https://ftp.osuosl.org/pub/osgeo/download/proj/proj-${LIBRARY_VERSION}.tar.gz \
  && tar -xvf proj-${LIBRARY_VERSION}.tar.gz \
  && cd proj-${LIBRARY_VERSION} \
  && ./configure --prefix=${HEROKU_VENDOR_DIR} \
  && make -j4 && make install \
  && tar -C ${HEROKU_VENDOR_DIR} -czvf ${TARGET_DIR}/${OUTPUT_LIBRARY_NAME} . \
  && (cd ${TARGET_DIR} && exec md5sum ${OUTPUT_LIBRARY_NAME} > ${OUTPUT_LIBRARY_NAME}.md5)
