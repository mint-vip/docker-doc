###### 192.168.2.37·þÎñÆ÷Ê¹ÓÃ marathon-lb+haproxy ½øÐÐ¸ºÔØ
###### 192.168.2.38Ê¹ÓÃ traefik ½øÐÐ¸ºÔØ https://github.com/containous/traefik
###### Ê¹ÓÃConsul×ö¸ºÔØ


docker pull gregory90/bamboo

docker pull mesosphere/marathon-lb



# --privilegedÊ¹ÓÃdockerÄÚµÄrootÓµÓÐÕæÕýµÄrootÈ¨ÏÞ

docker run -d --privileged -e PORTS=11111 --net=host mesosphere/marathon-lb sse -m http://192.168.2.37:8080 -m http://192.168.2.38:8080 -m http://192.168.2.39:8080  --group dkg

## Ïà¹ØµÄ±ØÐëÊ¹ÓÃLabel²ÅÄÜ±»·¢ÏÖ

HAPROXY_GROUP  dkg
HAPROXY_0_VHOST web1.bn.com
# ÆäÖÐweb1.bn.com±ØÐëÅäÖÃhost£¬HAÊ¹ÓÃ¸Ã¹æÔò×ª·¢µ½ÏàÓ¦µÄ¶Ë¿ÚÉÏ



index.alauda.cn/mintvp/build1:latest



# marathonÅäÖÃ
{
  "id": "/dkg/test1",
  "cmd": null,
  "cpus": 1,
  "mem": 128,
  "disk": 0,
  "instances": 1,
  "container": {
    "docker": {
      "network": "BRIDGE",
      "forcePullImage": true,
      "image": "192.168.2.39:5000/nodejs1",
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
}






docker run -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h node1  index.alauda.cn/sequenceiq/consul:v0.5.0-v6 -server -bootstrap -ui-dir /ui

docker run -it -d \
-v /var/run/docker.sock:/tmp/docker.sock \
-h 192.168.2.38 index.alauda.cn/caishuo/registrator \
consul://192.168.2.38:8500


docker run -it -d \
-v /var/run/docker.sock:/tmp/docker.sock \
-h 192.168.2.37 index.alauda.cn/caishuo/registrator \
consul://192.168.2.38:8500

docker run -it -d \
-v /var/run/docker.sock:/tmp/docker.sock \
-h 192.168.2.39 index.alauda.cn/caishuo/registrator \
consul://192.168.2.38:8500











docker run -d --privileged -e PORTS=11111 --net=host  --restart=always \
mesosphere/marathon-lb sse -m http://192.168.2.37:8080 -m http://192.168.2.38:8080 -m http://192.168.2.39:8080  \
--group dkg



docker run -d --privileged -e PORTS=11112  \
--net=host --restart=always 192.168.2.39:5000/marathon-lb sse \
-m http://192.168.2.37:8080 -m http://192.168.2.38:8080 -m http://192.168.2.39:8080  \
--group pkg




sticky connections 
VHost based load balancing