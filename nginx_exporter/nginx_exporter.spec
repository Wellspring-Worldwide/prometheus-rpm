%define debug_package %{nil}

Name:    nginx_exporter 
Version: 0.10.3
Release: 1%{?dist}
Summary: Prometheus exporter for nginx server metrics
License: ASL 2.0
URL:     https://github.com/hnlq715/nginx-vts-exporter

Source1: %{name}.service
Source2: %{name}.default

%{?systemd_requires}
Requires(pre): shadow-utils

%description

Prometheus exporter for  server metrics.

%build
go get -u github.com/hnlq715/nginx-vts-exporter
go build github.com/hnlq715/nginx-vts-exporter

%install
mkdir -vp %{buildroot}%{_sharedstatedir}/prometheus
install -D -m 755 nginx-vts-exporter %{buildroot}%{_bindir}/%{name}
install -D -m 644 %{SOURCE1} %{buildroot}%{_unitdir}/%{name}.service
install -D -m 644 %{SOURCE2} %{buildroot}%{_sysconfdir}/default/%{name}

%pre
getent group prometheus >/dev/null || groupadd -r prometheus
getent passwd prometheus >/dev/null || \
  useradd -r -g prometheus -d %{_sharedstatedir}/prometheus -s /sbin/nologin \
          -c "Prometheus services" prometheus
exit 0

%post
%systemd_post %{name}.service

%preun
%systemd_preun %{name}.service

%postun
%systemd_postun %{name}.service

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_unitdir}/%{name}.service
%config(noreplace) %{_sysconfdir}/default/%{name}
%dir %attr(755, prometheus, prometheus)%{_sharedstatedir}/prometheus
