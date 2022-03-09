## INSTALLATION SCRIPT FOR FEDORA 35

start-service() {
  SERVICENAME=$1
  SERVICEPORT=$2

  systemctl start ${SERVICENAME}

  count=0
  while [ `ss -antl | grep LISTEN | grep ${SERVICEPORT} | wc -l` -lt 1 ] 
  do 
    count=$((${count}+1))
    if [ ${count} = 6 ]
    then
      exit 1
    else
      sleep 10
    fi
  done

  systemctl enable ${SERVICENAME}
}
## REQUIRED PACKAGES

apt update
apt install -y wget curl gnupg apt-transport-https

apt-get install -y openjdk-11-jre-headless
echo JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/environment
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"


## CASSANDRA INSTALLATION 

curl https://downloads.apache.org/cassandra/KEYS | gpg --dearmor  -o /usr/share/keyrings/cassandra-archive.gpg
echo "deb [signed-by=/usr/share/keyrings/cassandra-archive.gpg] https://downloads.apache.org/cassandra/debian 40x main" |  tee -a /etc/apt/sources.list.d/cassandra.sources.list

 apt update
 apt install -y cassandra

## CASSANDRA CONFIGURATION
sed -i -e "s/\(cluster_name:\ \).*/\1\'thp\'/g" /etc/cassandra/cassandra.yaml


## ELASTICSEARCH INSTALLATION

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" |  tee /etc/apt/sources.list.d/elastic-7.x.list

apt-get update &&  apt-get install elasticsearch


## ELASTICSEARCH CONFIGURATION 
cat << EOF |  tee /etc/elasticsearch/elasticsearch.yml
http.host: 127.0.0.1
transport.host: 127.0.0.1
cluster.name: hive
thread_pool.search.queue_size: 100000
path.logs: "/var/log/elasticsearch"
path.data: "/var/lib/elasticsearch"
xpack.security.enabled: false
script.allowed_types: "inline,stored"
EOF

cat << EOF | tee -a /etc/elasticsearch/jvm.options.d/jvm.options
-Dlog4j2.formatMsgNoLookups=true
-Xms4g
-Xmx4g
EOF


## THEHIVE INSTALLATION 
wget -O- https://download.thehive-project.org/strangebee.gpg |  gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.staging.strangebee.com thehive-5.x main' |  tee -a /etc/apt/sources.list.d/strangebee.list

apt update && apt install -y thehive


## CREATE THEHIVE FILE STORAGE
mkdir -p /opt/thp/thehive/files
chown -R thehive:thehive /opt/thp/thehive/files

## SERVICES
systemctl daemon-reload

## START CASSANDRA
start-service cassandra 9042

## START ELASTICSEARCH 
start-service elasticsearch 9200

## START THEHIVE
start-service thehive 9000 