FROM quay.io/spivegin/gitonly:latest AS source
WORKDIR /opt/
RUN git clone https://gitlab.com/cockroachdb/cockroach.git

FROM quay.io/spivegin/cockroachdb_builder AS build

WORKDIR /src/github.com/cockroachdb/
ENV CGO_ENABLED=1 \
    XGOOS=linux \
    XGOARCH=amd64 \
    XCMAKE_SYSTEM_NAME=Linux \
    TARGET_TRIPLE=x86_64-unknown-linux-gnu \
    LDFLAGS="-static-libgcc -static-libstdc++" \
    SUFFIX=-linux-2.6.32-gnu-amd64 \
    GOPATH=/opt/src/
# RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa && git config --global user.name "jhondoe1999" && ssh-keyscan -t rsa gitlab.com > ~/.ssh/known_hosts
RUN go get -u github.com/golang/dep/cmd/dep/...
COPY --from=source /opt/cockroach  /opt/src/github.com/cockroachdb/cockroach
RUN cd cockroach && dep ensure
RUN cd /opt/src/github.com/cockroachdb/cockroach && make buildshort
RUN cd /opt/src/github.com/cockroachdb/cockroach && make buildoss
RUN cd /opt/src/github.com/cockroachdb/cockroach && make build

FROM quay.io/spivegin/tlmbasedebian
WORKDIR /opt/cockroach
COPY --from=build /opt/src/github.com/cockroachdb/cockroach/cockroachoss /opt/bin/
COPY --from=build /opt/src/github.com/cockroachdb/cockroach/cockroachshort /opt/bin/
COPY --from=build /opt/src/github.com/cockroachdb/cockroach/cockroach /opt/bin/
RUN cd /opt/bin/ &&\
    chmod +x cockroachoss &&\
    chmod +x cockroachshort &&\
    chmod +x cockroach &&\
    ln -s /opt/bin/cockroach /bin/cockroach


