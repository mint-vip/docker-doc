########## 安装etcd ################




########## flannel安装 ##############
下载 flannel-0.5.5-linux-amd64.tar.gz 解压,并将可执行文件放到 /usr/bin下去

etcdctl set /coreos.com/network/config '{"Network": "172.99.0.0/16", "Backend":{"Type": "vxlan"}}'
# 检查
etcdctl get /coreos.com/network/config

nohup flanneld & #会自动生成 /run/flannel/subnet.env

# 然后可生成docker-opts

# 生成docker需要的环境变量
mk-docker-opts.sh -i
source /run/flannel/subnet.env

# 检查环境配置：
echo ${FLANNEL_NETWORK} ：为flannel设置的网段
echo ${FLANNEL_SUBNET} ：
为flannel设置的子网段（给docker使用）

# 配置docker0
ifconfig docker0 ${FLANNEL_SUBNET}

# 检查路由
route -n

# 重启docker
systemctl restart docker

# 检查各主机分配的子网段
etcdctl ls /coreos.com/network/subnets

###################### 网络连接性测试##############
#1. 在marathon控制台以bridged方式启动容器，实例数3
#2. 在37主机上docker run -t -i 进入容器
docker exec -i -t 7d169c9e954b /bin/bash
ping 192.168.2.37/38/39  #容器外主机应该都可以通
#3. 在38主机上查看到相关实例的ip
docker inspect de2f2f66b087|grep IP  # "IPAddress": "172.99.4.4",

#4. 在37主机容器内ping 38上的容器
root@7d169c9e954b:/# ping 172.99.4.4  # 可以ping通
exit 退出容器
#5. 在37主机上ping37的容器

 


 docker run -d  192.168.2.39:5000/mesos-consul --zk=zk://192.168.2.37:2181,192.168.2.38:2181,192.168.2.39:2181/mesos 