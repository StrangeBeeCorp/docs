# Upgrade from TheHive 4.x

This guide provides comprehensive instructions for upgrading TheHive from version 4.1.x to 5.0.x. Please ensure that your system meets the following requirements:

- The application is running on a supported Linux operating system.
- The server meets prerequisites regarding CPU & RAM.

If you are using a cluster setup, specific notes are provided to guide you through the process.

---

## Important Considerations

**Switch to Elasticsearch as indexing engine**: TheHive 5.x utilizes Elasticsearch as the indexing engine. If you were using Lucene as the indexing engine with TheHive 4.1.x, reindexing the data is mandatory. Please note that this process may take some time depending on the size of your database.

---

## Preparation

??? Abstract "I'm Using a Cluster"
    Please ensure that the instructions under this section are followed on all nodes of the cluster.

&nbsp;

### Database Backup

Before proceeding with the upgrade, ensure to back up the following components:

- Database
- Index
- Files

For detailed instructions on how to perform backups, refer to our [**backup and restore guide**](../operations/backup-restore/overview.md).

&nbsp;

### Ensure Admin User Access

Ensure that you can log in as an admin user with a password in TheHive database. By default, the local auth provider should be enabled.

&nbsp;

### Stop all Running Applications
 
1. Start by stopping TheHive:

    ```bash
    sudo systemctl stop thehive
    ```

2. Once TheHive is successfully stopped, stop the database service:

    ```bash
    sudo systemctl stop cassandra
    ```

3. If already using Elasticsearch as the indexing engine, stop the Elasticsearch service:

    ```bash
    sudo systemctl stop elasticsearch
    ```

---

## Upgrade Java

??? Abstract "I'm Using a Cluster"
    Please ensure that the instructions under this section are followed on all nodes of the cluster.


