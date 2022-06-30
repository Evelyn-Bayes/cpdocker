#!/bin/bash

set -o nounset \
    -o errexit \
    -o verbose \
    -o xtrace

VALIDITY=365

# Cleanup old keystore/truststores
rm -f *.jks *_creds

# Generate CA key
openssl req -new -x509 -keyout cacert.key -out cacert.crt -days $VALIDITY  -subj '/CN=ca1.test.confluent.io/OU=TEST/O=CONFLUENT/L=PaloAlto/S=Ca/C=US' -passout pass:confluent 

for i in kafka1 kafka2 kafka3 client admintool connect schemaregistry restproxy controlcenter ksqldb
do
	echo $i

  # Import the CA cert
  keytool -keystore kafka.$i.truststore.jks -alias CARoot -import -file cacert.crt -storepass confluent -keypass confluent <<< "yes"
  keytool -keystore kafka.$i.keystore.jks -alias CARoot -import -file cacert.crt -storepass confluent -keypass confluent <<< "yes"

  # Create cert
  keytool -keystore kafka.$i.keystore.jks -alias $i -validity $VALIDITY -genkey -keyalg RSA -noprompt -dname "CN=$i, OU=TEST, O=CONFLUENT, L=PaloAlto, S=Ca, C=US" -storepass confluent -keypass confluent

  # Create cert request and sign it
  keytool -keystore kafka.$i.keystore.jks -alias $i -certreq -file kafka.$i.csr -storepass confluent -keypass confluent
  openssl x509 -req -CA cacert.crt -CAkey cacert.key -in kafka.$i.csr -out kafka.$i.crt -days $VALIDITY -passin pass:confluent  -CAcreateserial

  # Import signed cert
  keytool -keystore kafka.$i.keystore.jks -alias $i -import -file kafka.$i.crt -storepass confluent -keypass confluent <<< "yes"

  # Create key files
  echo "confluent" > ${i}_sslkey_creds
  echo "confluent" > ${i}_keystore_creds
  echo "confluent" > ${i}_truststore_creds
done

# Cleanup the certs etc used in the process
rm -f *.crt *.csr *.key *.srl
