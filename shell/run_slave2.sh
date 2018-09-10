#!/bin/bash
echo 3 > /root/soft/apache/zookeeper/zookeeper-3.4.9/tmp/myid
zkServer.sh start
