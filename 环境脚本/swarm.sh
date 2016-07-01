## 纯命令行，待研究

1. 下载并上传到私有库
docker pull index.alauda.cn/library/swarm
docker tag  index.alauda.cn/library/swarm 192.168.2.39:5000/swarm
docker push 192.168.2.39:5000/swarm

2. 使用create命令在 hub.docker.io服务器上新建一个集群
docker run --rm 192.168.2.39:5000/swarm create
> 7fad1d46ae7bef0f211e84403989e48e

3. 启动
docker run -d --net=host 192.168.2.39:5000/swarm join --addr=192.168.2.37:2375 token://7fad1d46ae7bef0f211e84403989e48e
docker run -d --net=host 192.168.2.39:5000/swarm join --addr=192.168.2.38:2375 token://7fad1d46ae7bef0f211e84403989e48e
docker run -d --net=host 192.168.2.39:5000/swarm join --addr=192.168.2.39:2375 token://7fad1d46ae7bef0f211e84403989e48e

docker run -p 2375:2375 -d 192.168.2.39:5000/swarm manage token://7fad1d46ae7bef0f211e84403989e48e


docker -H tcp://192.168.2.37:2375 info