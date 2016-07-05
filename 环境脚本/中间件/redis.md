# 1. 下载redis镜像
```sh
docker pull index.alauda.cn/library/redis:3.2.0-alpine
docker tag index.alauda.cn/library/redis:3.2.0-alpine 192.168.2.39:5000/redis:3.2.0
```
# 2. 生成集群配置工具镜像
```sh
docker build -t 192.168.2.39:5000/redis-trib .
docker push 192.168.2.39:5000/redis-trib
```
# 3. 启动redis,每机器启动两个redis
```sh
# myredis1启动在6379端口
docker run -d --net=host -v /my/redis/redis.conf:/usr/local/etc/redis/redis.conf -v /my/redis/data:/data --name myredis1 192.168.2.39:5000/redis:3.2.0  redis-server /usr/local/etc/redis/redis.conf
# myredis2启动在6380端口
docker run -d --net=host -v /my/redis1/redis.conf:/usr/local/etc/redis/redis.conf -v /my/redis1/data:/data --name myredis2 192.168.2.39:5000/redis:3.2.0  redis-server /usr/local/etc/redis/redis.conf
# 检查启动日志, 显示 The server is now ready to accept connections on port xx
docker logs myredis1
docker logs myredis2
```
# 4. 进行集群的处理，三主三从
```sh
docker run -t -i  192.168.2.39:5000/redis-trib  create --replicas 1 192.168.2.37:6379 192.168.2.38:6379 192.168.2.39:6379 192.168.2.39:6380  192.168.2.37:6380 192.168.2.38:6380 
```
# 5. 查看集群状态
```sh
docker run -t -i  192.168.2.39:5000/redis-trib info 192.168.2.39:6379
```
# 6. 使用redis-cli
```sh
docker run -it 192.168.2.39:5000/redis:3.2.0 redis-cli -h redis -p 6379 -h 192.168.2.38
```
