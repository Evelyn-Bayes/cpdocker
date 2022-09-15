#!/bin/bash

curl -s -X PUT -H  "Content-Type:application/json" http://connect:8083/connectors/s3-backup/config \
  -d '{
  "connector.class": "io.confluent.connect.s3.source.S3SourceConnector",
  "confluent.topic.bootstrap.servers": "kafka1:9092",
  "tasks.max": "1",
  "key.converter": "org.apache.kafka.connect.storage.StringConverter",
  "value.converter": "org.apache.kafka.connect.storage.StringConverter",
  "topics": "s3-data",
  "format.class": "io.confluent.connect.s3.format.json.JsonFormat",
  "flush.size": "100",
  "schema.compatibility": "NONE",
  "s3.bucket.name": "kafka",
  "s3.region": "us-east-1",
  "storage.class": "io.confluent.connect.s3.storage.S3Storage",
  "store.url": "http://minio:9000/",
  "partitioner.class": "io.confluent.connect.storage.partitioner.DefaultPartitioner",
  "aws.access.key.id": "username",
  "aws.secret.access.key": "password",
  "s3.part.size":"5242880",
  "path.format":"'date'=YYYY-MM-dd/'hour'=HH",
  "partition.duration.ms":"3600000",
  "rotate.interval.ms":"60000",
  "timestamp.extractor":"Record"
}'
