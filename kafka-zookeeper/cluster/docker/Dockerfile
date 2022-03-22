# refer: https://github.com/anapsix/docker-alpine-java
FROM anapsix/alpine-java

# kafka 下載位置
ENV URL=http://ftp.tc.edu.tw/pub/Apache/kafka/2.7.0
ENV KAFKA=kafka_2.13-2.7.0
ENV PATH=/${KAFKA}/bin:$PATH

# COPY ${KAFKA}.tgz .
RUN wget ${URL}/${KAFKA}.tgz
RUN tar zxvf ${KAFKA}.tgz

# 預先將檔案複製近 container 內
COPY *.properties /tmp
