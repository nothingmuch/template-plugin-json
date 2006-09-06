#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;

use ok 'Template::Plugin::JSON';

isa_ok( bless({}, "Template::Plugin::JSON"), "Template::Plugin::VMethods" );

SKIP: {
	skip "JSON::Syck is required for this", 2
		unless eval { require JSON::Syck; 1 };

	undef *Template::Plugin::JSON::json;

	Template::Plugin::JSON->_load_driver("Syck");

	ok(*Template::Plugin::JSON::json, "json sub defined");

	like( Template::Plugin::JSON::json({ foo => "bar" }), qr/foo.*:.*bar/, "json dumped" );
}

SKIP: {
	skip "JSON::Converter is required for this", 2
		unless eval { require JSON::Converter; 1 };

	undef *Template::Plugin::JSON::json;

	Template::Plugin::JSON->_load_driver("Converter");

	ok(*Template::Plugin::JSON::json, "json sub defined");

	like( Template::Plugin::JSON::json({ foo => "bar" }), qr/foo.*:.*bar/, "json dumped" );
}

