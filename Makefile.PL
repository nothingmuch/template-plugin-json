#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'Template::Plugin::JSON',
    'VERSION_FROM' => 'lib/Template/Plugin/JSON.pm',
    'PREREQ_PM'    => {
        'Template::Plugin::VMethods' => '0.03',
        'Test::More'                 => '0',
        'Test::use::ok'              => '0'
    },
    'INSTALLDIRS' => 'site',
    'EXE_FILES'   => [],
    'SIGN'        => 1,
    'PL_FILES'    => {}
);

unless ( eval { require JSON::Syck; 1 } or eval { require JSON::Converter; 1 } ) {
warn <<WARN
*** WARNING ***

No JSON module is installed.  You should install JSON::Syck
or JSON::Converter, or the plugin will die on load.
WARN
}
