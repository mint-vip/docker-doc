docker pull index.alauda.cn/mesoscloud/zookeeper:3.4.8-centos-7
docker pull index.alauda.cn/mesoscloud/mesos-master:0.28.1-centos-7
docker pull index.alauda.cn/mesoscloud/mesos-slave:0.28.1-centos-7

1.安装ZOOKEEPER 
docker pull 192.168.2.39:5000/zookeeper:3.4.8
docker run -d \
-e MYID=1 \
-e SERVERS=192.168.2.37,192.168.2.38,192.168.2.39 \
--name=zookeeper --net=host --restart=always 192.168.2.39:5000/zookeeper:3.4.8



2. docker pull 192.168.2.39:5000/mesos-master:0.28.1
 # 
docker run -d \
-e MESOS_HOSTNAME=192.168.2.38 \
-e MESOS_IP=192.168.2.38 \
-e MESOS_QUORUM=2 \
-e MESOS_ZK=zk://192.168.2.37:2181,192.168.2.38:2181,192.168.2.39:2181/mesos \
--name mesos-master --net host --restart always 192.168.2.39:5000/mesos-master:0.28.1

docker run -d \
-e MESOS_HOSTNAME=192.168.2.38 \
-e MESOS_IP=192.168.2.38 \
-e MESOS_QUORUM=2 \
-e MESOS_ZK=zk://192.168.2.37:2181,192.168.2.38:2181,192.168.2.39:2181/mesos \
--name mesos-master --net host --restart always 192.168.2.39:5000/mesos-master:0.28.1

3. docker pull 192.168.2.39:5000/mesos-slave:0.28.1
# 
docker run -d \
-e MESOS_HOSTNAME=192.168.2.37 \
-e MESOS_IP=192.168.2.37 \
-e MESOS_MASTER=zk://192.168.2.37:2181,192.168.2.38:2181,192.168.2.39:2181/mesos \
-v /sys/fs/cgroup:/sys/fs/cgroup \
-v /var/run/docker.sock:/var/run/docker.sock \
--name slave --net host --privileged --restart always \
192.168.2.39:5000/mesos-slave:0.28.1

docker run -d \
-e MESOS_HOSTNAME=192.168.2.38 \
-e MESOS_IP=192.168.2.38 \
-e MESOS_MASTER=zk://192.168.2.37:2181,192.168.2.38:2181,192.168.2.39:2181/mesos \
-v /sys/fs/cgroup:/sys/fs/cgroup \
-v /var/run/docker.sock:/var/run/docker.sock \
--name slave --net host --privileged --restart always \
192.168.2.39:5000/mesos-slave:0.28.1


docker run -d \
-e MESOS_HOSTNAME=192.168.2.39 \
-e MESOS_IP=192.168.2.39 \
-e MESOS_MASTER=zk://192.168.2.37:2181,192.168.2.38:2181,192.168.2.39:2181/mesos \
-v /sys/fs/cgroup:/sys/fs/cgroup \
-v /var/run/docker.sock:/var/run/docker.sock \
--name slave --net host --privileged --restart always \
192.168.2.39:5000/mesos-slave:0.28.1


4. docker pull 192.168.2.39:5000/marathon:1.1.1
#  
docker run -d \
-e MARATHON_HOSTNAME=192.168.2.39 \
-e MARATHON_HTTPS_ADDRESS=192.168.2.39 \
-e MARATHON_HTTP_ADDRESS=192.168.2.39 \
-e MARATHON_MASTER=zk://192.168.2.37:2181,192.168.2.38:2181,192.168.2.39:2181/mesos \
-e MARATHON_ZK=zk://192.168.2.37:2181,192.168.2.38:2181,192.168.2.39:2181/marathon \
--name marathon --net host --restart always 192.168.2.39:5000/marathon:1.1.1




########### 使用API发布应用
#
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" \
192.168.2.37:8080/v2/apps -d '{
  "id": "/dkg/web1",
  "cmd": null,
  "cpus": 1,
  "mem": 128,
  "disk": 0,
  "instances": 1,
  "container": {
    "docker": {
      "image": "192.168.2.39:5000/nodejs1",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 8080,
          "protocol": "tcp",
          "name": null
        }
      ]
    },
    "type": "DOCKER"
  },
  "env": {},
  "labels": {
    "HAPROXY_GROUP": "dkg",
    "HAPROXY_0_VHOST": "web1.bn.com"
  }
}'



