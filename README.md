# Docker Images from OracleDataBase 21.3.0

## How to build and run

This project offers Dockerfiles for:

* Oracle Database 21c (21.3.0) Enterprise Edition and Standard Edition 2

### Building Oracle Database container images

**IMPORTANT:** You will have to provide the installation binaries of Oracle Database (except for Oracle Database 21.3.0c EE) and put them into the `dockerfiles/<version>` folder. In this project the binaries file is "LINUX.X64_213000_db_home.zip"


```bash
 tree .
.
├── Dockerfile
├── LINUX.X64_213000_db_home.zip
├── README.md
├── checkDBStatus.sh
├── checkSpace.sh
├── installDBBinaries.sh
├── packages
│   └── database-installation-guide-linux.pdf
├── run.sh
├── script
└── setupLinuxEnv.sh
```

Before you build the image make sure that you have provided the installation binaries and put them into the right folder. Once you have chosen which edition and version you want to build an image of, go into the **dockerfiles** folder and run the **docker build . -t oracle_21.3.0 --force-rm=true --no-cache=true --build-arg DB_EDITION=EE --build-arg ORACLE_HOSTNAME=localhost** command:

```bash
╰─ docker build . -t oracle_21.3.0 --force-rm=true --no-cache=true --build-arg DB_EDITION=EE --build-arg ORACLE_HOSTNAME=localhost                                                                               ─╯
[+] Building 1788.9s (15/15) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                                                           0.2s
 => => transferring dockerfile: 2.60kB                                                                                                                                                                         0.0s
 => [internal] load .dockerignore                                                                                                                                                                              0.1s
 => => transferring context: 57B                                                                                                                                                                               0.0s
 => [internal] load metadata for docker.io/library/oraclelinux:7-slim                                                                                                                                          4.4s
 => [auth] library/oraclelinux:pull token for registry-1.docker.io                                                                                                                                             0.0s
 => [base 1/3] FROM docker.io/library/oraclelinux:7-slim@sha256:eb026b1f7ac183287628fd9392c413eb0456fa5fd651ca691df14311d20a3dfe                                                                              36.4s
 => => resolve docker.io/library/oraclelinux:7-slim@sha256:eb026b1f7ac183287628fd9392c413eb0456fa5fd651ca691df14311d20a3dfe                                                                                    0.1s
 => => sha256:eb026b1f7ac183287628fd9392c413eb0456fa5fd651ca691df14311d20a3dfe 547B / 547B                                                                                                                     0.0s
 => => sha256:6e3443ef6e750bfe6ca61be41f7f7519784012a703141ff0e779d8a36e66e651 529B / 529B                                                                                                                     0.0s
 => => sha256:02b527a2b956548f5fed212bc72744feb24b05fe84c4427f925eebab5a0f7a6c 1.48kB / 1.48kB                                                                                                                 0.0s
 => => sha256:2294629c97e56d38612a31e50aa9a544bb9ea9a60646d016dcde035fd309dfe8 48.24MB / 48.24MB                                                                                                               7.6s
 => => extracting sha256:2294629c97e56d38612a31e50aa9a544bb9ea9a60646d016dcde035fd309dfe8                                                                                                                     26.9s
 => [internal] load build context                                                                                                                                                                            269.1s
 => => transferring context: 3.11GB                                                                                                                                                                          269.0s
 => [base 2/3] COPY setupLinuxEnv.sh checkSpace.sh  /opt/install/                                                                                                                                             39.6s
 => [base 3/3] RUN chmod ug+x /opt/install/*.sh &&     sync &&     /opt/install/checkSpace.sh &&     /opt/install/setupLinuxEnv.sh                                                                           219.9s
 => [builder 1/2] COPY --chown=oracle:oinstall LINUX.X64_213000_db_home.zip install_dbbinaries.rsp installDBBinaries.sh /opt/install/                                                                         40.3s
 => [builder 2/2] RUN chmod ug+x /opt/install/*.sh &&     sync &&     /opt/install/installDBBinaries.sh EE                                                                                                   539.9s
 => [stage-2 1/4] COPY --chown=oracle:oinstall --from=builder /u01/app/oracle /u01/app/oracle                                                                                                                161.3s
 => [stage-2 2/4] ADD run.sh /home/oracle/run.sh                                                                                                                                                               0.3s
 => [stage-2 3/4] RUN /u01/app/oracle/oraInventory/orainstRoot.sh &&     /u01/app/oracle/21c/dbhome/root.sh &&     chmod 755 /home/oracle/run.sh                                                               3.4s
 => [stage-2 4/4] WORKDIR /home/oracle                                                                                                                                                                         0.3s
 => exporting to image                                                                                                                                                                                       319.0s
 => => exporting layers                                                                                                                                                                                      319.0s
 => => writing image sha256:a17ab258405c723ca69a68d8ac2b1aa089efd3b23cf39353ec7b727836a701b3                                                                                                                   0.0s
 => => naming to docker.io/library/oracle_21.3.0```