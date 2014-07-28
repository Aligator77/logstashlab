#!/bin/bash

rm server.*

echo "This script requires go and will install go if needed"
go help
if [ "$?" != "0" ]; then
 # basic build stuff
 apt-get -y install build-essential

 # GO
 apt-get -y install python-software-properties
 apt-add-repository ppa:duh/golang
 apt-get update
 apt-get -y install golang
fi

go run lc-tlscert.go

mv selfsigned.key server.key
mv selfsigned.crt server.crt

