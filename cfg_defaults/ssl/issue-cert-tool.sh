#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
RED='\033[0;31m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[1;34m'
LIGHTGREEN='\033[1;32m'
NC='\033[0m' # No Color
OUTPUT_DIR="$SCRIPT_DIR/certificates"

if [ ! -d $OUTPUT_DIR ]; then
  mkdir $OUTPUT_DIR
fi

echo
echo
echo "------------------"
echo
echo -e "${RED}DEVOPS-MGMT CERTIFICATE ISSUER${NC}"
echo -e "    This script will generate a new ssl certificate with the rootCA stored at ${LIGHTBLUE}$SCRIPT_DIR/rootCA.key${NC}"
echo -e "    DESTINATION: ${LIGHTBLUE}${OUTPUT_DIR}/${NC}"
echo
echo "------------------"
echo
echo "FQDN or CN name examples, do not use wilcards, this generator automatically adds a wilcard prefix:"
echo "-    myserver.localhost (will secure myserver.localhost and *.myserver.localhost)"
echo "-    localhost      (will secure localhost and *.localhost)"
echo "-    www.myservice.dev  (will secure www.myservice.dev and *.www.myservice.dev)"
echo "-    myservice.dev  (will secure myservice.dev and *.myservice.dev)"
echo -e "${RED}Server FQDN or Common Name?${NC}"
read userFqdn

echo
echo "------------------"
echo
echo "Certificate file name examples:"
echo "-    myserver_localhost"
echo "-    localhost"
echo "-    www_myservice_dev"
echo "-    myservice_dev"
DEFAULT_FILE=$(echo $userFqdn | sed -e "s/*/all/g" | sed -e "s/\./_/g")
echo -e "${RED}Certificate name?${NC} (used for the filename, it will overwrite) [Default: ${LIGHTBLUE}$DEFAULT_FILE${NC}]"
read userFileName
if [ -z "$userFileName" ]; then
  userFileName=$DEFAULT_FILE
fi

echo
echo "------------------"
CONFIG=$(cat $SCRIPT_DIR/in_csr.cnf | sed -e "s/FQDN/$userFqdn/g")
echo -e "${LIGHTBLUE}$CONFIG${NC}"
echo "------------------"
CONFIG_EXT=$(cat $SCRIPT_DIR/in_v3.ext | sed -e "s/FQDN/$userFqdn/g")
echo -e "${LIGHTBLUE}$CONFIG_EXT${NC}"
echo "------------------"

echo
echo "Generating private KEY and CSR (Certificate Signing Request)..."
openssl req -new -sha256 -nodes -out $OUTPUT_DIR/$userFileName.csr -newkey rsa:2048 -keyout $OUTPUT_DIR/$userFileName.key -config <( echo "$CONFIG")

echo "Generating certificate for 10 years..."
if [ ! -e $SCRIPT_DIR/rootCA.srl ]; then
  # CA serial file doesn't exist
  openssl x509 -req -in $OUTPUT_DIR/$userFileName.csr -CA $SCRIPT_DIR/rootCA.pem -CAkey $SCRIPT_DIR/rootCA.key -CAserial $SCRIPT_DIR/rootCA.srl -CAcreateserial -out $OUTPUT_DIR/$userFileName.crt -days 3650 -sha256 -extfile <( echo "$CONFIG_EXT")
else
  # CA serial file does exist
  openssl x509 -req -in $OUTPUT_DIR/$userFileName.csr -CA $SCRIPT_DIR/rootCA.pem -CAkey $SCRIPT_DIR/rootCA.key -CAserial $SCRIPT_DIR/rootCA.srl -out $OUTPUT_DIR/$userFileName.crt -days 3650 -sha256 -extfile  <( echo "$CONFIG_EXT")
fi

echo
echo -e "${LIGHTBLUE}Certificate generated successfully${NC}"
echo -e "- Certificate signed request: ${LIGHTBLUE}${OUTPUT_DIR}/${LIGHTGREEN}$userFileName.csr${NC}"
echo -e "- Certificate private key: ${LIGHTBLUE}${OUTPUT_DIR}/${LIGHTGREEN}$userFileName.key${NC}"
echo -e "- Public certificate: ${LIGHTBLUE}${OUTPUT_DIR}/${LIGHTGREEN}$userFileName.crt${NC}"
echo