FROM quay.io/spivegin/cockroach_builder AS build-env-go113
WORKDIR /opt/src/github.com/cockroachdb/

RUN apt-get update && apt-get install -y gcc make git 

RUN git clone https://github.com/cockroachdb/cockroach.git &&\
    cd cockroach &&\
    git clone https://github.com/cockroachdb/vendored.git &&\
    make

FROM quay.io/spivegin/tlmbasedebian