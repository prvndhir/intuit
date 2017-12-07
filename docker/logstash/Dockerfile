FROM logstash:5.5

WORKDIR /deploy
COPY logstash.conf /deploy/logstash.conf
EXPOSE 12201
CMD ["-f", "/deploy/logstash.conf"]

