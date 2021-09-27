#!/bin/bash
if [ "$ORACLE_HOME" == "" ]; then
  script_name=`basename "$0"`
  echo "$script_name: ERROR - ORACLE_HOME is not set. Please set ORACLE_HOME and PATH before invoking this script."
  exit 1;
fi;

# Start Listener
lsnrctl start

# Start database
sqlplus / as sysdba << EOF
   STARTUP;
   exit;
EOF
