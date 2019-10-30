FROM quay.io/spivegin/gitonly:latest AS source

FROM quay.io/spivegin/cockroach_buildrunner AS build
WORKDIR /go/src/github.com/cockroachdb/
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa && git config --global user.name "quadtone" && git config --global user.email "quadtone@txtsme.com" 
COPY --from=source /root/.ssh /root/.ssh
RUN git config --global url.git@github.com:.insteadOf https://github.com/
RUN git clone git@github.com:cockroachdb/cockroach.git &&\
    go get github.com/pkg/errors 
RUN cd /go/src/github.com/cockroachdb/cockroach && make buildshort
RUN cd /go/src/github.com/cockroachdb/cockroach && make buildoss
RUN cd /go/src/github.com/cockroachdb/cockroach && make build

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