## INSTALLATION SCRIPT FOR Linux operating systems with DEB packages
#
#
#
# This script installs:
# - Cassandra 4.0.x
# - Elasticsearch 7.x
# - TheHive 5.x
# 
# It has been sucessfully tested  on freshly installed Operating systems:
# - Ubuntu 20.04 LTS
# 
#
# Requirements: 
# - 4vCPU
# - 16 GB of RAM
# 
#
# Usage:
# 
#   $ sudo -v ; wget -q -O /tmp/install-thehive.sh https://archives.strangebee.com/scripts/install-deb.sh ; bash /tmp/install-thehive.sh
# 
# 
# Maintained by: ©StrangeBee - https://www.strangebee.com

HEADER="---
THeHive installation script for Linux using DEB packages

Following softwares will be installed:
 - Cassandra 4.0.x
 - Elasticsearch 7.x
 - TheHive 5.x
 
It has sucessfully been tested on freshly installed Operating systems:
 - Ubuntu 20.04 LTS
 - Debian 11

Requirements: 
 - 4vCPU
 - 16 GB of RAM
 
Usage:
 
   $ sudo -v && bash install-deb.sh 
 

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
exec &> ${LOGFILE}

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


apt-update() {
  sudo apt update -qq 
}

# Start service, wait for it to be available and enable it
apt-install() {
  PACKAGENAME=$@
  log message "Installing package(s) ${PACKAGENAME}"
  apt-update
  sudo RUNLEVEL=1 apt install -yqq ${PACKAGENAME} 
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

  log ok "* Service ${SERVICENAME} is starting"
  sudo systemctl -q start ${SERVICENAME} 

  count=0
  while [ `ss -antl | grep LISTEN | grep :${SERVICEPORT} | wc -l` -lt 1 ] 
  do 
    count=$((${count}+1))
    if [ ${count} = 30 ]
    then
      log ko " ${SERVICENAME} failed to start, exiting."
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
apt-install wget gnupg apt-transport-https

apt-install openjdk-11-jre-headless
echo JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64" | sudo tee -a /etc/environment 
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
sudo update-java-alternatives --jre-headless -s java-1.11.0-openjdk-amd64

## CASSANDRA INSTALLATION 
wget -qO -  https://downloads.apache.org/cassandra/KEYS | sudo gpg --dearmor  -o /usr/share/keyrings/cassandra-archive.gpg
echo "deb [signed-by=/usr/share/keyrings/cassandra-archive.gpg] https://downloads.apache.org/cassandra/debian 40x main" |  sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list 
apt-install cassandra

## CASSANDRA CONFIGURATION
log message "Configuring cassandra"
sudo systemctl stop cassandra
sudo rm -rf /var/lib/cassandra/*
cat /etc/cassandra/cassandra.yaml | sed  -e "s/\(cluster_name:\ \).*/\1\'thp\'/g" | sudo tee /etc/cassandra/cassandra.yaml 

## ELASTICSEARCH INSTALLATION
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" |  sudo tee /etc/apt/sources.list.d/elastic-7.x.list 
apt-install elasticsearch

## ELASTICSEARCH CONFIGURATION
log message "Configuring elasticsearch"
sudo systemctl stop elasticsearch
sudo rm -rf /var/lib/elasticsearch/*

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
wget -qO- https://raw.githubusercontent.com/StrangeBeeCorp/Security/main/PGP%20keys/packages.key |  sudo gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
echo 'deb [arch=all signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com thehive-5.x main' |  sudo tee -a /etc/apt/sources.list.d/strangebee.list

apt-install thehive


## CREATE THEHIVE FILE STORAGE
log message "Configuring thehive"
sudo systemctl stop thehive
sudo mkdir -p /opt/thp/thehive/files
sudo chown -R thehive:thehive /opt/thp/thehive/files


## SERVICES
log message "\nStarting services"
sudo systemctl daemon-reload

## START CASSANDRA
start-service cassandra 9042

## START ELASTICSEARCH 
start-service elasticsearch 9200

## START THEHIVE
start-service thehive 9000 

## Remove tombstones (for standalone server ONLY)
for TABLE in edgestore edgestore_lock_ graphindex graphindex_lock_ janusgraph_ids system_properties system_properties_lock_ systemlog txlog
    do
      cqlsh -u cassandra -p cassandra -e "ALTER TABLE thehive.${TABLE} WITH gc_grace_seconds = 0;"
    done

[[ $? -eq 0 ]] && display_success

exec 3>&-
