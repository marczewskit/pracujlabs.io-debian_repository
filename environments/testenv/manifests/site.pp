node 'server' {
  class { 'apt':
    update => {
      frequency => 'always',
    },
  }

  class { 'apt_repository::server':
  }

  exec { '/usr/bin/update-apt-repository':
    require            => Class['apt_repository::server'],
  }
}

node 'client' {
  class { 'apt':
    update => {
      frequency => 'always',
    },
  }

  class { 'apt_repository::client':
  }

  package {
    'pracuj-example':
      ensure  => latest,
      require => Class['apt_repository::client'],
  }
}