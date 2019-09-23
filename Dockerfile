FROM quay.io/spivegin/cockroach_builder AS build-env-go125
#FROM quay.io/spivegin/cockroach_builder
WORKDIR $GOPATH/src/github.com/cockroachdb/

RUN git clone https://github.com/cockroachdb/cockroach.git &&\
    cd cockroach &&\
    mkrelease amd64-linux-gnu

FROM quay.io/spivegin/tlmbasedebian
WORKDIR /opt/cockroach
COPY --from=build-env-go125 /go/src/github.com/cockroachdb/cockroach/cockroach-linux* /opt/bin/
RUN cd /opt/bin/ &&\
    mv cockroach-linux* cockroach && chmod +x cockroach &&\
    ln -s /opt/bin/cockroach /bin/cockroach


