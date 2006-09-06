#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

BEGIN {
	plan 'skip_all' => "at least one JSON lib has to be installed"
		unless eval { require JSON::Syck; 1 } || eval { require JSON::Converter };
	
	plan tests => 3;
}

use Template;

use ok 'Template::Plugin::JSON';

ok( Template->new->process(
	\"json: [% USE JSON; blah.json %]",
	{ blah => { foo => "bar" } },
	\(my $out),
), "template processing" ) || warn( Template->error );

like($out, qr/^json: \s*\{.*foo.*:.*bar.*\}/, "output seems OK" );
