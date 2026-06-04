class compute_epoxy::install inherits compute_epoxy::params {

#include compute_epoxy::params

$cloud_role = $compute_epoxy::cloud_role          

### Repository settings (remove old rpm and install new one)
  
  define removepackage {
    exec {
        "removepackage_$name":
            command => "/usr/bin/yum -y erase $name",
            onlyif => "/bin/rpm -ql $name",
    }
  }

  $oldrelease = [ 'centos-release-openstack-caracal',
                ]

#  $newrelease =  'https://trunk.rdoproject.org/rdo_release/rdo-release.el9s.rpm'

#  $releaseepoxy = 'rdo-release'
                  
  $file_path = '/tmp/rdo-release.rpm'
  $url = 'https://trunk.rdoproject.org/rdo_release/rdo-release.el9s.rpm'


  $yumutils = 'yum-utils'

  $genericpackages = [ "crudini",
                       "ipset",
                       "sysfsutils", ]

  $neutronpackages = [ "openstack-neutron",
                       "openstack-neutron-openvswitch",
                       "openstack-neutron-common",
                       "openstack-neutron-ml2", ]

  $novapackages = [ "openstack-nova-compute",
                     "openstack-nova-common", ]

  file { "/etc/yum/vars/contentdir":
         path    => '/etc/yum/vars/contentdir',
         ensure  => 'present',
         content => 'centos',
  } ->

  compute_epoxy::install::removepackage{
     $oldrelease :
  } ->

  exec { "yum remove bareos packages":
         command => "/usr/bin/yum -y remove bareos-common bareos-filedaemon",
         onlyif => "/usr/bin/yum list installed | grep bareos-common | grep -v 'commandline'",
  } ->

  exec { "removestring_failover":
            command => "/usr/bin/sed -i \"/failovermethod/d\" /etc/yum.repos.d/puppet5.repo",
            onlyif => "/usr/bin/grep failovermethod=priority /etc/yum.repos.d/puppet5.repo",
  } ->

  package { $yumutils :
    ensure => 'installed',
  } ->

  if $operatingsystemrelease =~ /^9.*/ {
      exec { "yum enable crb repo":
             command => "/usr/bin/yum-config-manager --enable crb",
             unless => "/usr/bin/yum repolist enabled | grep -i crb",
             timeout => 3600,
             require => Package[$yumutils],
      }
  }
  else { 
      exec { "yum enable PowerTools repo":
             command => "/usr/bin/yum-config-manager --enable powertools",
             unless => "/usr/bin/yum repolist enabled | grep -i powertools",
             timeout => 3600,
             require => Package[$yumutils],
      }
  }


# Esegue yum clean all once (lo si fa a meno che non stiamo gia` usando il repo epoxy)
  exec { "clean repo cache":
         command => "/usr/bin/yum clean all",
         unless => "/bin/rpm -q rdo-release-epoxy",
  } ->

  file { $file_path:
     ensure => file,
     source => $url,
  } ->

  package { 'rdo-release':
     ensure   => installed,
     provider => rpm,
     source   => $file_path,
     require  => File[$file_path],
  } ->

#  exec { "rpm install rdo-release":
#             command => "/usr/bin/yum install -y https://trunk.rdoproject.org/rdo_release/rdo-release.el9s.rpm",
#             unless => "/bin/rpm -qa | grep rdo-release-epoxy",
#             timeout => 3600,
#  } ->

#  package { 'rdo-release':
#     ensure   => installed,
#     name     => 'https://trunk.rdoproject.org/rdo_release/rdo-release.el9s.rpm',
#     provider => 'yum',
#  } ->

  ### negli update si consiglia di disabilitare EPEL (epel-next e' l'unico abilitato da disabilitare) 
  exec { "yum disable EPEL repo":
         command => "/usr/bin/yum-config-manager --disable epel\\*",
         onlyif => "/bin/rpm -qa | grep rdo-release-epoxy && /usr/bin/yum repolist enabled | grep epel",
         timeout => 3600,
         require => Package[$yumutils],
  } -> 

#  exec { "yum update for Ceph from Yoga to Epoxy enabling epel":
#         command => "/usr/bin/yum -y update *ceph-common-18.2.5* --enablerepo=epel",
#         onlyif => "/usr/bin/yum list installed | grep ceph-common | grep -i 'pacific'",
#         timeout => 3600,
#  } ->

  exec { "rpm remove python3-requests":
         command => "/bin/rpm -e --nodeps python3-requests+use_chardet_on_py3-2.31.0-3.el9s.noarch",
         onlyif => "/usr/bin/yum list installed | grep openstack-neutron.noarch | grep -i 'caracal'",
         timeout => 3600,
  } ->

  exec { "rpm remove python3-oslo-messaging+amqp1":
         command => "/bin/rpm -e --nodeps python3-oslo-messaging+amqp1", 
         onlyif => "/usr/bin/yum list installed | grep openstack-neutron.noarch | grep -i 'caracal'",
         timeout => 3600,
  } ->

  exec { "yum update to Epoxy in DELL hosts":
#         command => "/usr/bin/yum -y update --disablerepo dell-system-update_independent --disablerepo dell-system-update_dependent --disablerepo centos-ceph-reef",
         command => "/usr/bin/yum -y update",
         onlyif => "/bin/rpm -qi dell-system-update | grep 'Architecture:' &&  /usr/bin/yum list installed | grep openstack-neutron.noarch | grep -i 'caracal'",
         timeout => 3600,
  } ->

  exec { "yum update to Epoxy in non DELL hosts":
#         command => "/usr/bin/yum -y update --disablerepo centos-ceph-reef",
         command => "/usr/bin/yum -y update",
         onlyif => "/bin/rpm -qi dell-system-update | grep 'not installed' &&  /usr/bin/yum list installed | grep openstack-neutron.noarch | grep -i 'caracal'",
         timeout => 3600,
  } ->

# Rename nova config file  
  exec { "mv_nova_conf_old":
         command => "/usr/bin/mv /etc/nova/nova.conf /etc/nova/nova.conf.caracal",
         onlyif  => "/usr/bin/test -e /etc/nova/nova.conf.rpmnew",
  } ->
 
  exec { "mv_nova_conf_new":
         command => "/usr/bin/mv /etc/nova/nova.conf.rpmnew /etc/nova/nova.conf",
         onlyif  => "/usr/bin/test -e /etc/nova/nova.conf.rpmnew",
  } ->

# Rename neutron config file  
  exec { "mv_neutron_conf_old":
         command => "/usr/bin/mv /etc/neutron/neutron.conf /etc/neutron/neutron.conf.caracal",
         onlyif  => "/usr/bin/test -e /etc/neutron/neutron.conf.rpmnew",
  } ->

  exec { "mv_neutron_conf_new":
         command => "/usr/bin/mv /etc/neutron/neutron.conf.rpmnew /etc/neutron/neutron.conf",
         onlyif  => "/usr/bin/test -e /etc/neutron/neutron.conf.rpmnew",
  } ->

  exec { "mv_neutron_openvswitch_old":
         command => "/usr/bin/mv /etc/neutron/plugins/ml2/openvswitch_agent.ini /etc/neutron/plugins/ml2/openvswitch_agent.ini.caracal",
         onlyif  => "/usr/bin/test -e /etc/neutron/plugins/ml2/openvswitch_agent.ini.rpmnew",
  } ->

  exec { "mv_neutron_openvswitch_new":
         command => "/usr/bin/mv /etc/neutron/plugins/ml2/openvswitch_agent.ini.rpmnew /etc/neutron/plugins/ml2/openvswitch_agent.ini",
         onlyif  => "/usr/bin/test -e /etc/neutron/plugins/ml2/openvswitch_agent.ini.rpmnew",
  } ->


  exec { "mv_neutron_ml2_old":
         command => "/usr/bin/mv /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini.caracal",
         onlyif  => "/usr/bin/test -e /etc/neutron/plugins/ml2/ml2_conf.ini.rpmnew",
  } ->

  exec { "mv_neutron_ml2_new":
         command => "/usr/bin/mv /etc/neutron/plugins/ml2/ml2_conf.ini.rpmnew /etc/neutron/plugins/ml2/ml2_conf.ini",
         onlyif  => "/usr/bin/test -e /etc/neutron/plugins/ml2/ml2_conf.ini.rpmnew",
  } ->


## Install generic packages
  package { $genericpackages: 
    ensure => "installed",
    require => Package['rdo-release']
   } ->

  package { $neutronpackages: 
    ensure => "installed",
    require => Package['rdo-release']
  } ->

  package { $novapackages: 
    ensure => "installed",
    require => Package['rdo-release']
  } ->

  file_line { '/etc/sudoers.d/neutron  syslog':
               path   => '/etc/sudoers.d/neutron',
               line   => 'Defaults:neutron !requiretty, !syslog',
               match  => 'Defaults:neutron !requiretty',
            }
 
if $::compute_epoxy::cloud_role == "is_prod_localstorage" or $::compute_epoxy::cloud_role ==  "is_prod_sharedstorage" {

   package { 'glusterfs-fuse':
              ensure => 'installed',
           }
 } 
}
