#!/bin/bash

mkdir -p ${ORACLE_HOME} && \
mkdir -p ${ORA_INVENTORY} && \
mkdir -p ${INSTALL_DIR} && \
dnf install -y sudo hostname unzip bc binutils compat-openssl10 elfutils-libelf glibc glibc-devel ksh libaio libXrender libX11 libXau libXi libXtst libgcc libnsl libstdc++ libxcb libibverbs make policycoreutils policycoreutils-python-utils smartmontools sysstat unixODBC oracle-database-preinstall-21c && \
dnf -y upgrade && \
echo oracle:oracle | chpasswd && \
chown -R oracle:oinstall ${ORACLE_BASE} && \
chown -R oracle:oinstall ${ORACLE_HOME} && \
chown -R oracle:oinstall ${INSTALL_DIR} && \
chown -R oracle:oinstall ${ORA_INVENTORY}