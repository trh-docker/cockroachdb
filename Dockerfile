FROM quay.io/spivegin/golang:v1.13 AS golang-src
RUN apt-get update && apt-get upgrade -y && apt-get install -y gnutls-bin
WORKDIR /opt/
ENV GO111MODULE=on
RUN git clone https://github.com/cockroachdb/cockroach.git

# FROM quay.io/spivegin/cockroach_builder AS build-env-go125
FROM quay.io/spivegin/cockroach_buildrunner AS build-env-go125

# RUN apt-get update && apt-get upgrade && apt-get install gnutls-bin -y
# RUN wget http://archive.ubuntu.com/ubuntu/pool/main/g/gnutls28/libgnutls30_3.5.18-1ubuntu1_amd64.deb && dpkg -i libgnutls30_3.5.18-1ubuntu1_amd64.deb
# RUN wget http://archive.ubuntu.com/ubuntu/pool/main/g/gnutls28/libgnutls-dane0_3.5.18-1ubuntu1_amd64.deb && dpkg -i libgnutls-dane0_3.5.18-1ubuntu1_amd64.deb &&\
#     wget http://archive.ubuntu.com/ubuntu/pool/universe/a/autogen/libopts25_5.18.12-4_amd64.deb && dpkg -i libopts25_5.18.12-4_amd64.deb &&\
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libt/libtasn1-6/libtasn1-6_4.13-2_amd64.deb && dpkg -i libtasn1-6_4.13-2_amd64.deb &&\
#     wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gnutls28/gnutls-bin_3.5.18-1ubuntu1_amd64.deb && dpkg -i gnutls-bin_3.5.18-1ubuntu1_amd64.deb
WORKDIR $GOPATH/src/github.com/cockroachdb/
RUN git config --global http.sslVerify false
ENV CGO_ENABLED=1 \
    XGOOS=linux \
    XGOARCH=amd64 \
    XCMAKE_SYSTEM_NAME=Linux \
    TARGET_TRIPLE=x86_64-unknown-linux-gnu \
    LDFLAGS="-static-libgcc -static-libstdc++" \
    SUFFIX=-linux-2.6.32-gnu-amd64 
COPY golang-src /opt/cockroach $GOPATH/src/github.com/cockroachdb/
RUN cd cockroach &&\
    make

FROM quay.io/spivegin/tlmbasedebian
WORKDIR /opt/cockroach
COPY --from=build-env-go125 /go/src/github.com/cockroachdb/cockroach/cockroach-linux* /opt/bin/
RUN cd /opt/bin/ &&\
    mv cockroach-linux* cockroach && chmod +x cockroach &&\
    ln -s /opt/bin/cockroach /bin/cockroach


