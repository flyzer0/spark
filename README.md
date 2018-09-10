# spark
spark on yarn

docker run -dit -p 8042:8042 -p 8088:8088 --hostname=master --name=master --network=rpts spark-yarn:latest
docker run -dit -p 8043:8042 --hostname=slave1 --name=slave1 --network=rpts spark-yarn:latest
docker run -dit -p 8044:8042 --hostname=slave2 --name=slave2 --network=rpts spark-yarn:latest
