FROM centos:7
MAINTAINER Sergey Nartimov <just.lest@gmail.com>

RUN yum install -y rpm-build rpm-sign redhat-rpm-config rpmdevtools createrepo make git && \
  yum clean all
RUN echo '%_topdir /rpmbuild' > /root/.rpmmacros

WORKDIR /tmp
RUN curl -L -O https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /rpmbuild

ADD bin/build-spec /bin/build-spec

