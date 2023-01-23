# Install or update to TheHive 5.1-RC1


!!! Danger "*READ FIRST*"
    
    1. TheHive 5.1 RC1 is released for tests **ONLY** and is not supported for production purpose.
    
    2. We strongly recommend to: 
        
        * Perform backups of the databases before updating
        * Install or update database applications to the latest version of the applications supported
  
    3. One updated to TheHive 5.1, your instance cannot be _downgraded_, meaning you cannot decide to go back to TheHive 5.0.x. 



DEB and RPM packages are available as well as docker images.


This guide shares details about how to install or update to this version using package repositories.

## How to install ?

Dedicated packages are deployed in our repositories. Installation process is similar to the one described [here](../setup/installation/step-by-step-guide.md) and [here](./../setup/installation/3-node-cluster.md), except you have to use the dedicated repository address for TheHive 5.1, as decribed here: 

=== "DEB"
    !!! Example ""
        ```bash
        wget -O- https://archives.strangebee.com/keys/strangebee.gpg | sudo gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
        ```

=== "RPM"
    !!! Example ""
        ```bash
        sudo rpm --import https://archives.strangebee.com/keys/strangebee.gpg 
        ```


Install TheHive package by using the following commands:


=== "DEB"
    !!! Example ""
        ```bash
        echo 'deb [signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com thehive-5.1 main' | sudo tee -a /etc/apt/sources.list.d/strangebee.list
        sudo apt-get update
        sudo apt-get install -y thehive
        ```

=== "RPM"
    1. Setup your system to connect the RPM repository. Create and edit the file `/etc/yum.repos.d/strangebee.repo`:

        !!! Example ""
            ```bash title="/etc/yum.repos.d/strangebee.repo"
            [thehive]
            enabled=1
            priority=1
            name=StrangeBee RPM repository
            baseurl=https://rpm.strangebee.com/thehive-5.1/noarch
            gpgkey=https://archives.strangebee.com/keys/strangebee.gpg
            gpgcheck=1
            ```

    2. Then install the package using `yum`:

        !!! Example ""
            ```bash
            sudo yum install thehive
            ```


## How to update an existing instance ?

!!! Warning ""
    If updating an existing TheHive 5.0 instance, the first start will update the database schema as well as the data with this new schema. This operation can take a certain amount of time with depending of the size of your database.

Update the file `/etc/apt/sources.list.d/strangebee.list` if you are using DEB packages, or `/etc/yum.repos.d/strangebee.repo` if using RPM package and adjust the repository address (cf. [_How to install ?_](#how-to-install) ). 

Then:

=== "DEB"
    !!! Example ""

        ```bash
        sudo apt update
        sudo apt install thehive
        ```

=== "RPM"
    !!! Example ""

        ```bash
        sudo yum install thehive
        ```


## Install using Docker

Use the image named `strangebee/thehive:5.1` to run thive version. For example: 

```bash
docker run --rm -p 9000:9000 strangebee/thehive:5.1 
```