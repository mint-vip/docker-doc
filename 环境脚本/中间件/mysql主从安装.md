# 使用官方mysql镜像即可
```
docker pull index.alauda.cn/library/mysql
```
# 镜像中核心文件备注
```
/var/lib/mysql    # 镜像中数据文件
/etc/mysql/conf.d  #镜像中配置文件
```
# 全量my.cnf文件
```
[client]
port            = 3306
socket          = /var/run/mysqld/mysqld.sock

[mysqld_safe]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
nice            = 0

[mysqld]
skip-host-cache
skip-name-resolve
user            = mysql
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
port            = 3306
basedir         = /usr
datadir         = /var/lib/mysql
tmpdir          = /tmp
lc-messages-dir = /usr/share/mysql
explicit_defaults_for_timestamp
# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
bind-address   = 0.0.0.0    
#log-error      = /var/log/mysql/error.log
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
log-bin=mylog
server_id=37
```
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

#在mysql-master上新增客户
```sql
-- 该用户提供给slave连接
create user repu identified by 'repu'
GRANT REPLICATION SLAVE ON *.* TO repu@127.0.0.1 IDENTIFIED BY 'repu';
flush privileges;
```
```sql
-- 在master上看
show master status;
```
```sql
-- 在slave上处理连接到master
stop slave 
change master to master_host = '192.168.2.37',master_port=3306,master_user='repu',master_password='repu',master_log_file='mylog.000002',master_log_pos=837;
start slave
```
