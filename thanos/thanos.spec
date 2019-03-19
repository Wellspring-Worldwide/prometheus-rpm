%define debug_package %{nil}

Name:		 thanos
Version: 0.3.2
Release: 1%{?dist}
Summary: Thanos - Highly available Prometheus setup with long term storage capabilities.
License: ASL 2.0
URL:     https://github.com/improbable-eng/thanos
Conflicts: thanos

Source0: https://github.com/improbable-eng/thanos/releases/download/v%{version}/thanos-%{version}.linux-amd64.tar.gz
#Source1: thanos.service
#Source2: thanos.default

%{?systemd_requires}
Requires(pre): shadow-utils

%description
Thanos is a set of components that can be composed into a highly available metric system with unlimited storage capacity, which can be added seamlessly on top of existing Prometheus deployments.

%prep
%setup -q -n thanos-%{version}.linux-amd64

%build
/bin/true

%install
mkdir -vp %{buildroot}%{_sharedstatedir}/thanos
install -D -m 755 thanos %{buildroot}%{_bindir}/thanos

%files
%defattr(-,root,root,-)
%{_bindir}/thanos
