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

yum -y update
yum -y install wget curl gnupg chkconfig

yum install -y java-11-openjdk-headless.x86_64
echo JAVA_HOME="/usr/lib/jvm/jre-11-openjdk" | tee -a /etc/environment
export JAVA_HOME="/usr/lib/jvm/jre-11-openjdk"


## CASSANDRA INSTALLATION 

rpm --import https://downloads.apache.org/cassandra/KEYS

cat <<EOF | tee  -a /etc/yum.repos.d/cassandra.repo
[cassandra]
name=Apache Cassandra
baseurl=https://downloads.apache.org/cassandra/redhat/40x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.apache.org/cassandra/KEYS
EOF

sudo yum install -y cassandra

## CASSANDRA CONFIGURATION
sed -i -e "s/\(cluster_name:\ \).*/\1\'thp\'/g" /etc/cassandra/default.conf/cassandra.yaml



## ELASTICSEARCH INSTALLATION

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat <<EOF |  tee  -a /etc/yum.repos.d/elasticsearch.repo
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
EOF

sudo yum install -y --enablerepo=elasticsearch elasticsearch


## ELASTICSEARCH CONFIGURATION 
cat << EOF | sudo tee /etc/elasticsearch/elasticsearch.yml
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

sudo rpm --import https://download.thehive-project.org/strangebee.gpg 

cat <<EOF |  tee -a  /etc/yum.repos.d/strangebee.repo
[thehive]
enabled=1
priority=1
name=StrangeBee RPM repository
baseurl=https://rpm.staging.strangebee.com/thehive-5.x/noarch
gpgkey=https://download.thehive-project.org/strangebee.gpg
gpgcheck=1
EOF

yum install -y thehive

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