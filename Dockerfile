FROM ubuntu:16.04
MAINTAINER zhifeng.wang

#ppa方式安装jdk默认选择条款
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

#安装java
RUN apt update \
	&& apt-get -y update \
	&& apt install -y software-properties-common python-software-properties \
	&& add-apt-repository ppa:webupd8team/java \
	&& apt update \
	&& apt install -y oracle-java8-installer

#安装工具
RUN apt update \
	&& apt install -y wget \
	&& apt install -y vim \
	&& apt install -y net-tools \
	&& apt install -y iputils-ping

WORKDIR /root
RUN mkdir soft && cd soft/ && mkdir shell && mkdir apache && mkdir scala \
	&& cd apache/ && mkdir zookeeper && mkdir hadoop && mkdir spark

#安装zookeeper
WORKDIR /root/soft/apache/zookeeper
RUN wget http://archive.apache.org/dist/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz \
	&& tar xvf zookeeper-3.4.9.tar.gz \
	&& rm -rf zookeeper-3.4.9.tar.gz
RUN cd zookeeper-3.4.9/conf/ && cp zoo_sample.cfg zoo.cfg \
	&& sed -i 's/dataDir=\/tmp\/zookeeper/dataDir=\/root\/soft\/apache\/zookeeper\/zookeeper-3.4.9\/tmp/g' zoo.cfg \
	&& echo "server.1=master:2888:3888" >> zoo.cfg \
	&& echo "server.2=slave1:2888:3888" >> zoo.cfg \
	&& echo "server.3=slave2:2888:3888" >> zoo.cfg \
	&& cd ../ && mkdir tmp && cd tmp/ && touch myid

#安装hadoop
WORKDIR /root/soft/apache/hadoop
RUN wget http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-2.7.6/hadoop-2.7.6.tar.gz \
	&& tar xvf hadoop-2.7.6.tar.gz \
	&& rm -rf hadoop-2.7.6.tar.gz \
	&& sed -i 's/JAVA_HOME=${JAVA_HOME}/JAVA_HOME=\/usr\/lib\/jvm\/java-8-oracle/g' hadoop-2.7.6/etc/hadoop/hadoop-env.sh
COPY hadoop/etc/hadoop/* hadoop-2.7.6/etc/hadoop/

#安装spark
WORKDIR /root/soft/apache/spark
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz \
	&& tar xvf spark-2.2.0-bin-hadoop2.7.tgz \
	&& rm -rf spark-2.2.0-bin-hadoop2.7.tgz
COPY spark/conf/* spark-2.2.0-bin-hadoop2.7/conf/

#安装scala
WORKDIR /root/soft/scala
RUN wget https://downloads.lightbend.com/scala/2.11.11/scala-2.11.11.tgz \
	&& tar xvf scala-2.11.11.tgz \
	&& rm -rf scala-2.11.11.tgz

#安装ssh
WORKDIR /root
RUN apt install -y ssh \
	&& ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
	&& cd .ssh/ && cat id_rsa.pub >> authorized_keys
COPY ssh/ssh_config /etc/ssh/

#环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle
ENV ZOOKEEPER_HOME=/root/soft/apache/zookeeper/zookeeper-3.4.9
ENV PATH=$PATH:$ZOOKEEPER_HOME/bin
ENV HADOOP_HOME=/root/soft/apache/hadoop/hadoop-2.7.6
ENV HADOOP_CONFIG_HOME=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin
ENV PATH=$PATH:$HADOOP_HOME/sbin
ENV SPARK_HOME=/root/soft/apache/spark/spark-2.2.0-bin-hadoop2.7
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
ENV SCALA_HOME=/root/soft/scala/scala-2.11.11
ENV PATH=$PATH:$SCALA_HOME/bin

RUN mkdir /var/run/sshd
#启动脚本
COPY shell/* soft/shell/
RUN chmod +x /root/soft/shell/*.sh

CMD ["/usr/sbin/sshd", "-D"]
