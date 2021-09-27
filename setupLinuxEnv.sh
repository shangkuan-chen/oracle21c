#!/bin/bash
mkdir -p $ORACLE_BASE/scripts/setup && \
mkdir $ORACLE_BASE/scripts/startup && \
mkdir -p $ORACLE_BASE/scripts/extensions/setup && \
mkdir $ORACLE_BASE/scripts/extensions/startup && \
ln -s $ORACLE_BASE/scripts /docker-entrypoint-initdb.d && \
mkdir $ORACLE_BASE/oradata && \
mkdir -p $ORACLE_HOME && \
chmod ug+x $ORACLE_BASE/*.sh && \
yum -y install oracle-database-preinstall-21c openssl && \
rm -rf /var/cache/yum && \
ln -s $ORACLE_BASE/$PWD_FILE /home/oracle/ && \
echo oracle:oracle | chpasswd && \
chown -R oracle:dba $ORACLE_BASE
