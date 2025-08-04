# Use the Demo Virtual Machine


!!! Warning
    Ensure good performance by allocating a minimum of 6 GB of RAM to run this Virtual Machine flawlessly. Adjusting the allocation below this threshold may lead to potential complications.

## Start the VM

![](images/vm-start.png)


=== "Using VMWare"
    1. Start the Virtual Machine, and follow the instructions.
    2. Open the indicated url in your browser: http://IP-ADDRESS

=== "Using VirtualBox"
    1. When importing, ensure to set Guest OS type information.
    ![](images/virtualbox-port-forwarding-3.png)
    2. Once imported, update the network settings of the VM before starting it.
    ![](images/virtualbox-port-forwarding-1.png)
    3. Add required port forwarding (update according to your needs) and save.
    ![](images/virtualbox-port-forwarding-2.png)
    4. Start the VM and open the following URL in your browser: http://127.0.0.1:8888
    5. You might have to also adjust *Display* graphical controller and set it to `VMSVGA` before starting the VM.


## Quick connect

!!! Note "Following instructions are also shared in the web page coming with the virtual machine" 


![](images/thehive-logo.png){ width="200" }


!!! Question "TheHive Credentials"
    This VM comes with 2 accounts in TheHive: 

    Administrator:

    - Login: `admin@thehive.local`
    - Password: `secret`


    A user named `thehive` has been created and is `org-admin` of the organization named `demo`: 

    - Login: `thehive@thehive.local`
    - Password: `thehive1234`


TheHive database comes with several samples of data, like custom fields, [MISP taxonomies](https://github.com/MISP/misp-taxonomies), [MITRE Att&ck](https://attack.mitre.org/) data, a Case Template and an Alert. 


![](images/cortex-logo.png){ width="200" }

!!! Question "Cortex credentials"
    This VM comes with 2 accounts in Cortex:

    Administrator: 

    - Login: `admin`
    - Password: `thehive1234` 

    An organization is also created with an `orgadmin` account: 

    - Login: `thehive`
    - Password: `thehive1234`

 
!!! Warning
    The VM is solely intended to be used for testing purposes. **We strongly encourage you to refrain from using it in production.**


## Content

The VM runs Debian 11.
The most recent VM includes:

- TheHive **5.x** using a local BerkeleyDB and file storage, 
- Cortex **3.1.x** , and Elasticsearch **7**
- TheHive4py
- Cortex4py
- Public Cortex Analyzers and Responders are running with Docker 

### Configuration details

Applications launched with Docker-compose, as docker containers with attached volumes in `/opt/thp`. 


!!! Example ""
    ```
    .
    ├── cassandra
    ├── cortex
    ├── docker-compose.yml
    ├── elasticsearch
    ├── nginx
    └── thehive
    ```

#### TheHive
TheHive is configured to use *Cassandra* as database and *Elasticsearch* to index data. Files are stored in a local path. 

!!! Example ""
    ```
    thehive
    ├── config
    ├── files
    └── log
    ```

- `config`: all configuration files for TheHive
- `files`: files storage 
- `log`: TheHive application logs 


### Cortex
Cortex uses *Elasticsearch* as database which is also run as a container with Docker-Compose. Dedicated volumes are configured: `/opt/thp/elasticsearch/data` to store data, and `/opt/thp/elasticsearch/log`, for logs.

!!! Example ""
    ```
    cortex
    ├── config
    ├── jobs
    └── log
    ```

- `config`: all configuration files for TheHive
- `jobs`: shared volume for Analyzers and Responders jobs
- `log`: Cortex application logs


## Operations

### Virtual Machine 
A system user account `thehive/thehive1234` can be used to operate the VM.

All applications are run as docker containers, using docker-compose. The `docker-compose.yml` is in the folder `/opt/thp`. 

### TheHive 
After each modification of TheHive configuration service should be restart.

- Configuration file of TheHive is in `/opt/thp/thehive/config/application.conf`

- Service can be restart by running following commands:
 
!!! Example ""
    ```bash
    cd /opt/thp
    docker compose restart thehive
    ```

### Cortex
After each modification of Cortex configuration service should be restart.

- Configuration file of TheHive is in `/opt/thp/cortex/config/application.conf`

- Service can be restart by running following commands:

!!! Example ""
    ```bash
    cd /opt/thp
    docker compose restart cortex
    ```

### Check for update
Check for update for TheHive and Cortex by running following commands (this will stop running applications): 

!!! Example ""
    ```bash
    cd /opt/thp
    bash update.sh
    ```

### Documentation

- Documentation for TheHive 5 can be found there:  [https://docs.strangebee.com](https://docs.strangebee.com). 


## Troubleshooting
TheHive service logs are located in `/opt/thp/thehive/log/application.log`.

Cortex service logs are located in `/opt/thp/cortex/log/application.log`.

## Need Help?
Something does not work as expected? No worries, we got you covered. Join our community and contact us on [Discord](https://chat.thehive-project.org)! 

