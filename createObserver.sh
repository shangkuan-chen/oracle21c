#!/bin/bash

set -e

# Validation: Check if PRIMARY_DB_CONN_STR is provided or not
if [ -z "${PRIMARY_DB_CONN_STR}" ]; then
    echo "ERROR: Please provide PRIMARY_DB_CONN_STR to connect with primary database. Exiting..."
    exit 1
fi

# Validation: Check if ORACLE_PWD (which is password for sys user of the primary database) is provided or not
if [ -z "${ORACLE_PWD}" ]; then
    echo "ERROR: Please provide sys user password of primary database as ORACLE_PWD. Exiting..."
    exit 1
fi

# Creating the directory for Observer configuration and log file
mkdir -p ${DG_OBSERVER_DIR}

# Starting observer in background
nohup dgmgrl -echo sys/${ORACLE_PWD}@${PRIMARY_DB_CONN_STR} "START OBSERVER ${DG_OBSERVER_NAME} FILE IS ${DG_OBSERVER_DIR}/fsfo.dat LOGFILE IS ${DG_OBSERVER_DIR}/observer.log" > ${DG_OBSERVER_DIR}/nohup.out &
# Sleep for dgmgrl to start observer in background otherwise container will exit
sleep 4
