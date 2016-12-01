#!/bin/bash

echo "mkdir hdfs path"
hadoop fs -mkdir /tmp
hadoop fs -mkdir /hive
hadoop fs -chmod g+w /tmp
hadoop fs -chmod g+w /hive

echo "initSchema ..."
$HIVE_HOME/bin/schematool -dbType mysql -initSchema

