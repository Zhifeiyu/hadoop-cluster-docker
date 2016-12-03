#!/bin/bash

# the default node number is 3
N=${1:-3}
HADOOP_IAMGES_NAME=zfylin/hadoop:1.0
NET_NAME=hadoop
VOLUMN_PATH=/data/zfylin/hadoop-cluster

# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=${NET_NAME} \
                -p 50070:50070 \
                -p 8088:8088 \
		-p 10000:10000 \
                --name hadoop-master \
                --hostname hadoop-master \
		-v ${VOLUMN_PATH}/hadoop-master/hdfs:/root/hdfs \
                ${HADOOP_IAMGES_NAME} &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
			--net=${NET_NAME} \
	                --name hadoop-slave$i \
			--hostname hadoop-slave$i \
			-v ${VOLUMN_PATH}/hadoop-slave$i/hdfs:/root/hdfs \
			${HADOOP_IAMGES_NAME} &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash
