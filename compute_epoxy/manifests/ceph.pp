class compute_epoxy::ceph inherits compute_epoxy::params {

#     package { 'ceph-common':
#                 ensure => 'installed',
#}

   exec { "Install ceph-release squid rpm":
            command => "/usr/bin/rpm -Uvh https://download.ceph.com/rpm-squid/el9/noarch/ceph-release-1-1.el9.noarch.rpm",
            timeout => 3600,
            unless => "/bin/rpm -q ceph-release"
          }->



    exec { "Install ceph":
         command => "/usr/bin/yum -y install *ceph-common* --enablerepo=epel",
         unless => "/bin/rpm -q ceph-common",
         timeout => 3600,
  } ->



     file {'ceph.conf':
              source      => 'puppet:///modules/compute_epoxy/ceph.conf',
              path        => '/etc/ceph/ceph.conf',
              backup      => true,
#              require => Package["ceph-common"],
          }

     file {'secret.xml':
             path        => '/etc/nova/secret.xml',
             backup      => true,
             content  => template('compute_epoxy/secret.erb'),
             require => Package["openstack-nova-common"],
          }
	  
     file {'secret-secure.xml':
             path        => '/etc/nova/secret-secure.xml',
             backup      => true,
             content  => template('compute_epoxy/secret-secure.erb'),
             require => Package["openstack-nova-common"],
          }

      $cm = '/usr/bin/virsh secret-define --file /etc/nova/secret.xml | /usr/bin/awk \'{print $2}\' | sed \'/^$/d\' > /etc/nova/virsh.secret'
      $cm-secure = '/usr/bin/virsh secret-define --file /etc/nova/secret-secure.xml | /usr/bin/awk \'{print $2}\' | sed \'/^$/d\' > /etc/nova/virsh.secret-secure'
           
      exec { 'get-or-set virsh secret':
              command => $cm,
              unless  => "/usr/bin/virsh secret-list | grep -i $compute_epoxy::params::libvirt_rbd_secret_uuid",
              require => File['secret.xml'],
            }
	    
      exec { 'get-or-set virsh secret secure':
              command => $cm-secure,
              unless  => "/usr/bin/virsh secret-list | grep -i $compute_epoxy::params::libvirt_rbd_secret_uuid_secure",
              require => File['secret-secure.xml'],
            }
	    

            
      exec { 'set-secret-value virsh':
          command => "/usr/bin/virsh secret-set-value --secret $compute_epoxy::params::libvirt_rbd_secret_uuid --base64 $compute_epoxy::params::libvirt_rbd_key",
        unless  => "/usr/bin/virsh secret-get-value $compute_epoxy::params::libvirt_rbd_secret_uuid | grep $compute_epoxy::params::libvirt_rbd_key",
        require => Exec['get-or-set virsh secret'],
           }
	   
      exec { 'set-secret-value virsh secure':
          command => "/usr/bin/virsh secret-set-value --secret $compute_epoxy::params::libvirt_rbd_secret_uuid_secure --base64 $compute_epoxy::params::libvirt_rbd_key_secure",
        unless  => "/usr/bin/virsh secret-get-value $compute_epoxy::params::libvirt_rbd_secret_uuid_secure | grep $compute_epoxy::params::libvirt_rbd_key_secure",
        require => Exec['get-or-set virsh secret secure'],
           }
              
}
