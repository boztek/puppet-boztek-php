class php($sapi = "cgi") {
	notice("Installing PHP")
	require homebrew

	exec { 'brew tap josegonzalez/php':
		creates => "${homebrew::config::tapsdir}/josegonzalez-php", 
		before => Package['php53'],
	}
	exec { 'brew tap homebrew/dupes':
		creates => "${homebrew::config::tapsdir}/homebrew-dupes",
		before => Package['zlib'],
	}

	package { 'zlib': }

	exec { 'php53-cgi-prepare':
		command => 'brew uninstall php53 --with-cgi',
		onlyif  => 'test -d /opt/boxen/homebrew/Cellar/php',
	}

	package { 'php53 --with-cgi':
		require => Package['zlib'],
		install_options => [
			'--with-gmp',
		],
	}

	exec { 'php53-cgi-bin':
		command => "cp ${homebrew::config::installdir}/Cellar/php53/5.3.21/bin/php-cgi ${boxen::config::home}/bin",
		creates => "${boxen::config::home}/bin/php-cgi",
		onlyif  => 'test -d ${homebrew::config::installdir}/Cellar/php53/5.3.21/bin/php-cgi',
	}

	exec { 'php53-cgi-cleanup':
		command => 'brew uninstall php53 --with-cgi',
	}

	package { 'php53':
		require => Package['zlib'],
		install_options => ['--with-fpm', '--with-gmp'],
	}

	Exec['php53-cgi-prepare'] -> Package['php53 --with-cgi'] -> Exec['php53-cgi-bin'] -> Exec['php53-cgi-cleanup'] -> Package['php53']
}