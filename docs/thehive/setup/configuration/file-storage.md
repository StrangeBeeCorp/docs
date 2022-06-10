# File storage configuration

TheHive can be configured to use local or distributed filesystems. 

=== "Local or NFS"

    1. Create dedicated folder ; it should belong to user and group `thehive:thehive`.
    
        ```bash
        mkdir /opt/thp/thehive/files
        chown thehive:thehive /opt/thp/thehive/files
        ```

    2. Configure TheHive accordingly:

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

    1. Install a Min.IO cluster

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
            endpoint = "http://10.1.2.4:9100"
            accessKey = "thehive"
            secretKey = "minio_password"
            access-style = path
            region = "us-east-1"
          }
        } 
        ```

        ```yaml title="/etc/thehive/application.conf with TheHive 5.1.x"
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

        !!! Note ""
            - The configuration is backward compatible
            - `us-east-1` is the default region if none has been specified in MinIO configuration. In this case, this parameter is optional.