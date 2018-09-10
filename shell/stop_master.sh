#!/bin/bash
zkServer.sh stop
hadoop-daemons.sh stop journalnode
stop-dfs.sh
stop-yarn.sh
stop-all.sh
