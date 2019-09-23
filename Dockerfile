FROM quay.io/spivegin/cockroach_builder AS build-env-go113
WORKDIR $GOPATH/src/github.com/cockroachdb/

RUN git clone https://github.com/cockroachdb/cockroach.git &&\
    cd cockroach &&\
    mkrelease amd64-linux-gnu

FROM quay.io/spivegin/tlmbasedebian


