FROM quay.io/spivegin/gitonly:latest AS source

FROM quay.io/spivegin/cockroach_buildrunner AS build
WORKDIR /opt/
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa && git config --global user.name "quadtone" && git config --global user.email "quadtone@txtsme.com" 
COPY --from=source /root/.ssh /root/.ssh
RUN git config --global url.git@github.com:.insteadOf https://github.com/
RUN git clone https://gitlab.com/trhhosting/cockroach.git &&\
    cd cockroach &&\
    unzip cockroach-v20.2.2.linux-amd64.zip


FROM quay.io/spivegin/tlmbasedebian
WORKDIR /opt/cockroach
COPY --from=build /opt/cockroach/cockroach-v20.2.2.linux-amd64/cockroach /opt/bin/cockroach
RUN cd /opt/bin/ &&\
    chmod +x cockroach &&\
    ln -s /opt/bin/cockroach /bin/cockroach