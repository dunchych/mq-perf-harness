FROM registry.access.redhat.com/ubi8/ubi-minimal

LABEL summary="IBM MQ Prometheus Exporter"
LABEL description="Implememnts open source MQ Prometheus Exporter https://github.com/ibm-messaging/mq-metric-samples in MQ Client mode"
LABEL io.k8s.display-name="IBM MQ Prometheus Exporter"
LABEL io.k8s.description="Implememnts open source MQ Prometheus Exporter https://github.com/ibm-messaging/mq-metric-samples in MQ Client mode"

# install IBM MQ 9.2 Redistributable client  
RUN mkdir /opt/mqm \
  && chown -R 1001:root /opt/mqm/
ADD dep/9.2.0.1-IBM-MQC-Redist-LinuxX64.tar.gz  /opt/mqm

RUN mkdir /run/runmqprometheus  \
  && chown -R 1001:root /run/runmqprometheus/ \ 
  && mkdir /run/runmqprometheus/tls \
  && chown -R 1001:root /run/runmqprometheus/tls/ \
  && mkdir /IBM \
  && chown -R 1001:root /IBM/ \
  && mkdir /IBM/MQ \
  && chown -R 1001:root /IBM/MQ/ \
  && mkdir /IBM/MQ/data \
  && chown -R 1001:root /IBM/MQ/data/ \
  && mkdir /IBM/MQ/data/errors \
  && chown -R 1001:root /IBM/MQ/data/errors/ \
  && mkdir //.mqm \
  && chown -R 1001:root //.mqm/


WORKDIR /run/runmqprometheus

ENV MQSERVER=SYSTEM.ADMIN.SVRCONN/TCP/secureqm-ibm-mq.cp4i-mq(1414)
ENV MQSSLKEYR=/run/runmqprometheus/tls/clientkey
ENV MQCCDTURL=file:///run/runmqprometheus/ccdt.json
ENV QUEUE_MANAGER=secureqm
ENV QUEUE_MANAGER_CHANNEL=SYSTEM.ADMIN.SVRCONN
ENV QUEUE_MANAGER_CCDT=file:///run/runmqprometheus/ccdt.json
ENV QUEUES_MONITORED=REQUEST*,REPLY*



COPY dep/mq_prometheus /run/runmqprometheus/mq_prometheus  
COPY tls/*  /run/runmqprometheus/tls/
# COPY mqclient.ini /run/runmqprometheus/mqclient.ini
COPY ccdt.json /run/runmqprometheus/ccdt.json

EXPOSE 9157
# We can run as any UID
USER 1001
#ENTRYPOINT ["/bin/bash", "-c", "sleep 1d"]
ENTRYPOINT ./mq_prometheus \
        -ibmmq.client=true \
        -ibmmq.queueManager=${QUEUE_MANAGER} \
        -ibmmq.monitoredChannels=${QUEUE_MANAGER_CHANNEL} \
        -ibmmq.monitoredQueues=${QUEUES_MONITORED} \
        -ibmmq.ccdtUrl=${QUEUE_MANAGER_CCDT} \
        -ibmmq.useStatus=true \
        -log.level=debug


#ENTRYPOINT ["./mq_prometheus", \
#            "-ibmmq.client=true", \
#            "-ibmmq.queueManager=${QUEUE_MANAGER}", \
#            "-ibmmq.monitoredChannels=${QUEUE_MANAGER_CHANNEL}", \
#            "-ibmmq.monitoredQueues=${QUEUES_MONITORED}", \
#            "-ibmmq.ccdtUrl=${QUEUE_MANAGER_CCDT}", \
#            "-ibmmq.useStatus=true", \
#            "-log.level=debug" \
#]



   
