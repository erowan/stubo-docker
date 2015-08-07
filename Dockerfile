FROM debian:wheezy

MAINTAINER Rowan Shulver <rowan.shulver@opencredo.com>

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r stubo && useradd -r -g stubo stubo

# Install dependent packages

RUN apt-get update -y
RUN apt-get install -y python-dev build-essential python-pip wget python2.7-dev libxml2 libxml2-dev libxslt1-dev supervisor

RUN mkdir -p /opt/stubo && chown stubo:stubo /opt/stubo
VOLUME /opt/stubo
WORKDIR /opt/stubo

RUN mkdir -p /opt/stubo/stubo-app-master

# install stubo into system python
RUN pip install https://github.com/Stub-O-Matic/stubo-app/archive/master.tar.gz

RUN mkdir -p /opt/stubo/stubo-app-master/etc 
RUN mkdir -p /usr/local/python/

ADD etc/dev.ini /opt/stubo/stubo-app-master/etc/dev.ini

EXPOSE 8001

CMD ["stubo", "-c", "/opt/stubo/stubo-app-master/etc/dev.ini"]