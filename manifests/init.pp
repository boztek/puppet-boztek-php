class php {
	include homebrew

	exec { 'brew tap josegonzalez/php':
		creates => "${homebrew::config::tapsdir}/josegonzalez-php", 
		before => Package['php53'],
	}
#	exec { 'brew tap homebrew/dupes':
#		creates => "${homebrew::config::tapsdir}/homebrew-dupes",
#	}
#	package { 'zlib':
#		require => Exec['brew tap homebrew/dupes'],
#	}

	package { 'php53':
		# require => Package['zlib'],
		install_options => [
			'--with-fpm',
			'--with-gmp',
		],
	}
}