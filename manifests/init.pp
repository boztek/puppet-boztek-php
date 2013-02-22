class php($sapi = "cgi") {
	require homebrew

	exec { 'brew tap josegonzalez/php':
		creates => "${homebrew::config::tapsdir}/josegonzalez-php", 
		before => Exec['php53-cgi'],
	}
	exec { 'brew tap homebrew/dupes':
		creates => "${homebrew::config::tapsdir}/homebrew-dupes",
		before => Package['zlib'],
	}
	package { 'zlib': }

	exec { 'php53-cgi':
		require => Package['zlib'],
		command => 'brew install php53 --with-cgi --with-gmp',
		creates => "${homebrew::config::installdir}/bin/php-cgi",
	}

	exec { 'php53-cgi-bin':
		require => Exec['php53-cgi'], 
		command => "cp ${homebrew::config::installdir}/bin/php-cgi ${boxen::config::home}/bin",
		creates => "${boxen::config::home}/bin/php-cgi",
	}

	exec { 'brew uninstall php53': }

	package { 'php53-fpm':
		name => 'php53',
		require => Package['zlib'],
		install_options => [
			'--with-fpm',
			'--with-gmp',
			'--with-tidy',
		],
	}

	include php::pear

	Exec['php53-cgi'] -> Exec['php53-cgi-bin'] -> Exec['brew uninstall php53'] -> Package['php53-fpm']
}

class php::pear {
}