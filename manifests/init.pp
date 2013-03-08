class php {

  pnx::homebrew::tap { 'homebrew/dupes': }
  package { 'zlib':
    require => Pnx::Homebrew::Tap['homebrew/dupes'],
  }

  pnx::homebrew::tap { 'josegonzalez/php': }

  package { 'php53':
    ensure => present,
    require => [
      Pnx::Homebrew::Tap['josegonzalez/php'],
      Package['zlib'],
    ],
    install_options => [
      '--with-fpm',
      '--with-gmp',
    ],
  }

  file { '/Library/LaunchDaemons/dev.php53.plist':
    content => template('php/dev.php53.plist.erb'),
    group   => 'wheel',
    notify  => Service['dev.php53'],
    owner   => 'root'
  }

  service { 'dev.php53':
    ensure  => running,
  }
}