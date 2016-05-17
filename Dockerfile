###========================================================================
### File: Dockerfile
###
### Dockerfile that sets up LogStash on CentOS 7.
###
###
### Author: Enrique Fernandez <efcasado@gmail.com>
###========================================================================
FROM       centos:7
MAINTAINER Enrique Fernandez <efcasado@gmail.com>

# Install utilities
RUN yum install -y \
        tar \
        wget

# Install Java 8
RUN cd /opt && \
    wget \
        --no-cookies \
        --no-check-certificate \
        --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
        "http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jre-8u40-linux-x64.tar.gz" && \
    tar xvf jre-8*.tar.gz && \
    rm jre-8*.tar.gz && \
    chown -R root: jre1.8* && \
    alternatives --install /usr/bin/java java /opt/jre1.8*/bin/java 1

ENV JAVA_HOME=/opt/jre1.8.0_40

# Install ElasticSearch
RUN mkdir -p /opt/logstash && \
    cd /opt/logstash       && \
    curl -L -O https://download.elastic.co/logstash/logstash/logstash-2.3.2.tar.gz && \
    tar -xvf logstash-2.3.2.tar.gz --strip 1

# Configure LogStash
COPY etc/logstash /etc/logstash

# Entry point
ENTRYPOINT [ "/opt/logstash/bin/logstash" ]
CMD        [ "agent", "-f",  "/etc/logstash/conf.d" ]
