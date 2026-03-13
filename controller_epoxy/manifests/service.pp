class controller_epoxy::service inherits controller_epoxy::params {
  
 ## Services prova 

 service { "memcached":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_horizon'],
           }


file { "/etc/cron.d/fetch-crl":
    ensure   => file,
    owner    => "root",
    group    => "root",
    mode     => "0600",
    content  => file("controller_epoxy/fetch-crl.cron"),
  }



 # Services for keystone, placement       
    service { "httpd":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => [ Class['controller_epoxy::configure_keystone'], Class['controller_epoxy::configure_horizon'], Class['controller_epoxy::configure_placement'], ],
           }

 # Services for Shibboleth
    service { "shibd":
                   ensure     => stopped,
                   enable     => false,
                   hasstatus  => true,
                   hasrestart => true,
                   subscribe  => Class['controller_epoxy::configure_shibboleth'],
           }

 # Services for Glance
    service { "openstack-glance-api":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_glance'],
           }

 # Services for nova       
    service { "openstack-nova-api":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_nova'],
           }
    service { "openstack-nova-scheduler":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_nova'],
           }
    service { "openstack-nova-novncproxy":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_nova'],
           }
    service { "openstack-nova-conductor":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_nova'],
           }
 

 # Services for neutron       
    service { "openvswitch":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_neutron'],
           }
    service { "neutron-server":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_neutron'],
           }
    service { "neutron-openvswitch-agent":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_neutron'],
           }
    service { "neutron-dhcp-agent":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_neutron'],
           }
    service { "neutron-metadata-agent":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_neutron'],
           }
    service { "neutron-l3-agent":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_neutron'],
           }

 # Services for cinder
    service { "openstack-cinder-api":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_cinder'],
           }
    service { "openstack-cinder-scheduler":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_cinder'],
           }
    service { "openstack-cinder-volume":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_cinder'],
           }
           
 # Services for heat
    service { "openstack-heat-api":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_heat'],
           }
    service { "openstack-heat-api-cfn":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_heat'],
           }
    service { "openstack-heat-engine":
                   ensure      => stopped,
                   enable      => false,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_epoxy::configure_heat'],
           }
           
  }
