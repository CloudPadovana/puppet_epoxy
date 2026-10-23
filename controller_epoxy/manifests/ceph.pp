class controller_epoxy::ceph inherits controller_epoxy::params {

  exec { "Install ceph-release squid rpm":
            command => "/usr/bin/rpm -Uvh https://download.ceph.com/rpm-squid/el9/noarch/ceph-release-1-1.el9.noarch.rpm",
            timeout => 3600,
            unless => "/bin/rpm -q ceph-release"
          }->
     package { 'ceph-common':
              ensure => 'installed',
             }




####ceph.conf, ceph.client.cinder ceph.client.glance keyring file are in /controller_epoxy/files dir
                                                            
     file {'ceph.conf':
            source      => 'puppet:///modules/controller_epoxy/ceph.conf',
            path        => '/etc/ceph/ceph.conf',
            backup      => true,
            require => Package["ceph-common"],
          }
     file {'ceph-ec.conf':
            source      => 'puppet:///modules/controller_epoxy/ceph-ec.conf',
            path        => '/etc/ceph/ceph-ec.conf',
            backup      => true,
            require => Package["ceph-common"],
          }

  if $::controller_epoxy::cloud_role == "is_production" {

      file {'cinder-prod.keyring':
              source      => 'puppet:///modules/controller_epoxy/ceph.client.cinder-prod.keyring',
              path        => '/etc/ceph/ceph.client.cinder-prod.keyring',
              backup      => true,
              owner   => cinder,
              group   => cinder,
              mode    => "0640",
              require => Package["ceph-common"],
           }

      file {'cinder-prod-secure.keyring':
              source      => 'puppet:///modules/controller_epoxy/ceph.client.cinder-prod-secure.keyring',
              path        => '/etc/ceph/ceph.client.cinder-prod-secure.keyring',
              backup      => true,
              owner   => cinder,
              group   => cinder,
              mode    => "0640",
              require => Package["ceph-common"],
           }

      file {'glance-prod.keyring':
              source      => 'puppet:///modules/controller_epoxy/ceph.client.glance-prod.keyring',
              path        => '/etc/ceph/ceph.client.glance-prod.keyring',
              backup      => true,
              owner   => glance,
              group   => glance,
              mode    => "0640",
              require => Package["ceph-common"],
         }

      file {'glance-prod-secure.keyring':
              source      => 'puppet:///modules/controller_epoxy/ceph.client.glance-prod-secure.keyring',
              path        => '/etc/ceph/ceph.client.glance-prod-secure.keyring',
              backup      => true,
              owner   => glance,
              group   => glance,
              mode    => "0640",
              require => Package["ceph-common"],
         }

  }                          
      
  if $::controller_epoxy::cloud_role == "is_test" {

      file {'cinder-cloudtest.keyring':
              source      => 'puppet:///modules/controller_epoxy/ceph.client.cinder-cloudtest.keyring',
              path        => '/etc/ceph/ceph.client.cinder-cloudtest.keyring',
              backup      => true,
              owner   => cinder,
              group   => cinder,
              mode    => "0640",
              require => Package["ceph-common"],
           }
	   
      file {'cinder-cloudtest-secure.keyring':
              source      => 'puppet:///modules/controller_epoxy/ceph.client.cinder-cloudtest-secure.keyring',
              path        => '/etc/ceph/ceph.client.cinder-cloudtest-secure.keyring',
              backup      => true,
              owner   => cinder,
              group   => cinder,
              mode    => "0640",
              require => Package["ceph-common"],
           }

      file {'glance-test.keyring':
              source      => 'puppet:///modules/controller_epoxy/ceph.client.glance-cloudtest.keyring',
              path        => '/etc/ceph/ceph.client.glance-cloudtest.keyring',
              backup      => true,
              owner   => glance,
              group   => glance,
              mode    => "0640",
              require => Package["ceph-common"],
         }
      file {'glance-test-secure.keyring':
              source      => 'puppet:///modules/controller_epoxy/ceph.client.glance-cloudtest-secure.keyring',
              path        => '/etc/ceph/ceph.client.glance-cloudtest-secure.keyring',
              backup      => true,
              owner   => glance,
              group   => glance,
              mode    => "0640",
              require => Package["ceph-common"],
         }

  }                 
} 
