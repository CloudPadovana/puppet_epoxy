class compute_epoxy::rsyslog inherits compute_epoxy::params {

#include compute_epoxy::params

  $rsyslogpackages = [ "rsyslog" ]
  
  package { $rsyslogpackages: ensure => "installed" }
  
    
      service { "rsyslog":
        ensure => running,
        enable => true,
        hasstatus => true,
        hasrestart => true,
        require => Package["rsyslog"],
      }

      file {'rsyslog_conf':
          source      => 'puppet:///modules/compute_epoxy/rsyslog.conf',
          path        => '/etc/rsyslog.conf',
          backup      => true,
          owner   => root,
          group   => root,
          mode    => "0644",
          notify => Service['rsyslog'],
      }

      file {'ignore_nagios':
          source      => 'puppet:///modules/compute_epoxy/ignore-systemd-session-slice-nagios.conf',
          path        => '/etc/rsyslog.d/ignore-systemd-session-slice-nagios.conf',
          backup      => true,
          owner   => root,
          group   => root,
          mode    => "0644",
          notify => Service['rsyslog'],
      }
             
}
