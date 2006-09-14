#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

BEGIN {
	plan 'skip_all' => "at least one JSON lib has to be installed"
		unless eval { require JSON::Syck; 1 } || eval { require JSON::Converter };
	
	plan tests => 4;
}

use Template;

use ok 'Template::Plugin::JSON';

ok( Template->new->process(
	\qq{[% USE JSON %]{ "blah":[% blah.json %], "baz":[% baz.json %], "oink":[% oink.json %] }},
	my $vars = {
		blah => { foo => "bar" },
		baz  => "ze special string wis some ' qvotes\"",
		oink => [ 1..3 ],
	},
	\(my $out),
), "template processing" ) || warn( Template->error );

like($out, qr/\{\W*foo\W*:\W*bar\W*\}/, "output seems OK" );

my $load = defined &JSON::Syck::Load
	? \&JSON::Syck::Load
	: do { require JSON; sub { JSON->new->jsonToObj(shift) } };

is_deeply(
	$load->($out),
	$vars,
	"round tripping",
);
