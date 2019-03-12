#!/bin/bash

echo "Starting sigsci-agent"
/sbin/sigsci-agent &
asadmin start-domain -v

