# FROM quay.io/spivegin/cockroach_builder AS build-env-go113
FROM quay.io/spivegin/cockroach_builder
WORKDIR $GOPATH/src/github.com/cockroachdb/

RUN git clone https://github.com/cockroachdb/cockroach.git &&\
    cd cockroach &&\
    mkrelease amd64-linux-gnu
ENTRYPOINT [ "bash" ]
# FROM quay.io/spivegin/tlmbasedebian


