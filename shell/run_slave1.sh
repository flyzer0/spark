#!/bin/bash
echo 2 > /root/soft/apache/zookeeper/zookeeper-3.4.9/tmp/myid
zkServer.sh start
