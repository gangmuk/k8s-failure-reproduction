FROM ubuntu:18.04
FROM python:3.8-slim-buster

#WORKDIR H1

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-get install iputils-ping -y
RUN apt-get install wget -y
RUN apt-get install curl -y
RUN apt-get install python3 -y
RUN apt-get install python3-numpy -y
RUN apt-get install python3-pip -y
RUN pip3 install numpy
RUN apt-get install vim -y
RUN apt-get install procps -y
RUN apt-get install htop -y


EXPOSE 80

ADD . .

#CMD ["/H1/run.sh"]
#ENTRYPOINT ["run.sh"]
#ENTRYPOINT ["echo" "asdf" ">" "ent.txt"]
#CMD ["echo" "qwer" ">" "cmd.txt"]
