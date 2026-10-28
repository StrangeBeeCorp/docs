=== "DEB"
    
    1. Add Elasticsearch repository references.

        a. Download Elasticsearch repository keys.

        ```bash
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
        sudo apt-get install apt-transport-https
        ```

        b. Check if the `/etc/apt/sources.list.d/elastic-9.x.list` file exists. If it doesn't, create it.

        c. Add the repository to your system by appending the following line to the `/etc/apt/sources.list.d/elastic-9.x.list` file.

        ```bash
        echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/9.x/apt stable main" |  sudo tee /etc/apt/sources.list.d/elastic-9.x.list 
        ```

    2. Update your package index and install Elasticsearch using the following commands:

        ```bash
        sudo apt update
        sudo apt install elasticsearch=<version>
        ```

        Replace `<version>` with an Elasticsearch version that TheHive supports, for example `9.5.5`. See the [supported versions](/thehive/installation/software-requirements/).

    3. Hold the package so that system upgrades don't move Elasticsearch to an unsupported version.

        ```bash
        sudo apt-mark hold elasticsearch
        ```
    
    Refer to the official Elasticsearch documentation website for [the most up-to-date instructions](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-with-debian-package){target=_blank}.

=== "RPM"

    1. Add Elasticsearch repository references.

        a. Download Elasticsearch repository keys.

        ```bash
        sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
        ```
        
        b. Check if the `/etc/yum.repos.d/elasticsearch.repo` file exists. If it doesn't, create it.

        c. Add the repository to your system by appending the following line to the `/etc/yum.repos.d/elasticsearch.repo` file.

        ```bash
        echo "[elasticsearch]
        name=Elasticsearch repository for 9.x packages
        baseurl=https://artifacts.elastic.co/packages/9.x/yum
        gpgcheck=1
        gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
        enabled=0" | sudo tee /etc/yum.repos.d/elasticsearch.repo
        ```

    2. Update your package index and install Elasticsearch using the following commands:

        ```bash
        sudo yum -y update
        sudo yum install --enablerepo=elasticsearch elasticsearch-<version>
        ```

        Replace `<version>` with an Elasticsearch version that TheHive supports, for example `9.5.5`. See the [supported versions](/thehive/installation/software-requirements/).

        The repository is set with `enabled=0`, so system upgrades don't move Elasticsearch to another version.
    
    Refer to the official Elasticsearch documentation website for [the most up-to-date instructions](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-with-rpm){target=_blank}.

=== "Other installation methods"

    Download the tar.gz archive of a supported Elasticsearch version from [Elasticsearch downloads](http://elastic.co/downloads/elasticsearch){target=_blank} and extract it into the folder of your choice. You can use utilities like [`wget`](https://www.gnu.org/software/wget/){target=_blank} to download the archive.
