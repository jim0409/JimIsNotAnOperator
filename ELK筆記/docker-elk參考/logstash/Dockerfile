# https://github.com/elastic/logstash-docker
# FROM docker.elastic.co/logstash/logstash:7.2.1
FROM docker.elastic.co/logstash/logstash:7.9.1
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-nsq
# COPY logstash.conf /usr/share/logstash/pipeline/logstash.conf


# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json
