Name:           etcd
Version:        %{_version}
Release:        %{_release}%{?dist}
Summary:        etcd

License:	Apache-2.0
URL:            https://github.com/jumperfly/etcd-rpm

%description
etcd RPM wrapper - https://coreos.com/etcd/

%files
/usr/bin/etcd
/usr/bin/etcdctl
/usr/lib/systemd/system/etcd.service
/usr/share/licenses/etcd-%{_version}/LICENSE
%attr(-, etcd, etcd) /var/lib/etcd
/etc/etcd
%config(noreplace) /etc/etcd/etcd.conf

%pre
getent group etcd >/dev/null || groupadd -r etcd
getent passwd etcd >/dev/null || useradd -r -g etcd -d /var/lib/etcd \
	-s /sbin/nologin -c "etcd user" etcd

%post
if [ $1 -eq 1 ] ; then 
        # Initial installation 
        systemctl preset etcd.service >/dev/null 2>&1 || : 
fi

%preun
if [ $1 -eq 0 ] ; then 
        # Package removal, not upgrade 
        systemctl --no-reload disable etcd.service > /dev/null 2>&1 || : 
        systemctl stop etcd.service > /dev/null 2>&1 || : 
fi

%postun
systemctl daemon-reload >/dev/null 2>&1 || :
