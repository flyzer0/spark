#!/bin/bash

echo 1 > /root/soft/apache/zookeeper/zookeeper-3.4.9/tmp/myid
zkServer.sh start

hadoop-daemons.sh start journalnode
hdfs namenode -format
hdfs zkfc -formatZK

start-dfs.sh
start-yarn.sh
start-all.sh
