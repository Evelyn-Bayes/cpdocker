#!/bin/bash

BASE=cp-kafka
VERSION=6.0.0

docker build --build-arg VERSION=${VERSION} --build-arg IMAGE=${BASE} -t localbuild/${BASE}-custom:${VERSION} -f ./DOCKERFILE ./.
