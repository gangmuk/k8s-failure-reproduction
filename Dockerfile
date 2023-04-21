FROM ubuntu:18.04

#WORKDIR /app
RUN apt-get update && \
    apt-get install software-properties-common -y && \
    apt-get install golang-go iproute2 -y && \
    apt-get install iputils-ping -y && \
    apt-get install wget -y && \
    apt-get install curl -y

EXPOSE 80

#CMD [ "/reqrouting-spam" ]
