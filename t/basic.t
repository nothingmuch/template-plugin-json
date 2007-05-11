#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;

use ok 'Template::Plugin::JSON';

isa_ok( bless({}, "Template::Plugin::JSON"), "Template::Plugin::VMethods" );

SKIP: {
	skip "JSON::XS is required for this", 2
		unless eval { require JSON::XS; 1 };

	undef *Template::Plugin::JSON::json;

	Template::Plugin::JSON->_load_driver("XS");

	ok(*Template::Plugin::JSON::json, "json sub defined");

	like( Template::Plugin::JSON::json({ foo => "bar" }), qr/foo.*:.*bar/, "json dumped" );
}

SKIP: {
	skip "JSON::Any is required for this", 2
		unless eval { require JSON::Any; 1 };

	undef *Template::Plugin::JSON::json;

	Template::Plugin::JSON->_load_driver("Any");

	ok(*Template::Plugin::JSON::json, "json sub defined");

	like( Template::Plugin::JSON::json({ foo => "bar" }), qr/foo.*:.*bar/, "json dumped" );
}

