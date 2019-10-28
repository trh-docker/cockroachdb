
FROM quay.io/spivegin/cockroach_builder AS build

WORKDIR /go/src/github.com/cockroachdb/
ENV CGO_ENABLED=1 \
    XGOOS=linux \
    XGOARCH=amd64 \
    XCMAKE_SYSTEM_NAME=Linux \
    TARGET_TRIPLE=x86_64-unknown-linux-gnu \
    LDFLAGS="-static-libgcc -static-libstdc++" \
    SUFFIX=-linux-2.6.32-gnu-amd64 
RUN git clone git@github.com:cockroachdb/cockroach.git &&\
    cd cockroach &&\
    make buildshort &&\
    make buildoss &&\
    make build

FROM quay.io/spivegin/tlmbasedebian
WORKDIR /opt/cockroach
COPY --from=build /go/src/github.com/cockroachdb/cockroach/cockroachoss /opt/bin/
COPY --from=build /go/src/github.com/cockroachdb/cockroach/cockroachshort /opt/bin/
COPY --from=build /go/src/github.com/cockroachdb/cockroach/cockroach /opt/bin/
RUN cd /opt/bin/ &&\
    chmod +x cockroachoss &&\
    chmod +x cockroachshort &&\
    chmod +x cockroach &&\
    ln -s /opt/bin/cockroach /bin/cockroach


