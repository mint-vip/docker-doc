1. cd /etc/yum.repos.d/
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
rm -rf CentOS-Base.repo
mv CentOS7-Base-163.repo CentOS-Base.repo

2. 下载docker
# 清理更新下  yum clean all、yum update 
yum install docker-io #安装的docker 1.9
(1)启动，systemctl start docker.service  / systemctl stop docker.service
(2)开机启动，systemctl enable docker.service
# 验证
docker verison
docker images

3. 卸载
yum list installed | grep docker
yum -y remove docker*
yum -y remove docker-engine.x86_64
################## 可选： 安装docker 1.11 

# 使用官方的
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

# 安装最新版本 1.11版本
yum install -y docker-engine

########### centos7增加私有库 ##########################
vim /usr/lib/systemd/system/docker.service
在这行加入参数：ExecStart=/usr/bin/docker daemon --insecure-registry 192.168.2.233:5000 -H fd://
systemctl daemon-reload
service docker restart

ps -ef|grep docker 查看一下
应该显示 /usr/bin/docker daemon --insecure-registry 192.168.2.39:5000 -H fd://


############# 搭建私有库 ############
1. 下载一个registry镜像 
docker pull index.alauda.cn/library/registry:2.4.1
2. 启动镜像，存放在本地/home/docker/registry
docker run -d --net=host --restart=always -v /home/docker/registry:/tmp/registry-dev index.alauda.cn/library/registry:2.4.1


#### 有用命令 #############
#
docker rm $(docker ps -a -q)