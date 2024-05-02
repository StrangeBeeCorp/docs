# File Storage Configuration

TheHive offers flexible configurations for file storage, accommodating both local and distributed filesystem setups.

=== "Local or NFS"

To configure TheHive to use a local or NFS (Network File System) storage:

    1. Create a dedicated folder named files, ensuring it is owned by the user and group thehive:thehive.
    
        ```bash
        mkdir /opt/thp/thehive/files
        chown thehive:thehive /opt/thp/thehive/files
        ```

    2. Configure TheHive accordingly in the YAML configuration file:

        ```yaml
        ## Attachment storage configuration
        storage {
          ## Local filesystem
          provider: localfs
          localfs {
            location: /opt/thp/thehive/files
          }
        }
        ```


=== "Min.IO" 

For Min.IO integration with TheHive, follow these steps:

    1. Install a Min.IO cluster. Follow [**these step-by-step**](../installation/3-node-cluster.md#minio-setup) instructions.
    2. Configure each node of TheHive accordingly:

        ```yaml title="/etc/thehive/application.conf with TheHive 5.0.x"
        ## Attachment storage configuration
        storage {
          provider: s3
          s3 {
            bucket = "thehive"
            readTimeout = 1 minute
            writeTimeout = 1 minute
            chunkSize = 1 MB
            endpoint = "http://<IP_MINIO_1>:9100"
            accessKey = "thehive"
            secretKey = "password"
            region = "us-east-1"
          }
        }
        alpakka.s3.access-style = path
        ```

        ```yaml title="/etc/thehive/application.conf with TheHive > 5.0"
        storage {
          provider: s3
          s3 {
            bucket = "thehive"
            readTimeout = 1 minute
            writeTimeout = 1 minute
            chunkSize = 1 MB
            endpoint = "http://<IP_MINIO_1>:9100"
            accessKey = "thehive"
            aws.credentials.provider = "static"
            aws.credentials.secret-access-key = "password"
            access-style = path
            aws.region.provider = "static"
            aws.region.default-region = "us-east-1"
          }
        }
        ```

      Note:
      
      - The configuration remains backward compatible.
      
      - The default region is us-east-1, but it's optional if not specified in the MinIO configuration.

&nbsp;