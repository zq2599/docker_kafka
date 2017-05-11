# Docker image of kafka
# VERSION 0.0.1
# Author: bolingcavalry

#基础镜像使用tomcat，这样可以免于设置java环境
FROM daocloud.io/library/tomcat:7.0.77-jre8

#作者
MAINTAINER BolingCavalry <zq2599@gmail.com>

#定义工作目录
ENV WORK_PATH /usr/local/work

#定义kafka文件夹名称
ENV KAFKA_PACKAGE_NAME kafka_2.9.2-0.8.1

#创建工作目录
RUN mkdir -p $WORK_PATH

#把启动server的shell复制到工作目录
COPY ./start_server.sh $WORK_PATH/

#把kafka压缩文件复制到工作目录
COPY ./$KAFKA_PACKAGE_NAME.tgz $WORK_PATH/

#解压缩
RUN tar -xvf $WORK_PATH/$KAFKA_PACKAGE_NAME.tgz -C $WORK_PATH/

#删除压缩文件
RUN rm $WORK_PATH/$KAFKA_PACKAGE_NAME.tgz

#执行sed命令修改文件，将连接zk的ip改为link参数对应的zookeeper容器的别名
RUN sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=zkhost:2181/g' $WORK_PATH/$KAFKA_PACKAGE_NAME/config/server.properties

#给shell赋予执行权限
RUN chmod a+x $WORK_PATH/start_server.sh