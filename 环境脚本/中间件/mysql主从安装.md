# mysql镜像中相关配置
/var/lib/mysql  
/etc/mysql/conf.d  映射到 /my/mysql

# docker启动
## 38,39主机上分别启动mysql

```sh
docker run -d --net=host --name mysql37  -v /my/mysql:/etc/mysql/conf.d \
-v /my/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=pwd1  192.168.2.39:5000/mysql
```
```sh
docker run -d --net=host --name mysql38  -v /my/mysql:/etc/mysql/conf.d \
-v /my/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=pwd2  192.168.2.39:5000/mysql
```

>在mysql-master上新增客户

```sql
create user repu identified by 'repu'
GRANT REPLICATION SLAVE ON *.* TO repu@127.0.0.1 IDENTIFIED BY 'repu';
flush privileges;
```
```sql
-- 在master上看
show master status;
```
```sql
-- 在slave上看呢
stop slave 
change master to master_host = '192.168.2.37',master_port=3306,master_user='repu',master_password='repu',master_log_file='mylog.000002',master_log_pos=837;
start slave
```


>主写从读
>1. sadfasdf
>2. asdfasdf
>3. sadfasdfasdf

##adfasdf##
*Asdfasdfas*
