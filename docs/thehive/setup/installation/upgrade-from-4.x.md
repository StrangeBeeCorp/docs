# Upgrade from TheHive 4.x

!!! Info
    This guide describes how to upgrade TheHive from version **4.1.x** to **5.0.x**.

    This guide is **for standalone servers only**, and considers: 

    - The application is running on a [supported Linux operating system](../index.md#operating-systems)
    - The server meets [prerequisites](../index.md#requirements) regaring CPU & RAM.

!!! Warning "Switch to Elasticsearch as indexing engine"
    If using Lucene as indexing engine with TheHive 4.1.x,  reindexing the data is mandatory. It might take some time ragarding the size of your database. 


## Preparation

The Database application will be upgraded during the upgrade. We highly recommend making backups of the database, index and files before running the operation.

!!! Note "FAQ"
    **Q:** **How to make backups ?**

    **A:** _Read our [backup and restore guide](../operations/backup-restore.md)_


### Stop all running applications
 
1. Start by stopping TheHive:

    ```bash title="stop thehive service"
    sudo systemctl stop thehive
    ```

2. Once TheHive is sucessfully stopped, stop database service

    ```bash title="stop cassandra service"
    sudo systemctl stop cassandra
    ```

3. Only if already using Elasticsearch as indexing engine
    ```bash title="stop elasticsearch service"
    sudo systemctl stop elasticsearch
    ```


## Upgrade Java
Follow the [installation process](step-by-step-guide.md#java-virtual-machine) to install the required version. 


## Upgrade or install Elasticsearch
Follow the [installation process](step-by-step-guide.md#elasticsearch) to install and configure the required version.

## Upgrade Cassandra

### Backup configuration file
Save the existing configuration file for Cassandra 3.x. It will be used later to configure Cassandra 4:

```bash
sudo cp /etc/cassandra/cassandra.yaml /etc/cassandra/cassandra3.yaml.bak
```

### Install Cassandra 
Follow the [installation process](step-by-step-guide.md#cassandra) to install the required version.

During the installation process, replace existing configuration files (*as the old configuration is saved"): 

```
Configuration file '/etc/cassandra/cassandra.yaml'
 ==> Modified (by you or by a script) since installation.
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** cassandra.yaml (Y/I/N/O/D/Z) [default=N] ? Y
```

### Configuration

Update the new configuration file, and ensure following parameters are correctly set with this values:

```
cluster_name: 'thp'
num_tokens: 256
```

!!! Info
    If you had a more customised configuration file for Cassandra 3.x, review all the file and ensure to adapt it accordingly.

### Start the service

```
sudo systemctl start cassandra
```

## Install thehive

### Prepare for the new installation

!!! Tip "TheHive configuration file: /etc/thehive/application.conf"
    Starting with TheHive 5.0.0, configuration has been simplified; most of all administration parameters can be configured directly in the UI. The configuration file (`/etc/thehive/application.conf`) contains **only** the necessary information to start the application sucessfully; that means: 

    - Secret
    - Database
    - Indexing engine
    - File storage
    - Enabled connectors 
    - (Akka in the case of a cluster)

    Authentication, Webhooks, Cortex and MISP configuration can be done in the UI. 

1. Save your current configuration file: 

    ```bash
    sudo cp /etc/thehive/application.conf /etc/thehive/application.conf.bak
    ```

2. For the current use case, i.e. a standalone server, the final configuration file should look like this:

    ```yaml title="sample of /etc/thehive/application.conf"
    # TheHive configuration - application.conf
    #
    #
    # This is the default configuration file.
    # This is prepared to run with all services locally:
    # - Cassandra for the database
    # - Elasticsearch for index engine
    # - File storage is local in /opt/thp/thehive/files
    #
    # If this is not your setup, please refer to the documentation at:
    # https://docs.thehive-project.org/thehive/
    #
    #
    # Secret key - used by Play Framework
    # If TheHive is installed with DEB/RPM package, this is automatically generated
    # If TheHive is not installed from DEB or RPM packages run the following
    # command before starting thehive:
    #   cat > /etc/thehive/secret.conf << _EOF_
    #   play.http.secret.key="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 |#   head -n 1)"
    #   _EOF_
    include "/etc/thehive/secret.conf"


    # Database and index configuration
    # By default, TheHive is configured to connect to local Cassandra 4.x and a
    # local Elasticsearch services without authentication.
    db.janusgraph {
      storage {
        backend = cql
        hostname = ["127.0.0.1"]
        # Cassandra authentication (if configured)
        # username = "thehive"
        # password = "password"
        cql {
          cluster-name = thp
          keyspace = thehive
        }
      }
      index.search {
        backend = elasticsearch
        hostname = ["127.0.0.1"]
        index-name = thehive
      }
    }

    # Attachment storage configuration
    # By default, TheHive is configured to store files locally in the folder.
    # The path can be updated and should belong to the user/group running thehive service. (by default: thehive:thehive)
    storage {
      provider = localfs
      localfs.location = /opt/thp/thehive/files
    }

    # Define the maximum size for an attachment accepted by TheHive
    play.http.parser.maxDiskBuffer = 1GB
    # Define maximum size of http request (except attachment)
    play.http.parser.maxMemoryBuffer = 10M

    # Service configuration
    application.baseUrl = "http://localhost:9000"
    play.http.context = "/"

    # Additional modules
    #
    # TheHive is strongly integrated with Cortex and MISP.
    # Both modules are enabled by default. If not used, each one can be disabled by
    # commenting the configuration line.
    scalligraph.modules += org.thp.thehive.connector.cortex.CortexModule
    scalligraph.modules += org.thp.thehive.connector.misp.MispModule
    ```

    !!! Note
        By default, Cortex and MISP modules are enabled. If not using one of them, the corresponding line can be commented.

        **Our recommendation**: use the default configuration sample, update it with your custom parameters values, and keep the old file to configure services in the web UI. 

### Specific configuration required (for the upgrade only)

```
db.janusgraph.index.search.elasticsearch.bulk-refresh = false
```

### Install TheHive

=== "DEB"

    - Update the repository address

    ```bash
    wget -O- https://archives.strangebee.com/keys/strangebee.gpg | sudo gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
    sudo rm /etc/apt/sources.list.d/thehive-project.list ; echo 'deb [signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com thehive-5.x main' | sudo tee -a /etc/apt/sources.list.d/strangebee.list
    ```

    - Install new package - old package of `thehive4` will be removed
  
    ```bash
    sudo apt update
    sudo apt install thehive
    ```

=== "RPM"

    - Add Cassandra repository keys

    ```bash
    rpm --import https://downloads.apache.org/cassandra/KEYS
    ```

    - Update the Apache repository for Cassandra to `/etc/yum.repos.d/cassandra.repo`
      
    ```bash title="/etc/yum.repos.d/cassandra.repo"
    [cassandra]
    name=Apache Cassandra
    baseurl=https://downloads.apache.org/cassandra/redhat/40x/
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://downloads.apache.org/cassandra/KEYS
    ```

    - Install the package

    ```bash
    sudo yum install cassandra
    ```

During the installation, if you already prepared your configuration file, continue **without** updating it with the maintainer's version.

  ```
  Configuration file '/etc/thehive/application.conf'
  ==> Modified (by you or by a script) since installation.
  ==> Package distributor has shipped an updated version.
    What would you like to do about it ?  Your options are:
      Y or I  : install the package maintainer's version
      N or O  : keep your currently-installed version
        D     : show the differences between the versions
        Z     : start a shell to examine the situation
  The default action is to keep your current version.
  *** application.conf (Y/I/N/O/D/Z) [default=N] ? N
  ```

### Start services

```bash
sudo systemctl daemon-reload
```

- Start Cassandra

```bash
sudo systemctl start cassandra
```

- Start Elasticsearch

```bash
sudo systemctl start elasticsearch
```

- Once both database services are started successfully, start TheHive

```bash
sudo systemctl start thehive
```


!!! Warning "The first start of TheHive 5.0.x can take some time"
    When starting, TheHive is updating first the database schema, and proceed to reindexation. Both processes can take a certain time depending on the size of the database and the amount of data.
    Progression can be followed in log file `/etc/thehive/application.log`. See [Troubleshooting](#troubleshooting) for more information.

### Restart the service
Once the service is started successfully, update the configuration file and remove the following line:

```yaml title="/etc/thehive/application.conf"
db.janusgraph.index.search.elasticsearch.bulk-refresh = false
```

Then restart TheHive:

```
sudo systemctl restart thehive
```


## Troubleshooting

During the update, few logs can be seen in TheHive `application.log` file. 

!!! Example "Example of logs and what they mean"

    ```
    2022-03-24 11:48:20,743 [INFO] from org.janusgraph.graphdb.database.management.GraphIndexStatusWatcher in application-akka.actor.default-dispatcher-11 [|] Some key(s) on index global2 do not currently have status(es) [REGISTERED, ENABLED]: dateValue=INSTALLED,externalLink=INSTALLED,origin=INSTALLED,patternId=INSTALLED,revoked=INSTALLED,mandatory=INSTALLED,content=INSTALLED,isAttachment=INSTALLED,writable=INSTALLED,tactic=INSTALLED,stringValue=INSTALLED,owningOrganisation=INSTALLED,permissions=INSTALLED,actionRequired=INSTALLED,integerValue=INSTALLED,details=INSTALLED,locked=INSTALLED,slug=INSTALLED,cortexId=INSTALLED,owner=INSTALLED,workerId=INSTALLED,apikey=INSTALLED,level=INSTALLED,floatValue=INSTALLED,version=INSTALLED,occurDate=INSTALLED,url=INSTALLED,report=INSTALLED,tactics=INSTALLED,booleanValue=INSTALLED,cortexJobId=INSTALLED,category=INSTALLED,workerName=INSTALLED
    ```
    _TheHive install indexes of the new schema in the database_ 

    ---

    ```
    2022-03-24 11:48:42,806 [INFO] from org.janusgraph.graphdb.olap.job.IndexRepairJob in Thread-97 [|] Index global2 metrics: success-tx: 1 doc-updates: 100 succeeded: 100
    ```
    _TheHive reindexes all data_

    ---

    ```
    * UPDATE SCHEMA OF thehive-enterprise (1): Create initial values
    2022-03-24 11:55:12,239 [INFO] from org.thp.scalligraph.models.Operations in application-akka.actor.default-dispatcher-11 [d471d8b643d17b6d|d88fe62679b77ab1] Adding initial values for GDPRDummy
    [..]
    2022-03-24 11:55:32,533 [INFO] from org.thp.scalligraph.models.Operations in application-akka.actor.default-dispatcher-11 [|] Update graph in progress (100): Add pap and ignoreSimilarity to observables
    ```
    _Migrating data from v4. to v5._

    ---

    ```
    2022-03-24 12:01:45,385 [WARN] from org.thp.thehive.enterprise.services.LicenseSrv in main [ef39c95eaa6de532|0ccf187e40a4cd34] No license found
    ```
    _No license found. This is a normal behaviour during the upgrade from version 4 to 5.

    ---

    ```
    2022-03-24 12:01:58,525 [INFO] from play.core.server.AkkaHttpServer in main [|] Listening for HTTP on /0:0:0:0:0:0:0:0:9000
    ```
    _The service is available. Users/Administrators can log in_

    ---

    ```
    2022-03-24 12:01:58,351 [INFO] from org.thp.thehive.connector.cortex.services.CortexDataImportActor in application-akka.actor.default-dispatcher-16 [|] Analyzer templates already present (found 203), skipping
    [..]
    2022-03-24 12:02:14,659 [INFO] from org.thp.thehive.services.ttp.PatternImportActor in application-akka.actor.default-dispatcher-14 [|] Import finished, 707 patterns imported
    ```
    _Few operations are processed after making the service available, like installing MITRE Enterprise ATT&CK patterns catalog or Analyzers templates._

    ---

    ```
    2022-03-24 16:50:41,884 [ERROR] from org.janusgraph.diskstorage.log.util.ProcessMessageJob in pool-22-thread-1 [|] Encountered exception when processing message [Message@2022-03-24T16:50:40.655134Z:7f0001017672-ubuntu2=0x809F9F0568850528850550850558850570850600850610850618850650850668850710850738850758850760850808850900850910850A60850A70850A78850B00850B08853520853B3885150E8941608541688541788542088542688542708581] by reader [org.janusgraph.graphdb.database.management.ManagementLogger@3e1a6eae]:java.lang.IllegalStateException: Cannot access element because its enclosing transaction is closed and unbound
    at org.janusgraph.graphdb.transaction.StandardJanusGraphTx.getNextTx(StandardJanusGraphTx.java:380)
    at org.janusgraph.graphdb.vertices.AbstractVertex.it(AbstractVertex.java:61)
    at org.janusgraph.graphdb.relations.CacheVertexProperty.<init>(CacheVertexProperty.java:38)
    at org.janusgraph.graphdb.transaction.RelationConstructor.readRelation(RelationConstructor.java:88)
    at org.janusgraph.graphdb.transaction.RelationConstructor.readRelation(RelationConstructor.java:71)
    at org.janusgraph.graphdb.transaction.RelationConstructor$1.next(RelationConstructor.java:57)
    at org.janusgraph.graphdb.transaction.RelationConstructor$1.next(RelationConstructor.java:45)
    at org.janusgraph.graphdb.types.vertices.JanusGraphSchemaVertex.getDefinition(JanusGraphSchemaVertex.java:94)
    at org.janusgraph.graphdb.transaction.StandardJanusGraphTx.expireSchemaElement(StandardJanusGraphTx.java:1599)
    at org.janusgraph.graphdb.database.management.ManagementLogger.read(ManagementLogger.java:97)
    at org.janusgraph.diskstorage.log.util.ProcessMessageJob.run(ProcessMessageJob.java:46)
    at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:515)
    at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
    at java.base/java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(ScheduledThreadPoolExecutor.java:304)
    at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
    at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
    at java.base/java.lang.Thread.run(Thread.java:829)
    ```

    _During indexing, Janusgraph may display this message, this error is coming from a [bug in janusgraph](https://github.com/JanusGraph/janusgraph/pull/2899), don't mind it as the indexing will continue normally. This will have no impact on TheHive_
