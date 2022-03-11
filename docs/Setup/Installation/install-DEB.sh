## INSTALLATION SCRIPT FOR Linux operating systems with DEB packages
#
#
#
# This script installs, on the sane server:
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
# maintained by: ©StrangeBee - https://www.strangebee.com

set -o errexit

apt-update() {
  sudo apt update -qq &> /dev/null
}

# Start service, wait for it to be available and enable it
apt-install() {
  PACKAGENAME=$@
  echo "Installing package(s) ${PACKAGENAME}"
  apt-update
  sudo RUNLEVEL=1 apt install -yqq ${PACKAGENAME} &> /dev/null
  if [ $? -eq 0 ]
    then
      echo "[+] package(s) ${PACKAGENAME} installed"
    else
      echo "[-] package(s) ${PACKAGENAME} not installed"
      exit 1
    fi
}

# Start service, wait for it to be available and enable it
start-service() {
  SERVICENAME=$1
  SERVICEPORT=$2

  echo "* Starting service ${SERVICENAME}"
  sudo systemctl -q start ${SERVICENAME} &> /dev/null

  count=0
  while [ `ss -antl | grep LISTEN | grep ${SERVICEPORT} | wc -l` -lt 1 ] 
  do 
    count=$((${count}+1))
    if [ ${count} = 30 ]
    then
      echo "! ${SERVICENAME} not started, exiting. Check logs."
      exit 1
    else
      sleep 10
    fi
  done

  sudo systemctl -q enable ${SERVICENAME}
}



## REQUIRED PACKAGES

apt-install wget curl gnupg apt-transport-https

apt-install openjdk-11-jre-headless
echo JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64" | sudo tee -a /etc/environment &> /dev/null 
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"


## CASSANDRA INSTALLATION 
wget -qO -  https://downloads.apache.org/cassandra/KEYS | sudo gpg --dearmor  -o /usr/share/keyrings/cassandra-archive.gpg
echo "deb [signed-by=/usr/share/keyrings/cassandra-archive.gpg] https://downloads.apache.org/cassandra/debian 40x main" |  sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list > /dev/null

apt-install cassandra

## CASSANDRA CONFIGURATION
echo "configuring cassandra"
sudo systemctl stop cassandra
sudo rm -rf /var/lib/cassandra/*
cat /etc/cassandra/cassandra.yaml | sed  -e "s/\(cluster_name:\ \).*/\1\'thp\'/g" | sudo tee /etc/cassandra/cassandra.yaml > /dev/null


## ELASTICSEARCH INSTALLATION
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" |  sudo tee /etc/apt/sources.list.d/elastic-7.x.list > /dev/null

apt-install elasticsearch

## ELASTICSEARCH CONFIGURATION
echo "Configuring elasticsearch"
sudo systemctl stop elasticsearch
sudo rm -rf /var/lib/elasticsearch/*

cat << EOF |  sudo tee /etc/elasticsearch/elasticsearch.yml > /dev/null
http.host: 127.0.0.1
transport.host: 127.0.0.1
cluster.name: hive
thread_pool.search.queue_size: 100000
path.logs: "/var/log/elasticsearch"
path.data: "/var/lib/elasticsearch"
xpack.security.enabled: false
script.allowed_types: "inline,stored"
EOF

cat << EOF | sudo tee -a /etc/elasticsearch/jvm.options.d/jvm.options > /dev/null
-Dlog4j2.formatMsgNoLookups=true
-Xms4g
-Xmx4g
EOF


## INSTALL THEHIVE
wget -qO- https://download.thehive-project.org/strangebee.gpg |  sudo gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.staging.strangebee.com thehive-5.x main' |  sudo tee -a /etc/apt/sources.list.d/strangebee.list  > /dev/null

apt-install thehive 


## CREATE THEHIVE FILE STORAGE
echo -e "Configuring thehive\n"
sudo systemctl stop thehive
sudo mkdir -p /opt/thp/thehive/files
sudo chown -R thehive:thehive /opt/thp/thehive/files


## SERVICES
sudo systemctl daemon-reload

## START CASSANDRA
start-service cassandra 9042

## START ELASTICSEARCH 
start-service elasticsearch 9200

## START THEHIVE
start-service thehive 9000 

echo -e "\n>>>> TheHive installation complete! <<<<\n"