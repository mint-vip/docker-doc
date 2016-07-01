FROM index.alauda.cn/library/java:8u91-jdk
RUN mkdir -p /code
WORKDIR /code

ADD lib /code/lib
ADD aaa.jar /code/aaa.jar

CMD ["java", "-jar", "aaa.jar"]



#docker build -t 192.168.2.39:5000/dubbo-s1 .
#docker push 192.168.2.39:5000/dubbo-s1
#docker run  --net=host -e HOST=192.168.2.37 -e  PORT0=56711 192.168.2.39:5000/dubbo-s1
