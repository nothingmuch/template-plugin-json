#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;

use Template;
use JSON;

use ok 'Template::Plugin::JSON';

ok( Template->new->process(
	\qq{[% USE JSON ( pretty => 1 ) %]{ "blah":[% blah.json %], "baz":[% baz.json %], "oink":[% oink.json %] }},
	my $vars = {
		blah => { foo => "bar" },
		baz  => "ze special string wis some ' qvotes\"",
		oink => [ 1..3 ],
	},
	\(my $out),
), "template processing" ) || warn( Template->error );

like($out, qr/\{\W*foo\W*:\W*bar\W*\}/, "output seems OK" );

like( $out, qr/\n/, "pretty output" );

is_deeply(
	from_json($out),
	$vars,
	"round tripping",
);
