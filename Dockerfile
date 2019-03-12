# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 
# Copyright (c) 2015-2017 Oracle and/or its affiliates. All rights reserved.
# 
# GlassFish on Docker with Oracle Linux and OpenJDK
FROM oraclelinux:7-slim

# Maintainer
MAINTAINER Jack Zarris<jack@signalsciences.com> 

# Set environment variables and default password for user 'admin'
ENV GLASSFISH_PKG=glassfish-4.1.1.zip \
    GLASSFISH_URL=https://download.oracle.com/glassfish/4.1.1/release/glassfish-4.1.1.zip \
    GLASSFISH_HOME=/glassfish4 \
    MD5=4e7ce65489347960e9797d2161e0ada2 \
    PATH=$PATH:/glassfish4/bin \
    JAVA_HOME=/usr/lib/jvm/java-openjdk

# Install packages, download and extract GlassFish
# Setup password file
# Enable DAS
RUN yum -y install unzip java-1.7.0-openjdk-devel && \
    curl -O $GLASSFISH_URL && \
    echo "$MD5 *$GLASSFISH_PKG" | md5sum -c - && \
    unzip -o $GLASSFISH_PKG && \
    rm -f $GLASSFISH_PKG && \
    yum -y remove unzip && \
    rm -rf /var/cache/yum && \
    yum -y install wget && \
    yum -y install vim
    
# Install and Configure SigSci Agent
ADD sigsci.repo /etc/yum.repos.d/
RUN yum -y install sigsci-agent
COPY agent.conf /etc/sigsci/agent.conf

# Install and Configure SigSci Servlet Module
RUN cd /tmp
RUN wget https://dl.signalsciences.net/sigsci-module-java/sigsci-module-java_latest.tar.gz
RUN tar -xvzf sigsci-module-java_latest.tar.gz
RUN mv *.jar /glassfish4/glassfish/domains/domain1/lib/.
COPY default-web.xml /glassfish4/glassfish/domains/domain1/config/.

COPY docker-entrypoint.sh /entrypoint.sh
RUN  chmod +x entrypoint.sh

# Ports being exposed
EXPOSE 4848 8080 8181

ENTRYPOINT ["/entrypoint.sh"]
