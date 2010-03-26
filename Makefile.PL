#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'Template::Plugin::JSON',
	'VERSION_FROM' => 'lib/Template/Plugin/JSON.pm',
	'PREREQ_PM' => {
		'Moose'         => '0',
		'Template'      => '2.20',
		'Test::More'    => '0',
		'Test::use::ok' => '0',
		'JSON'          => '2.12',
	},
    'INSTALLDIRS' => 'site',
    'EXE_FILES'   => [],
    'SIGN'        => 1,
    'PL_FILES'    => {}
);

unless ( eval { require JSON::XS } ) {
warn <<WARN
JSON::XS is reccomended, you should probably install it for better performance.
WARN
}
