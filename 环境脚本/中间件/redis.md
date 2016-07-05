# 1. redis镜像
```sh
docker pull index.alauda.cn/library/redis:3.2.0-alpine
docker tag index.alauda.cn/library/redis:3.2.0-alpine 192.168.2.39:5000/redis:3.2.0
```

# 2. 生成集群配置工具ruby
```sh
docker build -t 192.168.2.39:5000/redis-trib .
docker push 192.168.2.39:5000/redis-trib

```

# 3. 三台机器上运行redis
docker run -d --net=host -v /my/redis/redis.conf:/usr/local/etc/redis/redis.conf -v /my/redis/data:/data --name myredis 192.168.2.39:5000/redis:3.2.0  redis-server /usr/local/etc/redis/redis.conf

# 4. 进行集群的处理
docker run -t -i  192.168.2.39:5000/redis-trib redis-trib.rb  create --replicas 0 192.168.2.37:6379 192.168.2.38:6379 192.168.2.39:6379

# 5. 查看集群状态
docker run -t -i  192.168.2.39:5000/redis-trib redis-trib.rb info 192.168.2.39:6379
