#!/bin/bash

checkDatabaseRole() {
   # Obtain DB_ROLE using SQLPlus
   DB_ROLE=`sqlplus -s / << EOF
set heading off;
set pagesize 0;
SELECT database_role FROM v\\$database ;
exit;
EOF
`
   # Store return code from SQL*Plus
   ret=$?

   if [ $ret -eq 0 ] && [ "$DB_ROLE" != "PRIMARY" ] && [ "$DB_ROLE" != "PHYSICAL STANDBY" ]; then
      exit 1
   elif [ $ret -ne 0 ]; then
      exit 3
   fi
}

# Function to check if at least one PDB is open in "READ WRITE" mode for Primary database
# Or in case of Secondary Database PDBs should be opened only in "READ ONLY" mode 
checkPDBOpen() {
   # Obtain OPEN_MODE for PDB using SQLPlus
   PDB_OPEN_MODE=`sqlplus -s / << EOF
set heading off;
set pagesize 0;
SELECT DISTINCT open_mode FROM v\\$pdbs;
exit;
EOF
`
   # Store return code from SQL*Plus
   ret=$?

   if [ $ret -eq 0 ] && [ "$DB_ROLE" = "PRIMARY" ] && ! `echo $PDB_OPEN_MODE | grep -q "READ WRITE"`; then
      exit 2
   elif [ $ret -eq 0 ] && [ "$DB_ROLE" = "PHYSICAL STANDBY" ] && [ "$PDB_OPEN_MODE" != "READ ONLY" ]; then
      exit 2
   elif [ $ret -ne 0 ]; then
      exit 3
   fi
}

# Function to check that observer is running or not
checkObserver() {
   dg_observer_status="`dgmgrl sys/$ORACLE_PWD@$PRIMARY_DB_CONN_STR "show observer"`"
   echo ${dg_observer_status} | grep -q 'Observer ".*"'
   if [ $? -ne 0 ]; then
      exit 4
   fi 

}

#############################################
################ MAIN #######################
#############################################

if [ "$DG_OBSERVER_ONLY" = "true" ]; then
   checkObserver
else
   ORACLE_SID="`grep $ORACLE_HOME /etc/oratab | cut -d: -f1`"
   DB_ROLE=""
   ORAENV_ASK=NO
   source oraenv
   checkDatabaseRole
   checkPDBOpen
fi
exit 0

