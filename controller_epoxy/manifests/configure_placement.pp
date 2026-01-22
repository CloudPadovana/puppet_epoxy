class controller_epoxy::configure_placement inherits controller_epoxy::params {

#
# Questa classe:
# - popola il file /etc/placement/placement.conf
# 
###################  
define do_config ($conf_file, $section, $param, $value) {
             exec { "${name}":
                              command     => "/usr/bin/crudini --set ${conf_file} ${section} ${param} \"${value}\"",
                              require     => Package['crudini'],
                              unless      => "/usr/bin/crudini --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"^${value}$\" 2>&1 >/dev/null",
                  }
       }

define remove_config ($conf_file, $section, $param, $value) {
             exec { "${name}":
                              command     => "/usr/bin/crudini --del ${conf_file} ${section} ${param}",
                              require     => Package['crudini'],
                              onlyif      => "/usr/bin/crudini --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"^${value}$\" 2>&1 >/dev/null",
                   }
       }


# placement.conf
   controller_epoxy::configure_placement::do_config { 'placement_db': conf_file => '/etc/placement/placement.conf', section => 'placement_database', param => 'connection', value => $controller_epoxy::params::placement_db, }

   controller_epoxy::configure_placement::do_config { 'placement_auth_strategy': conf_file => '/etc/placement/placement.conf', section => 'api', param => 'auth_strategy', value => $controller_epoxy::params::auth_strategy, }

   controller_epoxy::configure_placement::do_config { 'placement_auth_url': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'auth_url', value => $controller_epoxy::params::placement_auth_url, }  
   controller_epoxy::configure_placement::do_config { 'placement_memcached_servers': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'memcached_servers', value => $controller_epoxy::params::memcached_servers, }
   controller_epoxy::configure_placement::do_config { 'placement_auth_plugin': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'auth_type', value => $controller_epoxy::params::auth_type, }
   controller_epoxy::configure_placement::do_config { 'placement_project_domain_name': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'project_domain_name', value => $controller_epoxy::params::project_domain_name, }
   controller_epoxy::configure_placement::do_config { 'placement_user_domain_name': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'user_domain_name', value => $controller_epoxy::params::user_domain_name, }
   controller_epoxy::configure_placement::do_config { 'placement_project_name': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'project_name', value => $controller_epoxy::params::project_name, }
   controller_epoxy::configure_placement::do_config { 'placement_username': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'username', value => $controller_epoxy::params::placement_username, }
   controller_epoxy::configure_placement::do_config { 'placement_password': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'password', value => $controller_epoxy::params::placement_password, }
   controller_epoxy::configure_placement::do_config { 'placement_www_authenticate_uri': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'www_authenticate_uri', value => $controller_epoxy::params::www_authenticate_uri, }
   controller_epoxy::configure_placement::do_config { 'placement_cafile': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'cafile', value => $controller_epoxy::params::cafile, }

 # MS In xena da` un warning se questo non e` a true
 # Ma almeno per alcuni servizi da` problemi se e` a true
#   controller_epoxy::configure_placement::do_config { 'placement_service_token_roles_required': conf_file => '/etc/placement/placement.conf', section => 'keystone_authtoken', param => 'service_token_roles_required', value => $controller_epoxy::params::placement_service_token_roles_required, }


#
# Non dovrebbbe esserci bisogno di un policy file custom
######placement_policy is copied from /controller_epoxy/files dir       
#file {'placement_policy.json':
#           source      => 'puppet:///modules/controller_epoxy/placement_policy.json',
#           path        => '/etc/placement/policy.json',
#           backup      => true,
#           owner   => root,
#           group   => placement,
#           mode    => "0640",
#
#         }
      
##
## MS. Il file che viene dall'rpm NON va bene. Questa cosa serve ancora
## FF
file {'00-placement-api.conf':
           source      => 'puppet:///modules/controller_epoxy/00-placement-api.conf',
           path        => '/etc/httpd/conf.d/00-placement-api.conf',
           ensure      => present,
           backup      => true,
           mode        => "0640",
         }


}
