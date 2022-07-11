#!/bin/bash

curl -X "POST" "http://ksqldb:8088/ksql" -H "Accept: application/vnd.ksql.v1+json" -d $'{"ksql": "CREATE STREAM clickstream (user_id INT, page VARCHAR, status VARCHAR, user_agent VARCHAR, action VARCHAR) WITH (KAFKA_TOPIC=\'clickstream\', PARTITIONS=3, VALUE_FORMAT=\'AVRO\');", "streamsProperties": {}}'

for i in {0..99}
do
    ids[$i]=$i
done

websites[0]='https://www.confluent.io/'
websites[1]='https://developer.confluent.io/'
websites[2]='https://www.confluent.io/what-is-apache-kafka/'
websites[3]='https://kafka.apache.org/documentation/'

statuses[0]='SUCCESS'
statuses[1]='ERROR'

user_agent[0]='Mozilla/5.0.1'
user_agent[1]='Mozilla/5.1.0'
user_agent[2]='Chrome/103.0.5060.66'

actions[0]='OPEN'
actions[1]='CLOSE'
actions[2]='RELOAD'

for i in {1..100000}
do
   id_selection=$[$RANDOM % ${#ids[@]}]
   website_selection=$[$RANDOM % ${#websites[@]}]
   status_selection=$[$RANDOM % ${#statuses[@]}]
   user_agent_selection=$[$RANDOM % ${#user_agent[@]}]
   action_selection=$[$RANDOM % ${#actions[@]}]
   command='INSERT INTO clickstream (user_id, page, status, user_agent, action) VALUES ('${ids[$id_selection]}', '"\'"${websites[$website_selection]}"\'"', '"\'"${statuses[$status_selection]}"\'"', '"\'"${user_agent[$user_agent_selection]}"\'"', '"\'"${actions[$action_selection]}"\'"');'
   curl_command='curl -X "POST" "http://ksqldb:8088/ksql" -H "Accept: application/vnd.ksql.v1+json" -d $'"'"'{"ksql": "'$command'", "streamsProperties": {}}'"'"
   eval $curl_command 
   sleep 1
done
