# Migration from TheHive 3.x

This documentation outlines the supported versions, prerequisites, configuration steps, and the migration process.

The migration from TheHive 3.x to TheHive 5.x involves transferring data stored in Elasticsearch. TheHive 5.x is provided with a tool to help you migrate your data.

The migration tool is located in `/opt/thehive/bin/migrate`.

---

## Supported versions

The migration tool facilitates the transition from both TheHive 3.4.x and 3.5.x versions.

---

## Pre-requisites

Before initiating the migration, ensure the following:

- TheHive v5.x must be installed on the system where the migration tool will run.

- TheHive must be properly configured, including database, index, and file storage settings.

- Stop the `thehive` service on the target server using the command: service thehive stop.

- Ensure the migration tool has access to the Elasticsearch database used by TheHive 3.x and the configuration file of TheHive 3.x instance.

---

## Configuration of TheHive

### User Domain Configuration

Users in TheHive are identified by their email addresses. To migrate users from TheHive 3, a domain must be appended to usernames. By default, TheHive v5.x includes a domain named ``thehive.local``. Starting the migration without explicitly specifying a domain name will result in migrating all users with a username formatted like  `user@thehive.local`. 

To specify a custom domain, update the ``auth.defaultUserDomain`` setting in the configuration file (`/etc/thehive/application.conf`):

```yaml
    auth.defaultUserDomain: "mydomain.com"
```

This ensures that imported users from TheHive 3.x are formatted as `user@mydomain.com`.

---

## Running the migration

Follow the steps below to execute the migration:

1. Prepare, install, and configure TheHive v5.x as per [**the associated guide**](../installation/step-by-step-installation-guide.md)

2. Ensure TheHive 5 is not running before initiating the migration for optimal performance.

3. Execute the `migrate` command:

```bash
  /opt/thehive/bin/migrate
```


!!! Warning
    The migration tool works on a single node only, thus the configuration file must not contain cluster configuration (`akka.cluster`).


!!! Info
    It is recommended to execute this program under the user responsible for running TheHive service (thehive if you are installing the application using DEB or RPM packages).

&nbsp;

### TheHive migration tool options

The migration tool for TheHive offers a comprehensive set of options to facilitate the migration process. Below is a detailed list of available options:

- `-v, --version`: Displays the version of the migration tool.
- `-h, --help`: Displays the help message detailing the usage of the migration tool.
- `-l, --logger-config <file>`: Specifies the path to the logback configuration file.
- `-c, --config <file>`: Specifies the global configuration file for TheHive.
- `-i, --input <file>`: Specifies the path to the configuration file of TheHive 3.
- `-o, --output <file>`: Specifies the path to the configuration file for TheHive 5.
- `-d, --drop-database`: Drops TheHive 5 database before migration.
- `-r, --resume`: Resumes migration or migrates on an existing database.
- `-m, --main-organisation <organisation>`: Specifies the main organization for migration.
- `-u, --es-uri http://ip1:port,ip2:port`: Specifies the Elasticsearch URIs for TheHive 3.
- `-x, --es-index <index>`: Specifies the Elasticsearch index name for TheHive 3.
- `-x, --es-index-version <index>`: Specifies the version number for the Elasticsearch index name (default: autodetect).
- `-a, --es-keep-alive <duration>`: Specifies the Elasticsearch keep-alive duration, which defines how long the scroll context remains active between requests. The value must include a unit, such as `2s` for 2 seconds, `3m` for 3 minutes, or `4h` for 4 hours.
- `-p, --es-pagesize <value>`: Specifies the page size for Elasticsearch queries.
- `-s, --es-single-type <bool>`: Specifies whether Elasticsearch uses a single type.
- `-y, --transaction-pagesize <value>`: Specifies the page size for each transaction.
- `-t, --thread-count <value>`: Specifies the number of threads for migration.
- `-k, --integrity-checks`: Runs integrity checks after migration.
- `--max-case-age <duration>`: Migrates cases younger than the specified duration.
- `--min-case-age <duration>`: Migrates cases older than the specified duration.
- `--case-from-date <date>`: Migrates cases created from the specified date.
- `--case-until-date <date>`: Migrates cases created until the specified date.
- `--case-from-number <number>`: Migrates cases starting from the specified case number.
- `--case-until-number <number>`: Migrates cases up to the specified case number.
- `--max-alert-age <duration>`: Migrates alerts younger than the specified duration.
- `--min-alert-age <duration>`: Migrates alerts older than the specified duration.
- `--alert-from-date <date>`: Migrates alerts created from the specified date.
- `--alert-until-date <date>`: Migrates alerts created until the specified date.
- `--include-alert-types <type>,<type>...`: Migrates only alerts with the specified types.
- `--exclude-alert-types <type>,<type>...`: Excludes alerts with the specified types from migration.
- `--include-alert-sources <source>,<source>...`: Migrates only alerts with the specified sources.
- `--exclude-alert-sources <source>,<source>...`: Excludes alerts with the specified sources from migration.
- `--max-audit-age <duration>`: Migrates audits younger than the specified duration.
- `--min-audit-age <duration>`: Migrates audits older than the specified duration.
- `--audit-from-date <date>`: Migrates audits created from the specified date.
- `--audit-until-date <date>`: Migrates audits created until the specified date.
- `--include-audit-actions <value>`: Migrates only audits with the specified actions (Update, Creation, Delete).
- `--exclude-audit-actions <value>`: Excludes audits with the specified actions from migration.
- `--include-audit-objectTypes <value>`: Migrates only audits with the specified object types (case, case_artifact, case_task, etc.).
- `--exclude-audit-objectTypes <value>`: Excludes audits with the specified object types from migration.
- `--case-number-shift <value>`: Transposes case numbers by adding the specified value.

