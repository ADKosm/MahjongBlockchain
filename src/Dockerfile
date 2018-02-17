FROM ubuntu:16.04

ADD . /app/

WORKDIR /app/

ENV PATH=$PATH:/usr/lib/dart/bin

RUN apt-get update && apt-get install -y libssl-dev libffi-dev autoconf automake libtool python3 python3-pip software-properties-common
RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get update && apt-get install -y solc

RUN apt-get update && apt-get install -y apt-transport-https curl
RUN sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
RUN sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get update && apt-get install -y dart

RUN cd /app/backend/ && pip3 install -r requirements.txt
RUN cd /app/frontend/ && pub get && pub build -o ../backend/assets

CMD ["python3", "backend/application.py"]
