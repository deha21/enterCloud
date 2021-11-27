exec { "apt-update":
    command => "/usr/bin/apt-get update"
}


class nginx {
  package {'nginx':
    require => Exec['apt-update'],
    ensure => [installed ,running],
  }
}

class nodejs {
   exec { "node-ver":
    command => "/usr/bin/curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -"
}

  package {'nodejs':
    require => Exec[['apt-update'],['node-ver']],
    ensure => installed,
  }
}




class mysql {

  class { '::mysql::server':
    root_password    => 'DENIS123',
    override_options => { 'mysqld' => { 'max_connections' => '1024' } }
  }

}






node /web(.*)$/ {
  class {nginx:}
  #class {nodejs:}
  #class {mysql:}
  #class {puppet_extras:}
  #class {mysql:}
}



node /appserver(.*)$/ {

  class {nodejs:}
}
node /dbserver(.*)$/ {


   class {mysql:}
}
node /[tst0-50].home/ {

exec {"ETC-HOSTS":
command => "/usr/bin/sudo /bin/cat /vagrant/hosts /etc/hosts > /tmp/hosts; sudo mv -f  /tmp/hosts  /etc/hosts"
}


}
default
