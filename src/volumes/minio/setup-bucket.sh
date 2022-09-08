#!/bin/bash

mc config host add minio http://minio:9000 username password
mc mb minio/kafka
