FROM  192.168.1.110:5000/tomcat:7

MAINTAINER "huangzq@asiainfo.com"

RUN mkdir -p /code
WORKDIR /code

ADD src /code/src
ADD pom.xml /code/pom.xml

# bulid project
RUN mvn clean install package

# clean maven rep
RUN rm -rf /usr/.m2/repository

RUN yes|cp target/*.war $CATALINA_HOME/webapps

RUN rm -rf /code



