
FROM quay.io/spivegin/cockroach_buildrunner:latest AS builder
ADD files/Source.list /etc/apt/sources.list

WORKDIR /go/src/github.com/cockroachdb/

RUN apt-get update && apt-get upgrade -y && apt-get install -y gnutls-bin
ENV CGO_ENABLED=1 \
    XGOOS=linux \
    XGOARCH=amd64 \
    XCMAKE_SYSTEM_NAME=Linux \
    TARGET_TRIPLE=x86_64-unknown-linux-gnu \
    LDFLAGS="-static-libgcc -static-libstdc++" \
    SUFFIX=-linux-2.6.32-gnu-amd64 
RUN git clone https://github.com/cockroachdb/cockroach.git &&\
    cd cockroach &&\
    make buildshort &&\
    make buildoss
    make build

FROM quay.io/spivegin/tlmbasedebian
WORKDIR /opt/cockroach
COPY --from=builder /go/src/github.com/cockroachdb/cockroach/cockroachoss /opt/bin/
COPY --from=builder /go/src/github.com/cockroachdb/cockroach/cockroachshort /opt/bin/
COPY --from=builder /go/src/github.com/cockroachdb/cockroach/cockroach /opt/bin/
RUN cd /opt/bin/ &&\
    chmod +x cockroachoss &&\
    chmod +x cockroachshort &&\
    chmod +x cockroach &&\
    ln -s /opt/bin/cockroach /bin/cockroach


