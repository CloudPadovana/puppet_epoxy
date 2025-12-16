class compute_epoxy ($cloud_role_foreman = "undefined") { 

  $cloud_role = $cloud_role_foreman  

  # system check setting (network, selinux, CA files)
    class {'compute_epoxy::systemsetting':}

  # stop services 
    class {'compute_epoxy::stopservices':}

  # install
    class {'compute_epoxy::install':}

  # setup firewall
    class {'compute_epoxy::firewall':}

  # setup bacula
    class {'compute_epoxy::bacula':}
  
  # setup libvirt
    class {'compute_epoxy::libvirt':}

  # setup ceph
    class {'compute_epoxy::ceph':}

  # setup rsyslog
    class {'compute_epoxy::rsyslog':}

  # service
    class {'compute_epoxy::service':}

  # install and configure nova
     class {'compute_epoxy::nova':}

  # install and configure neutron
     class {'compute_epoxy::neutron':}

  # nagios settings
     class {'compute_epoxy::nagiossetting':}

  # do passwdless access
      class {'compute_epoxy::pwl_access':}

    # configure collectd
      class {'compute_epoxy::collectd':}


# execution order
             Class['compute_epoxy::firewall'] -> Class['compute_epoxy::systemsetting']
             Class['compute_epoxy::systemsetting'] -> Class['compute_epoxy::stopservices']
             Class['compute_epoxy::stopservices'] -> Class['compute_epoxy::install']
             Class['compute_epoxy::install'] -> Class['compute_epoxy::bacula']
             Class['compute_epoxy::bacula'] -> Class['compute_epoxy::nova']
             Class['compute_epoxy::nova'] -> Class['compute_epoxy::libvirt']
             Class['compute_epoxy::libvirt'] -> Class['compute_epoxy::neutron']
             Class['compute_epoxy::neutron'] -> Class['compute_epoxy::ceph']
             Class['compute_epoxy::ceph'] -> Class['compute_epoxy::nagiossetting']
             Class['compute_epoxy::nagiossetting'] -> Class['compute_epoxy::pwl_access']
             Class['compute_epoxy::pwl_access'] -> Class['compute_epoxy::collectd']
             Class['compute_epoxy::collectd'] -> Class['compute_epoxy::service']
################           
}
  
