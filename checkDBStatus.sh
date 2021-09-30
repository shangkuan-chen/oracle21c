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

#############################################
################ MAIN #######################
#############################################

ORACLE_SID="`grep $ORACLE_HOME /etc/oratab | cut -d: -f1`"
DB_ROLE=""
ORAENV_ASK=NO
source oraenv
checkDatabaseRole

exit 0