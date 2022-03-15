## INSTALLATION SCRIPT FOR Linux operating systems with RPM packages
#
#
#
# This script installs:
# - Cassandra 4.0.x
# - Elasticsearch 7.x
# - TheHive 5.x
# 
# It has sucessfully been tested  on freshly installed Operating systems:
# - Fedora 35
# - RHEL 8 
#
# Requirements: 
# - 4vCPU
# - 16 GB of RAM
# 
#
# Usage:
# 
#   $ sudo -v && bash install-RPM.sh
# 
# 
# maintained by: ©StrangeBee - https://www.strangebee.com

HEADER="---
THeHive installation script for Linux using RPM packages

Following softwares will be installed:
 - Cassandra 4.0.x
 - Elasticsearch 7.x
 - TheHive 5.x
 
It has sucessfully been tested on freshly installed Operating systems:
 - Fedora 35
 - RHEL 8 

Requirements: 
 - 4vCPU
 - 16 GB of RAM
 
Usage:
 
   $ sudo -v && bash install-rpm.sh 
 

Maintained by: ©StrangeBee - https://www.strangebee.com

---

"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
LOGFILE="/tmp/install-thehive.log"

[[ -f ${LOGFILE} ]] && rm ${LOGFILE}
exec 3>$(tty)
exec 2>&1> ${LOGFILE}

display_info() {
  log message "Something went wrong. More information is available in /tmp/install-thehive.log file."
}

display_success() {
  log success "TheHive installation complete! More information is available in /tmp/install-thehive.log file."
}

log () {
  TYPE=$1
  MESSAGE=$2

  case $1 in
    "success" )
    TAG="\n>>>> "
    COLOR=${YELLOW}
    ;;

    "ko" )
    TAG="[!] "
    COLOR=${RED}
    ;;

    "ok" )
    TAG="  "
    COLOR=${BLUE}
    ;;

    "message" )
    TAG=""
    COLOR=${CYAN}
    ;;
    
  esac

  echo -e "${TAG}${MESSAGE}"
  echo -e "${COLOR}${TAG}${MESSAGE}${NC}" >&3
}


yum-install() {
  PACKAGENAME=$@
  log message "Installing package(s) ${PACKAGENAME}"
  sudo yum install -yq ${PACKAGENAME} 
  if [ $? -eq 0 ]
    then
      log ok "package(s) ${PACKAGENAME} installed"
    else
      log ko "package(s) ${PACKAGENAME} not installed"
      display_info
      exit 1
    fi

}

# Start service, wait for it to be available and enable it
start-service() {
  SERVICENAME=$1
  SERVICEPORT=$2

  log ok  "* Starting service ${SERVICENAME}"
  sudo systemctl -q start ${SERVICENAME} 

  count=0
  while [ `ss -antl | grep LISTEN | grep ${SERVICEPORT} | wc -l` -lt 1 ] 
  do 
    count=$((${count}+1))
    if [ ${count} = 30 ]
    then
       log ko " ${SERVICENAME} not started, exiting."
       display_info
      exit 1
    else
      sleep 10
    fi
  done

  sudo systemctl -q enable ${SERVICENAME}
}

## HEADER
echo -e "${HEADER}" >&3

## REQUIRED PACKAGES
yum-install gnupg chkconfig


## INSTALL JAVA
yum-install java-11-openjdk-headless.x86_64
echo JAVA_HOME="/usr/lib/jvm/jre-11-openjdk" |sudo tee -a /etc/environment
export JAVA_HOME="/usr/lib/jvm/jre-11-openjdk"


## CASSANDRA INSTALLATION 

sudo rpm --import https://downloads.apache.org/cassandra/KEYS

cat <<EOF | sudo tee  -a /etc/yum.repos.d/cassandra.repo > /dev/null
[cassandra]
name=Apache Cassandra
baseurl=https://downloads.apache.org/cassandra/redhat/40x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.apache.org/cassandra/KEYS
EOF

yum-install cassandra

## CASSANDRA CONFIGURATION
log message "Configuring cassandra"
cat /etc/cassandra/default.conf/cassandra.yaml | sudo sed  -e "s/\(cluster_name:\ \).*/\1\'thp\'/g" | sudo tee /etc/cassandra/default.conf/cassandra.yaml

## INSTALL ELASTICSEARCH
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat <<EOF |  sudo tee  -a /etc/yum.repos.d/elasticsearch.repo 
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
EOF

sudo yum install -y -q --enablerepo=elasticsearch elasticsearch


## ELASTICSEARCH CONFIGURATION
log message "Configuring elasticsearch"
cat << EOF |  sudo tee /etc/elasticsearch/elasticsearch.yml 
http.host: 127.0.0.1
transport.host: 127.0.0.1
cluster.name: hive
thread_pool.search.queue_size: 100000
path.logs: "/var/log/elasticsearch"
path.data: "/var/lib/elasticsearch"
xpack.security.enabled: false
script.allowed_types: "inline,stored"
EOF

cat << EOF | sudo tee -a /etc/elasticsearch/jvm.options.d/jvm.options 
-Dlog4j2.formatMsgNoLookups=true
-Xms4g
-Xmx4g
EOF


## INSTALL THEHIVE 
sudo rpm --import https://archives.strangebee.com/keys/strangebee.gpg 

cat <<EOF | sudo  tee -a  /etc/yum.repos.d/strangebee.repo
[thehive]
enabled=1
priority=1
name=StrangeBee RPM repository
baseurl=https://rpm.strangebee.com/thehive-5.x/noarch
gpgkey=https://archives.strangebee.com/keys/strangebee.gpg
gpgcheck=1
EOF

yum-install  thehive

## CREATE THEHIVE FILE STORAGE
log message "Configuring thehive\n"
sudo mkdir -p /opt/thp/thehive/files
sudo chown -R thehive:thehive /opt/thp/thehive/files

## SERVICES
log message "\nStarting services"
sudo systemctl daemon-reload

### START AND ENABLE CASSANDRA
start-service cassandra 9042

### START AND ENABLE ELASTICSEARCH
start-service elasticsearch 9200

### START AND ENABLE THEHIVE
start-service thehive 9000 

display_success

exec 3>&-