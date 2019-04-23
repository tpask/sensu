# install sensu server

# install epel-release
yum install epel-release

#install erlang
yum -y install erlang

#import rabbitmq key
rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc

# install rabbitmq
rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.4.1/rabbitmq-server-3.4.1-1.noarch.rpm
rabbitmq-plugins enable rabbitmq_management

# install redis
yum -y install redis
chkconfig redis on
service redis start

chkconfig rabbitmq-server on
/etc/init.d/rabbitmq-server start
rabbitmqctl add_vhost /sensu
rabbitmqctl add_user sensu sensu
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

#add sensu repo
cat > /etc/yum.repos.d/sensu.repo <<EOL
[sensu]
name=sensu-main
baseurl=http://repositories.sensuapp.org/yum/el/7/x86_64/
gpgcheck=0
enabled=1
EOL

# install sensu
yum -y install sensu
cp /etc/sensu/config.json.example /etc/sensu/conf.d/conf.json
chkconfig sensu-server on
chkconfig sensu-client on
service sensu-server start
service sensu-client start

# install uchiwa
yum install -y uchiwa
chkconfig uchiwa on
service uchiwa start
 