Follow the [**installation process**](./step-by-step-installation-guide.md#java-virtual-machine) to install the required version of Java.

---

## Upgrade or Install Elasticsearch

??? Abstract "I'm Using a Cluster"
    Elasticsearch is crucial for TheHive 5.x clusters. However, if an update isn't urgently required, focus on upgrading Cassandra first.

Elasticsearch is mandatory for TheHive 5.x clusters. Follow the [**installation process**](./step-by-step-installation-guide.md#elasticsearch) to install and configure the required version.

---

## Upgrade Cassandra

??? Abstract "I'm Using a Cluster"
    For each node within the Cassandra cluster, it is essential to follow this procedure. Ensure that all nodes in the Cassandra cluster are successfully restarted before proceeding with the upgrade of all nodes in TheHive cluster to version 5.

### Backup Configuration File

Save the existing configuration file for Cassandra 3.x. It will be used later to configure Cassandra 4:

```bash
  sudo cp /etc/cassandra/cassandra.yaml /etc/cassandra/cassandra3.yaml.bak
```

&nbsp;

### Install Cassandra

Follow the [**installation process**](./step-by-step-installation-guide.md#apache-cassandra) to install the required version. During the installation process, replace existing configuration files as necessary.

&nbsp;

### Configuration

Update the new configuration file and ensure the following parameters are correctly set with these values:

```
cluster_name: 'thp'
num_tokens: 256
```

!!! Info
    If you have a customized configuration file for Cassandra 3.x, it is advisable to carefully review the entire file and make any necessary adjustments to ensure compatibility and proper functioning.

&nbsp;

### Start the Service

Use the following command to start the Cassandra service:

```
sudo systemctl start cassandra
```

&nbsp;

### Upgrade SSTables

On each Cassandra node, upgrade the SSTables:

```
nodetool upgradesstables
```

Then repair the keyspaces:

```
nodetool repair --full
```

---

## Install TheHive

### Preparing for the New Installation

??? Abstract "I'm using a cluster"
    Before initiating the installation process, it is crucial to ensure that your Cassandra cluster is fully operational. Follow these steps:

    - Run the command ``nodetool status`` to check the status of your Cassandra cluster.

      ```bash
        nodetool status
      ```

    The output should display information about the nodes in your cluster, including their status, load, tokens, and other relevant details.

      ```text title="Example output"
      # nodetool status

      Datacenter: datacenter1
      =======================

      Status=Up/Down
      |/ State=Normal/Leaving/Joining/Moving
      --  Address      Load      Tokens  Owns (effective)  Host ID                               Rack
      UN  10.1.1.2  1.41 GiB  256     100.0%            ba6daa4e-6d14-4b21-a06c-d01b3bdd659d  rack1
      UN  10.1.1.3  1.39 GiB  256     100.0%            201ab99c-8e16-49b1-9b66-5444043eb1cd  rack1
      UN  10.1.1.4  1.36 GiB  256     100.0%            a79c9a8c-c99b-4d74-8e78-6b0c252aeb86  rack1
      ```

    - Ensure that all nodes in the cluster are in an operational state (UN), indicating that they are up and running normally.

    - Before proceeding with the installation, perform the following steps:

        **Stop Existing Nodes**: Stop all existing nodes of TheHive (4.x).

        **Upgrade and Start a Single Node**: Begin by upgrading and starting only one node to TheHive 5.0.0. Verify that everything functions correctly with this node before proceeding further.

        **Update and Start Other Nodes**: Once the initial node is successfully upgraded and operational, proceed to update and start the remaining nodes.

!!! Tip "TheHive configuration file: /etc/thehive/application.conf"
    Starting from TheHive 5.0.0, the configuration process has been simplified, with most administration parameters configurable directly within the user interface (UI). The configuration file (/etc/thehive/application.conf) should only contain essential information required for the successful startup of the application, including:

    - Secret
    - Database
    - Indexing Engine
    - File Storage
    - Enabled Connectors 
    - Akka Configuration (for clusters)

    Authentication, Webhooks, Cortex, and MISP configurations can now be conveniently set within the UI. 

!!! "Note on Configuration Changes"
    Please note the following changes in configuration keys:
    
    - The configuration keys for Cortex and MISP connector modules have been renamed from play.modules.enabled to scalligraph.modules. Update your configuration files accordingly to reflect these changes.

=== "Standalone server"

    - Save your current configuration file:

      ```bash
      sudo cp /etc/thehive/application.conf /etc/thehive/application.conf.bak
      ```
      
    - For the current scenario, which involves a standalone server, the ultimate configuration file should resemble the following:

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

=== "Cluster"

    - Save your current configuration file:

      ```bash
      sudo cp /etc/thehive/application.conf /etc/thehive/application.conf.bak
      ```

    - The second configuration includes settings for setting up TheHive in a clustered environment. It extends upon the first one with additional settings for cluster configuration using Akka:

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

      # Cluster configuration
      akka {
        cluster.enable = on
        actor {
          provider = cluster
        }
      remote.artery {
        canonical {
          hostname = "<My IP address>"
          port = 2551
        }
      }
      ## seed node list contains at least one active node
      cluster.seed-nodes = [
                            "akka://application@<Node 1 IP address>:2551",
                            "akka://application@<Node 2 IP address>:2551",
                            "akka://application@<Node 3 IP address>:2551"
                          ]
      }
      ```

!!! Note
    By default, both Cortex and MISP modules are enabled in TheHive. If you do not intend to use one or both of these modules, you can comment out the corresponding lines in the configuration file.

    **Recommendation**: It's advisable to utilize the default configuration sample provided, customize it with your specific parameter values, and retain the original file for configuring services through the web UI.

&nbsp;

### Specific Configuration for Upgrade Only

??? Abstract "I'm using a cluster"
    This section pertains solely to the initial node, which will initiate the database and index upgrade process.

These lines are to be included in the configuration file exclusively during the upgrade to version 5 and should be subsequently removed thereafter.

```
db.janusgraph.forceDropAndRebuildIndex = true
```

&nbsp;

### Installing TheHive

TheHive packages are distributed as RPM and DEB files available for direct download via tools like Wget or cURL, with installation performed manually.

All packages are hosted on an HTTPS-secured website and come with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum) and a [GPG](https://www.gnupg.org/) signature for verification.

{!includes/manual-download-installation-thehive.md!}

<!-- During the installation, if you already prepared your configuration file during [Prepare for the new installation](#prepare-for-the-new-installation) chapter, continue **without** updating it with the maintainer's version.

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
  ``` -->

&nbsp;

### Starting Services

Ensure that the required services are started for TheHive to function properly. Follow these steps:

1. **Reload Systemd Daemon** - Execute the following command to reload the systemd daemon:

  ```bash
  sudo systemctl daemon-reload
  ```

2. **Start Cassandra (if not already started)** - If Cassandra is not already running, start it with:

  ```bash
  sudo systemctl start cassandra
  ```

3. **Start Elasticsearch (if not already started)** - If Elasticsearch is not running, start it using:

  ```bash
  sudo systemctl start elasticsearch
  ```

4. **Start TheHive** -  Once both database services are running, start TheHive by executing:

  ```bash
  sudo systemctl start thehive
  ```

!!! Note
    The first start of TheHive 5.x may take some time as it updates the database schema and proceeds with reindexing. Progress can be monitored in the log file ``/var/log/thehive/application.log``. Refer to the troubleshooting section for further assistance.

&nbsp;

### Restarting the Service

After successfully starting the service, follow these steps to update the configuration file and restart TheHive:

1. **Update Configuration File** - Remove the following lines from the configuration file ``/etc/thehive/application.conf``:

  ```bash
  db.janusgraph.forceDropAndRebuildIndex = true
  ```

2. **Restart TheHive** - Restart TheHive using the following command:

  ```bash
  sudo systemctl restart thehive
  ```

??? Abstract "Using a cluster?"
    If you're deploying TheHive in a cluster, you can proceed to install and start TheHive on all other nodes following similar steps.

---

## Troubleshooting

During the update, few logs can be seen in TheHive `application.log` file. 

!!! Example "Example of logs and what they mean"

    ```
    [INFO] from org.janusgraph.graphdb.database.management.GraphIndexStatusWatcher in application-akka.actor.default-dispatcher-11 [|] Some key(s) on index global2 do not currently have status(es) [REGISTERED, ENABLED]: dateValue=INSTALLED,externalLink=INSTALLED,origin=INSTALLED,patternId=INSTALLED,revoked=INSTALLED,mandatory=INSTALLED,content=INSTALLED,isAttachment=INSTALLED,writable=INSTALLED,tactic=INSTALLED,stringValue=INSTALLED,owningOrganisation=INSTALLED,permissions=INSTALLED,actionRequired=INSTALLED,integerValue=INSTALLED,details=INSTALLED,locked=INSTALLED,slug=INSTALLED,cortexId=INSTALLED,owner=INSTALLED,workerId=INSTALLED,apikey=INSTALLED,level=INSTALLED,floatValue=INSTALLED,version=INSTALLED,occurDate=INSTALLED,url=INSTALLED,report=INSTALLED,tactics=INSTALLED,booleanValue=INSTALLED,cortexJobId=INSTALLED,category=INSTALLED,workerName=INSTALLED
    ```
    :    _TheHive install indexes of the new schema in the database_

    ```
    [INFO] from org.janusgraph.graphdb.olap.job.IndexRepairJob in Thread-97 [|] Index global2 metrics: success-tx: 1 doc-updates: 100 succeeded: 100
    ```
    :    _TheHive reindexes all data_

    ```
    * UPDATE SCHEMA OF thehive-enterprise (1): Create initial values
    [INFO] from org.thp.scalligraph.models.Operations in application-akka.actor.default-dispatcher-11 [d471d8b643d17b6d|d88fe62679b77ab1] Adding initial values for GDPRDummy
    [..]
    [INFO] from org.thp.scalligraph.models.Operations in application-akka.actor.default-dispatcher-11 [|] Update graph in progress (100): Add pap and ignoreSimilarity to observables
    ```
    :   _Migrating data from v4. to v5_

    ```
    [WARN] from org.thp.thehive.enterprise.services.LicenseSrv in main [ef39c95eaa6de532|0ccf187e40a4cd34] No license found
    ```
    :    _No license found. This is a normal behavior during the upgrade from versions 4 to 5_

    ```
    [INFO] from play.core.server.AkkaHttpServer in main [|] Listening for HTTP on /0:0:0:0:0:0:0:0:9000
    ```
    :    _The service is available. Users/Administrators can log in_

    ```
    [INFO] from org.thp.thehive.connector.cortex.services.CortexDataImportActor in application-akka.actor.default-dispatcher-16 [|] Analyzer templates already present (found 203), skipping
    [..]
    [INFO] from org.thp.thehive.services.ttp.PatternImportActor in application-akka.actor.default-dispatcher-14 [|] Import finished, 707 patterns imported
    ```
    :    _Few operations are processed after making the service available, like installing MITRE Enterprise ATT&CK patterns catalog or Analyzers templates._

    ```
    [ERROR] from org.janusgraph.diskstorage.log.util.ProcessMessageJob in pool-22-thread-1 [|] Encountered exception when processing message [Message@2022-03-24T16:50:40.655134Z:7f0001017672-ubuntu2=0x809F9F0568850528850550850558850570850600850610850618850650850668850710850738850758850760850808850900850910850A60850A70850A78850B00850B08853520853B3885150E8941608541688541788542088542688542708581] by reader [org.janusgraph.graphdb.database.management.ManagementLogger@3e1a6eae]:java.lang.IllegalStateException: Cannot access element because its enclosing transaction is closed and unbound
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
    :    _During indexing, Janusgraph may display this message, this error is coming from a [bug in janusgraph](https://github.com/JanusGraph/janusgraph/pull/2899), don't mind it as the indexing will continue normally. This will have no impact on TheHive_

    &nbsp;