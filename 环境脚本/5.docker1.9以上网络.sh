# docker1.9自带 overlay网络，可以不使用 flanneld等相关工具
# docker1.9里必须内核3.16以上， docker1.10时修复了，只需要3.10以上就可以了
# 
# 
vim /usr/lib/systemd/system/docker.service

--cluster-store consul://localhost:8500 --cluster-advertise eth0:2375

systemctl daemon-reload
service docker restart	

# 
docker network create -d overlay  mynet1

docker network ls
# 会有 56a0207fa4f2        multihost           overlay
# 
# 部署一个应用，使用multihost网络
docker run -d --net=mynet1 --name=host3 192.168.2.39:5000/nodejs1

# 查看最终ip 
docker network inspect mynet1

## 问题，通过marathon配置docker时无法使用该网络模式

