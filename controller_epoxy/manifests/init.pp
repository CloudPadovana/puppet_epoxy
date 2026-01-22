class controller_epoxy ($cloud_role_foreman = "undefined") {

  $cloud_role = $cloud_role_foreman

  $ocatapackages = [ "crudini",

                   ]


     package { $ocatapackages: ensure => "installed" }

  # Install CA
  class {'controller_epoxy::install_ca_cert':}

  # Ceph
  class {'controller_epoxy::ceph':}
  
  # Configure keystone
  class {'controller_epoxy::configure_keystone':}
  
  # Configure glance
  class {'controller_epoxy::configure_glance':}

  # Configure nova
  class {'controller_epoxy::configure_nova':}

## FF for placement in xena
  # Configure placement
  class {'controller_epoxy::configure_placement':}
###

## FF in Caracalla non e' piu' supportato
#  # Configure ec2
#  class {'controller_epoxy::configure_ec2':}

  # Configure neutron
  class {'controller_epoxy::configure_neutron':}

  # Configure cinder
  class {'controller_epoxy::configure_cinder':}

  # Configure heat
  class {'controller_epoxy::configure_heat':}

  # Configure horizon
  class {'controller_epoxy::configure_horizon':}

  # Configure Shibboleth if AII and Shibboleth are enabled
  if ($::controller_epoxy::params::enable_aai_ext and $::controller_epoxy::params::enable_shib)  {
    class {'controller_epoxy::configure_shibboleth':}
  }

  # Configure OpenIdc if AII and openidc are enabled
  if ($::controller_epoxy::params::enable_aai_ext and ($::controller_epoxy::params::enable_oidc or $::controller_epoxy::params::enable_infncloud))  {
    class {'controller_epoxy::configure_openidc':}
  }

  # Configure Calendarpanel
  class {'controller_epoxy::configure_calendarpanel':}

 
  # Service
  class {'controller_epoxy::service':}

  
  # do passwdless access
  class {'controller_epoxy::pwl_access':}
  
  
  # configure remote syslog
  class {'controller_epoxy::rsyslog':}
  
  

       Class['controller_epoxy::install_ca_cert'] -> Class['controller_epoxy::configure_keystone']
       Class['controller_epoxy::configure_keystone'] -> Class['controller_epoxy::configure_glance']
       Class['controller_epoxy::configure_glance'] -> Class['controller_epoxy::configure_nova']
       Class['controller_epoxy::configure_nova'] -> Class['controller_epoxy::configure_placement']
       Class['controller_epoxy::configure_placement'] -> Class['controller_epoxy::configure_neutron']
       Class['controller_epoxy::configure_neutron'] -> Class['controller_epoxy::configure_cinder']
       Class['controller_epoxy::configure_cinder'] -> Class['controller_epoxy::configure_horizon']
       Class['controller_epoxy::configure_horizon'] -> Class['controller_epoxy::configure_heat']
       Class['controller_epoxy::configure_heat'] -> Class['controller_epoxy::configure_calendarpanel']


  }
