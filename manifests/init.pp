class php {
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

	package { 'php53':
		require => Package['zlib'],
		install_options => [
			'--with-fpm',
			'--with-gmp',
		],
	}
}