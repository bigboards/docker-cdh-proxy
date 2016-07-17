# Pull base image.
FROM bigboards/cdh-base-__arch__

MAINTAINER bigboards
USER root 

RUN apt-get update \
    && apt-get install -y hadoop-mapreduce-historyserver hadoop-yarn-proxyserver \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*

ADD docker_files/historyserver-run.sh /apps/historyserver-run.sh
ADD docker_files/proxyserver-run.sh /apps/proxyserver-run.sh
RUN chmod a+x /apps/*.sh

# declare the volumes
RUN mkdir /etc/hadoop/conf.bb && \
    update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.bb 1 && \
    update-alternatives --set hadoop-conf /etc/hadoop/conf.bb
VOLUME /etc/hadoop/conf.bb

# internal ports
EXPOSE 10020 9046

# external ports
EXPOSE 19888 8080 

CMD ["/bin/bash"]
