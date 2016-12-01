FROM ubuntu:14.04

MAINTAINER KiwenLau <kiwenlau@gmail.com>

WORKDIR /root

COPY config/* /tmp/

# install openssh-server, openjdk and wget
RUN rm /etc/apt/sources.list
RUN mv /tmp/sources.list /etc/apt/
RUN apt-get update && apt-get install -y openssh-server openjdk-7-jdk wget

# install hadoop 2.7.2
#RUN wget https://github.com/kiwenlau/compile-hadoop/releases/download/2.7.2/hadoop-2.7.2.tar.gz && \
#    tar -xzvf hadoop-2.7.2.tar.gz && \
#    mv hadoop-2.7.2 /usr/local/hadoop && \
#    rm hadoop-2.7.2.tar.gz
ADD program/hadoop-2.7.2.tar.gz /usr/local
RUN mv /usr/local/hadoop-2.7.2 /usr/local/hadoop

ADD program/hbase-1.2.4-bin.tar.gz /usr/local
RUN mv /usr/local/hbase-1.2.4 /usr/local/hbase

ADD program/apache-hive-2.1.0-bin.tar.gz /usr/local
RUN mv /usr/local/apache-hive-2.1.0-bin /usr/local/hive
ADD program/mysql-connector-java-5.1.40.tar.gz /tmp
RUN cp /tmp/mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar /usr/local/hive/lib

ADD program/sqoop-1.4.6.bin__hadoop-2.0.4-alpha.tar.gz /usr/local
RUN mv /usr/local/sqoop-1.4.6.bin__hadoop-2.0.4-alpha /usr/local/sqoop
RUN cp /tmp/mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar /usr/local/sqoop/lib

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV HBASE_HOME=/usr/local/hbase
ENV HIVE_HOME=/usr/local/hive
ENV SQOOP_HOME=/usr/local/sqoop
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/hbase/bin:/usr/local/hive/bin:/usr/local/sqoop/bin 

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#RUN mkdir -p ~/hdfs/namenode && \ 
#    mkdir -p ~/hdfs/datanode && \
#    mkdir $HADOOP_HOME/logs
RUN  mkdir $HADOOP_HOME/logs 

#COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh && \
    mv /tmp/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml && \
    mv /tmp/regionservers $HBASE_HOME/conf/regionservers && \
    mv /tmp/start-hbase.sh ~/start-hbase.sh && \
    mv /tmp/stop-hbase.sh ~/stop-hbase.sh && \
    mv /tmp/hive-site.xml $HIVE_HOME/conf/hive-site.xml && \
    mv /tmp/hive-log4j2.properties $HIVE_HOME/conf/hive-log4j2.properties && \
    mv /tmp/hive-exec-log4j2.properties $HIVE_HOME/conf/hive-exec-log4j2.properties && \
    mv /tmp/hive-config.sh ~/hive-config.sh && \
    mv /tmp/sqoop-env.sh ${SQOOP_HOME}/conf

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x ~/start-hbase.sh && \
    chmod +x $HBASE_HOME/bin/start-hbase.sh && \
    chmod +x ~/stop-hbase.sh && \
    chmod +x ${HBASE_HOME}/bin/stop-hbase.sh && \
    chmod +x ~/hive-config.sh

# format namenode
#RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]

