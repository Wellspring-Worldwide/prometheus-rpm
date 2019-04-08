PACKAGES7 = prometheus \
alertmanager \
elasticsearch_exporter \
blackbox_exporter \
consul_exporter \
graphite_exporter \
jmx_exporter \
snmp_exporter \
apache_exporter \
collectd_exporter \
rabbitmq_exporter \
pushgateway \
sachet \
statsd_exporter \
ping_exporter \
logstash_exporter \
zookeeper_exporter \
openvpn_exporter \
nginx \
nginx_exporter \
thanos

.PHONY: $(PACKAGES7)

AUTO_GENERATED = node_exporter \
mysqld_exporter \
redis_exporter \
haproxy_exporter \
postgres_exporter \
kafka_exporter 

.PHONY: $(PACKAGES7)
.PHONY: $(AUTO_GENERATED)

all: auto $(PACKAGES7)

7: $(PACKAGES7)
auto: $(AUTO_GENERATED)

build_image:
	docker build -t build_centos7_rpm .

$(AUTO_GENERATED): build_image
	python ./generate.py --templates $@
	# Build for centos 7
	docker run -it --rm \
		-v ${PWD}/$@:/rpmbuild/SOURCES \
                -v ${PWD}/_dist7:/rpmbuild/SRPMS \
		-v ${PWD}/_dist7:/rpmbuild/RPMS/x86_64 \
		-v ${PWD}/_dist7:/rpmbuild/RPMS/noarch \
		build_centos7_rpm \
		/bin/build-spec SOURCES/autogen_$@.spec
	# Test the install
	docker run --privileged -it --rm \
		-v ${PWD}/_dist7:/var/tmp/ \
		build_centos7_rpm \
		/bin/bash -c '/usr/bin/yum install --verbose -y /var/tmp/$@*.rpm'

$(PACKAGES7): build_image
	docker run --rm \
		-v ${PWD}/$@:/rpmbuild/SOURCES \
		-v ${PWD}/_dist7:/rpmbuild/RPMS/x86_64 \
		-v ${PWD}/_dist7:/rpmbuild/RPMS/noarch \
                -v ${PWD}/_dist7:/rpmbuild/SRPMS \
		build_centos7_rpm \
		/bin/build-spec SOURCES/$@.spec

clean:
	rm -rf _dist*
	rm -f **/*.tar.gz
	rm -f **/*.jar
