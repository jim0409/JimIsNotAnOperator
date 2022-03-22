FROM centos:7

ARG nats_version=nats-streaming-server-v0.18.0-linux-amd64
RUN yum update -y; yum install wget unzip -y

RUN wget https://github.com/nats-io/nats-streaming-server/releases/download/v0.18.0/${nats_version}.zip 
RUN unzip ${nats_version}

COPY *.config /
COPY ./entrypoint.sh .
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

