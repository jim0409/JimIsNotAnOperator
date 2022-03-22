FROM centos:7

# pre require env
RUN yum update -y
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y openssl openssl-devel git wget

# install wrk
WORKDIR /
RUN git clone https://github.com/wg/wrk.git wrk
RUN cd wrk; make;  cp wrk /usr/bin

# install luajit
WORKDIR /
RUN git clone https://luajit.org/git/luajit-2.0.git
RUN cd luajit-2.0; make && make install

# install luarocks
WORKDIR /
RUN wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz
RUN tar zxf luarocks-3.3.1.tar.gz; cd luarocks-3.3.1; ./configure --with-lua-include=/luajit-2.0/src --lua-suffix=jit; make && make install

# install some basic pkg
RUN luarocks install jwt
RUN luarocks install luasocket
RUN luarocks install lunajson

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]