&nbsp;

#### Usage examples

- Import Cases/Alerts not older than X days/hours.
- Import Cases/Alerts with specific ID numbers.
- Import a portion of the Audit trail.
- ...

&nbsp;

### Basic migration command

To migrate data to a new instance of TheHive, use the following command:

```bash
/opt/thehive/bin/migrate \
  --output /etc/thehive/application.conf \
  --main-organisation myOrganisation \
  --es-uri http://ELASTICSEARCH_IP_ADDRESS:9200 \
  --es-index the_hive
```

Options Description:

- --output: Specifies the configuration file path for TheHive 5, which must include database and file storage configurations.
- --main-organisation: Specifies the organization to create during migration.
- --es-uri: Specifies the URL of the Elasticsearch server. If Elasticsearch authentication is enabled, a configuration file for TheHive3 (--input) is required.
- --es-index: Specifies the Elasticsearch index used for migration.

| Option                    | Description       |
| :------------------------ | ----------------- |
| `--output`                | Specifies the configuration file path for TheHive 5, which must include database and file storage configurations; |
| `--main-organisation`     | Specifies the organization to create during migration; |
| `--es-uri`                | Specifies the URL of the Elasticsearch server. If Elasticsearch authentication is enabled, a configuration file for TheHive3 (--input) is required; |
| `--es-index`              | Specifies the Elasticsearch index used for migration; |


!!! Info
    The migration process duration varies significantly based on data volume, ranging from several hours to days. It is strongly advised not to start TheHive application during migration to ensure data integrity.

---

## Resuming an Incomplete Migration
If your migration process has been interrupted or only a portion of the data has been migrated, you can resume the migration using the tool with the `--resume` parameter. This parameter ensures that data is not duplicated if it already exists in the destination system.

---

## Merging multiple TheHive 3 data into one TheHive 5 instance

The migration tool supports multiple executions to merge different TheHive 3 datasets into a single TheHive 5 instance. Each migration execution can specify a different target organization. To avoid conflicts in case numbers, where a case with the same number already exists, you can use the `--case-number-shift` parameter to adjust the case numbers accordingly.

---

## Using authentication on Cassandra

If you're utilizing a dedicated account on Cassandra to access TheHive 4 data, ensure that the user has permissions to create keyspaces in the database.

```sql
GRANT CREATE on ALL KEYSPACES to username;
```

---

## Migration logs

During the migration process, the tool generates logs to provide insights into the progress. By default, a log is generated approximately every 10 seconds, detailing various aspects of the migration, including the status of cases, alerts, and other entities.

```
[info] o.t.t.m.Migrate - [Migrate cases and alerts] CaseTemplate/Task:32 Organisation:1/1 Case/Task:160/201 Case:31/52 Job:103/138 ObservableType:3/17 Alert:25/235 Audit:3207/2986 CaseTemplate:6/6 Alert/Observable:700(52ms) Case/Observable:1325/1665 User:9/9 CustomField:13/13 Case/Task/Log:20/27
```

Please note that the numbers of observables, cases, and other entities are estimations and may not represent exact values due to the complexity of computation involved.

!!! Info "Files from MISP imported with TheHive 2.13 and earlier"
    It is important to notice that migrating Cases/Alerts containing MISP event that were imported with TheHive 2.13 (_Sept 2017_) or older will cause observable files not being imported in TheHive 5.
    
    Indeed, until this version, TheHive referenced the file to the `AttributeId` in MISP and was not automatically downloaded. It then could generate a log like this: 

    ```log
    [warn] o.t.t.m.t.Input - Pre 2.13 file observables are ignored in MISP alert ffa3a8503ab0cd4f99fc6937a8e9b827
    ```

---

## Starting TheHive
Once the migration process has successfully completed, you can start TheHive. However, during the initial startup, data indexing occurs, and the service may not be immediately available. This indexing process may take some time.

!!! Warning
    During the initial startup, refrain from stopping or restarting TheHive service until the indexing process is complete to ensure data integrity and service availability.

&nbsp;