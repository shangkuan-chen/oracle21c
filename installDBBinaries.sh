#!/bin/bash

EDITION=${1^^}

# Install Oracle binaries
cd ${ORACLE_HOME} && \
mv ${INSTALL_DIR}/${INSTALL_FILE_1} ${ORACLE_HOME}/ && \
unzip ${INSTALL_FILE_1} && \
rm ${INSTALL_FILE_1} && \
${ORACLE_HOME}/runInstaller -silent -force -ignorePrereqFailure -waitforcompletion \
-responseFile ${ORACLE_HOME}/install/response/db_install.rsp \
ORACLE_HOSTNAME=`hostname` \
oracle.install.option=INSTALL_DB_SWONLY \
UNIX_GROUP_NAME=oinstall \
INVENTORY_LOCATION=${ORA_INVENTORY} \
SELECTED_LANGUAGES=en,en_GB \
ORACLE_HOME=${ORACLE_HOME} \
ORACLE_BASE=${ORACLE_BASE} \
oracle.install.db.InstallEdition=${EDITION} \
oracle.install.db.OSDBA_GROUP=oinstall \
oracle.install.db.OSBACKUPDBA_GROUP=oinstall \
oracle.install.db.OSDGDBA_GROUP=oinstall \
oracle.install.db.OSKMDBA_GROUP=oinstall \
oracle.install.db.OSRACDBA_GROUP=oinstall \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false \
DECLINE_SECURITY_UPDATES=true