# Docker Images from OracleDataBase 21.3.0

## How to build and run

This project offers Dockerfiles for:

* Oracle Database 21c (21.3.0) Enterprise Edition and Standard Edition 2

### Building Oracle Database container images

**IMPORTANT:** You will have to provide the installation binaries of Oracle Database (except for Oracle Database 21.3.0c EE) and put them into the `dockerfiles/<version>` folder. In this project the binaries file is "LINUX.X64_213000_db_home.zip"


```bash
❯ tree .
.
├── Checksum.ee
├── Checksum.se2
├── Dockerfile
├── LINUX.X64_213000_db_home.zip
├── checkDBStatus.sh
├── checkSpace.sh
├── createDB.sh
├── createObserver.sh
├── db_inst.rsp
├── dbca.rsp.tmpl
├── installDBBinaries.sh
├── relinkOracleBinary.sh
├── runOracle.sh
├── runUserScripts.sh
├── setPassword.sh
├── setupLinuxEnv.sh
└── startDB.sh
```

Before you build the image make sure that you have provided the installation binaries and put them into the right folder. Once you have chosen which edition and version you want to build an image of, go into the **dockerfiles** folder and run the **docker build . -t oracle_21.3.0 --build-arg DB_EDITION=ee** command:

```bash
 docker build . -t oracle_21.3.0 --build-arg DB_EDITION=ee
[+] Building 2.3s (15/15) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                       0.0s
 => => transferring dockerfile: 434B                                                                                                                                       0.0s
 => [internal] load .dockerignore                                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                                            0.0s
 => [internal] load metadata for docker.io/library/oraclelinux:7-slim                                                                                                      2.2s
 => [auth] library/oraclelinux:pull token for registry-1.docker.io                                                                                                         0.0s
 => [base 1/4] FROM docker.io/library/oraclelinux:7-slim@sha256:9941f4f558d0e6892901263cd2670f6c95978c2699c1947aaa32c2361004fa45                                           0.0s
 => [internal] load build context                                                                                                                                          0.0s
 => => transferring context: 5.90kB                                                                                                                                        0.0s
 => CACHED [base 2/4] COPY setupLinuxEnv.sh checkSpace.sh /opt/install/                                                                                                    0.0s
 => CACHED [base 3/4] COPY runOracle.sh startDB.sh createDB.sh createObserver.sh dbca.rsp.tmpl setPassword.sh checkDBStatus.sh runUserScripts.sh relinkOracleBinary.sh /o  0.0s
 => CACHED [base 4/4] RUN chmod ug+x /opt/install/*.sh &&     sync &&     /opt/install/checkSpace.sh &&     /opt/install/setupLinuxEnv.sh &&     rm -rf /opt/install       0.0s
 => CACHED [builder 1/2] COPY --chown=oracle:dba LINUX.X64_213000_db_home.zip db_inst.rsp installDBBinaries.sh /opt/install/                                               0.0s
 => CACHED [builder 2/2] RUN chmod ug+x /opt/install/*.sh &&     sync &&     /opt/install/installDBBinaries.sh ee                                                          0.0s
 => CACHED [stage-2 1/3] COPY --chown=oracle:dba --from=builder /opt/oracle /opt/oracle                                                                                    0.0s
 => CACHED [stage-2 2/3] RUN /opt/oracle/oraInventory/orainstRoot.sh &&     /opt/oracle/product/21c/dbhome_1/root.sh                                                       0.0s
 => CACHED [stage-2 3/3] WORKDIR /home/oracle                                                                                                                              0.0s
 => exporting to image                                                                                                                                                     0.0s
 => => exporting layers                                                                                                                                                    0.0s
 => => writing image sha256:51504d31cfb7a48eadbcb8de9c8f97485354d59481269b6a9d852e807a249ad8                                                                               0.0s
 => => naming to docker.io/library/oracle_21.3.0
```

