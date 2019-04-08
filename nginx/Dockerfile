FROM centos:7
MAINTAINER Sergey Nartimov <just.lest@gmail.com>

RUN yum install -y rpm-build rpm-sign redhat-rpm-config rpmdevtools createrepo make git && \
  yum clean all
RUN echo '%_topdir /rpmbuild' > /root/.rpmmacros

WORKDIR /rpmbuild
ADD nginx-1.14.2-1.el7_4.ngx.src.rpm /rpmbuild

CMD /bin/bash

