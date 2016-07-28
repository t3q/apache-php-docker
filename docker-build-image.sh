#!/bin/bash
# We want to tag our build by timestamp
TIMESTAMP=`date "+%Y%m%d%H%M%S"`
echo $TIMESTAMP
docker build -t apache-php . && \
docker save -o "apache-php-${TIMESTAMP}.docker" apache-php
