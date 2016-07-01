FROM 192.168.2.39:5000/mysql

ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD run.sh /run.sh

RUN chmod 775 /*.sh

ADD my.cnf /etc/mysql/my.cnf

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

# RUN sed -i -r 's/bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/my.cnf

EXPOSE 3306
CMD ["/run.sh"]
