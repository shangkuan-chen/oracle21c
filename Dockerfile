# FROM oraclelinux:8-slim as base
FROM oraclelinux:8.4 as base

LABEL "provider"="Shang-Kuan,Chen"                                               \
      "port.listener"="1521" 

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV ORACLE_BASE=/u01/app/oracle \
    ORA_INVENTORY=/u01/app/oraInventory \
    ORACLE_HOME=/u01/app/oracle/21c/dbhome\
    ORACLE_BASE_HOME=/u01/app/oracle/homes \
    INSTALL_DIR=/opt/install \
    INSTALL_FILE_1="LINUX.X64_213000_db_home.zip" \
    SETUP_LINUX_FILE="setupLinuxEnv.sh" \
    CHECK_SPACE_FILE="checkSpace.sh" \
    INSTALL_DB_BINARIES_FILE="installDBBinaries.sh" \
    CHECK_DB_FILE="checkDBStatus.sh"

# Use second ENV so that variable get substituted
ENV PATH=${ORACLE_HOME}/bin:${ORACLE_HOME}/OPatch/:/usr/sbin:$PATH \
    LD_LIBRARY_PATH=${ORACLE_HOME}/lib:/usr/lib \
    CLASSPATH=${ORACLE_HOME}/jlib:${ORACLE_HOME}/rdbms/jlib

# Copy files needed during both installation and runtime
# -------------
COPY $SETUP_LINUX_FILE ${CHECK_SPACE_FILE} ${CHECK_DB_FIL} ${INSTALL_DIR}/

ADD run.sh /run.sh

RUN chmod ug+x ${INSTALL_DIR}/*.sh && \
    sync && \
    ${INSTALL_DIR}/${CHECK_SPACE_FILE} && \
    ${INSTALL_DIR}/${SETUP_LINUX_FILE}

#############################################
# -------------------------------------------
# Start new stage for installing the database
# -------------------------------------------
#############################################
FROM base AS builder

ARG DB_EDITION
ARG ORACLE_HOSTNAME

# Copy DB install file
COPY --chown=oracle:oinstall $INSTALL_FILE_1 ${INSTALL_DB_BINARIES_FILE} $INSTALL_DIR/

# Install DB software binaries
USER oracle
RUN echo "chmod ug+x ${INSTALL_DIR}/*.sh && \
    sync && \
    ${INSTALL_DIR}/${INSTALL_DB_BINARIES_FILE} ${DB_EDITION}" > ${INSTALL_DIR}/run.txt

#############################################
# -------------------------------------------
# Start new layer for database runtime
# -------------------------------------------
#############################################

# FROM base

# USER oracle
# COPY --chown=oracle:oinstall --from=builder $ORACLE_BASE $ORACLE_BASE

# USER root
# RUN ${ORA_INVENTORY}/orainstRoot.sh && \
#     ${ORACLE_HOME}/root.sh

# USER oracle
# WORKDIR /home/oracle

# HEALTHCHECK --interval=1m --start-period=5m \
#    CMD "$ORACLE_BASE/$CHECK_DB_FILE" >/dev/null || exit 1

# Define default command to start Oracle Database. 
CMD ["/bin/bash", "-c", "/run.sh"]

# As a root user, execute the following script(s):
	# 1. /u01/app/oraInventory/orainstRoot.sh
	# 2. /u01/app/oracle/21c/dbhome/root.sh

# SEVERE:  [Sep 29, 2021 9:49:02 AM] [FATAL] [INS-35341] The installation user is not a member of the following groups: [dba, dba, dba, dba, dba]
#    CAUSE: The installation user account must be a member of all groups required for installation.
#    ACTION: Ensure that the installation user is a member of the system privileges operating system groups you selected.
