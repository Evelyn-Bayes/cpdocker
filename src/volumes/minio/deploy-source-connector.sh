#!/bin/bash

curl -s -X PUT -H  "Content-Type:application/json" http://connect:8083/connectors/s3-backup/config \
  -d '{
  "connector.class": "io.confluent.connect.s3.source.S3SourceConnector",
  "confluent.topic.bootstrap.servers": "kafka1:9092",
  "tasks.max": "1",
  "topics": "users",
  "format.class": "io.confluent.connect.s3.format.avro.AvroFormat",
  "s3.bucket.name": "kafka",
  "storage.class": "io.confluent.connect.s3.storage.S3Storage",
  "store.url": "http://minio:9000/",
  "aws.access.key.id": "username",
  "aws.secret.access.key": "password"
}'
