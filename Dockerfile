# FROM oraclelinux:8-slim as base
# FROM oraclelinux:8.4 as base
FROM oraclelinux:7-slim as base

LABEL "provider"="Shang-Kuan,Chen"                                               \
      "port.listener"="1521" 

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV ORACLE_BASE=/u01/app/oracle \
    ORACLE_HOME=/u01/app/oracle/21c/dbhome\
    INSTALL_DIR=/opt/install \
    INSTALL_FILE_1="LINUX.X64_213000_db_home.zip" \
    SETUP_LINUX_FILE="setupLinuxEnv.sh" \
    CV_ASSUME_DISTID=OEL7 \
    CHECK_SPACE_FILE="checkSpace.sh" \
    INSTALL_DB_BINARIES_FILE="installDBBinaries.sh" \
    CHECK_DB_FILE="checkDBStatus.sh" \
    INSTALL_RSP="install_dbbinaries.rsp"

# Use second ENV so that variable get substituted
ENV PATH=${ORACLE_HOME}/bin:${ORACLE_HOME}/OPatch/:/usr/sbin:$PATH \
    LD_LIBRARY_PATH=${ORACLE_HOME}/lib:/usr/lib \
    CLASSPATH=${ORACLE_HOME}/jlib:${ORACLE_HOME}/rdbms/jlib

# Copy files needed during both installation and runtime
# -------------
COPY ${SETUP_LINUX_FILE} ${CHECK_SPACE_FILE} ${CHECK_DB_FIL} ${INSTALL_DIR}/

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
COPY --chown=oracle:oinstall ${INSTALL_FILE_1} ${INSTALL_RSP} ${INSTALL_DB_BINARIES_FILE} ${INSTALL_DIR}/

# Install DB software binaries
USER oracle
RUN chmod ug+x ${INSTALL_DIR}/*.sh && \
    sync && \
    ${INSTALL_DIR}/${INSTALL_DB_BINARIES_FILE} ${DB_EDITION}

#############################################
# -------------------------------------------
# Start new layer for database runtime
# -------------------------------------------
#############################################
FROM base

USER oracle
COPY --chown=oracle:oinstall --from=builder ${ORACLE_BASE} ${ORACLE_BASE}
ADD run.sh /home/oracle/run.sh

USER root
RUN ${ORACLE_BASE}/oraInventory/orainstRoot.sh && \
    ${ORACLE_HOME}/root.sh && \
    chmod 755 /home/oracle/run.sh

USER oracle
WORKDIR /home/oracle

HEALTHCHECK --interval=1m --start-period=5m \
   CMD "$ORACLE_BASE/$CHECK_DB_FILE" >/dev/null || exit 1

# Define default command to start Oracle Database. 
EXPOSE 1521/tcp
CMD ["/bin/bash","/home/oracle/run.sh"]