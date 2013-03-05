class php {
	require homebrew

	exec { 'brew tap josegonzalez/php':
		creates => "${homebrew::config::tapsdir}/josegonzalez-php", 
		before => Package['php53'],
	}

	package { 'php53':
		install_options => [
			'--with-fpm',
			'--with-gmp',
		],
	}
}