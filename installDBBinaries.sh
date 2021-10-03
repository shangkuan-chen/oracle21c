#!/bin/bash

EDITION=${1^^}

sed -i "s,###ORACLE_BASE###,${ORACLE_BASE},g" "${INSTALL_DIR}"/"${INSTALL_RSP}" && \
sed -i "s,###ORACLE_HOME###,${ORACLE_HOME},g" "${INSTALL_DIR}"/"${INSTALL_RSP}" && \
sed -i "s,###DB_EDITION###,${DB_EDITION},g" "${INSTALL_DIR}"/"${INSTALL_RSP}"

# Install Oracle binaries
cd ${ORACLE_HOME} && \
mv ${INSTALL_DIR}/${INSTALL_FILE_1} ${ORACLE_HOME}/ && \
unzip ${INSTALL_FILE_1} && \
rm ${INSTALL_FILE_1} && \
${ORACLE_HOME}/runInstaller -silent -force -waitforcompletion \
-responsefile ${INSTALL_DIR}/${INSTALL_RSP} -ignorePrereqFailure \
SELECTED_LANGUAGES=en,en_GB && \
cd ${ORACLE_HOME}