FROM centos:7

### install java
ENV JAVA_VERSION 8
ENV JAVA_RELEASE JDK

# Upgrading system
RUN yum -y update && \
    yum -y install curl nss-tools python3

RUN set -euxo pipefail && \
    pkg="java-1.$JAVA_VERSION.0-openjdk" && \
    if [ "$JAVA_RELEASE" = "JDK" ]; then \
        pkg="$pkg-devel"; \
    else \
        pkg="$pkg-headless"; \
    fi; \
    yum install -y "$pkg" && \
    yum clean all && \
    rm -rf /var/cache/yum

ENV JAVA_HOME /usr/lib/jvm/jre
ENV PATH $PATH:$JAVA_HOME/bin

### https://github.com/Yelp/dumb-init
RUN curl -fLsS -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 && chmod +x /usr/local/bin/dumb-init

RUN rpm -i http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm && \
    yum -y install mesos-0.28.0

### http://docs.docker.com/installation/centos/
RUN curl -fLsS https://get.docker.com/ | sh && test -x /usr/bin/docker

# mesos env
ENV MESOS_WORK_DIR /tmp/mesos
ENV MESOS_LOG_DIR /var/log/mesos
ENV MESOS_CONTAINERIZERS docker,mesos
# https://mesosphere.github.io/marathon/docs/native-docker.html
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins
# https://issues.apache.org/jira/browse/MESOS-4675
ENV MESOS_SYSTEMD_ENABLE_SUPPORT false

VOLUME /tmp/mesos
VOLUME /var/log/mesos

# install spark2.0.1
RUN mkdir /opt/spark && \
    curl http://archive.apache.org/dist/spark/spark-2.0.1/spark-2.0.1-bin-hadoop2.7.tgz \
    | tar --strip-components=1 -xzC /opt/spark && \
    rm -rf /opt/spark/examples

# spark env
ENV SPARK_HOME /opt/spark
ENV PATH $PATH:/opt/spark/bin
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so
ENV SPARK_EXECUTOR_URI http://archive.apache.org/dist/spark/spark-2.0.1/spark-2.0.1-bin-hadoop2.7.tgz

EXPOSE 4040 8080 8081 7077

COPY entrypoint.sh /

ENTRYPOINT ["/usr/local/bin/dumb-init", "/entrypoint.sh"]
