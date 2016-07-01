1. 下载安装
https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip
2. unzip consul_0.6.4_linux_amd64.zip
 chmod +x *

2.  cp consul /usr/bin

3. consul集群建立 

--- 1.启动(后面要重启的)
consul agent -bind=192.168.2.37 -client=0.0.0.0 -server  \
-bootstrap -data-dir /tmp/consul -ui -ui-dir /home/docker/consul/ui \
-dc dc-hhh -node node1 & >>/dev/null

-- 2. 启动并加入
consul agent -server -bind=192.168.2.38 -client=0.0.0.0 \
-data-dir /tmp/consul -ui -ui-dir /home/docker/consul/ui \
-dc dc-hhh -node node2 -join  192.168.2.37  & >>/dev/null 

consul agent -server -bind=192.168.2.39 -client=0.0.0.0 \
-data-dir /tmp/consul -ui -ui-dir /home/docker/consul/ui \
-dc dc-hhh -node node3 -join  192.168.2.37  & >>/dev/null 

---3. 重启主节点，去掉bootstrap
ps -enp|grep consul|awk '{print $1}'|xargs kill -9

consul agent -bind=192.168.2.37 -client=0.0.0.0 -server  \
-data-dir /tmp/consul -ui -ui-dir /home/docker/consul/ui \
-dc dc-hhh -node node1 -join  192.168.2.38 & >>/dev/null


# 如果需要单独加入，请运行
consul join 192.168.2.37 


##界面
192.168.2.37:8500/ui


############### 使用registrator来发现服务， 还可以使用 mesos-consul 
docker pull gliderlabs/registrator:latest
docker run -d \
--name=registrator1 \	
--net=host --restart=always \
--volume=/var/run/docker.sock:/tmp/docker.sock \
192.168.2.39:5000/registrator \
consul://localhost:8500


############# consul api删除 ############

curl -X PUT -H 'application/json' -d '{"Datacenter": "dc-hhh", "Node": "node2, "ServiceID":"localhost.localdomain:mesos-e9a26853-a020-4297-a73b-4ca93ff17730-S2.4bbd7122-13f0-4eaf-bc6f-b76ccab50144:8080"}' http://localhost:8500/v1/catalog/deregister

{"Datacenter": "dc-hhh", "Node": "node1", "ServiceID": "redis1"}

############# 使用dig命令
#yum install bind-utils
#

##　consul内置的dns使用
dig @127.0.0.1 -p 8600 mesos.service.consul
dig @127.0.0.1 -p 8600 mesos.node.consul

#查看集群中所有的
dig @127.0.0.1 -p 8600 nodejs1.service.consul SRV



http://localhost:8500/v1/