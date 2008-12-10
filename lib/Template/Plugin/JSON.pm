#!/usr/bin/perl

package Template::Plugin::JSON;
use Mouse;

use JSON ();

use Carp qw/croak/;

extends qw(Mouse::Object Template::Plugin);

our $VERSION = "0.03";


has context => (
	isa => "Object",
	is  => "ro",
);

has json_converter => (
	isa => "Object",
	is  => "ro",
	lazy_build => 1,
);

has json_args => (
	isa => "HashRef",
	is  => "ro",
	default => sub { {} },
);

sub BUILDARGS {
    my ( $class, $c, $args ) = @_;

	unless ( ref $args ) {
		warn "Single arguent form is deprecated, this module always uses JSON/JSON::XS now";
		$args = {};
	}

	return { %$args, context => $c, json_args => $args };
}

sub _build_json_converter {
	my $self = shift;

	my $json = JSON->new->allow_nonref(1);

	my $args = $self->json_args;

	for my $method (keys %$args) {
		if ( $json->can($method) ) {
			$json->$method( $args->{$method} );
		}
	}

	return $json;
}

sub json {
	my ( $self, $value ) = @_;

	$self->json_converter->encode($value);
}

sub BUILD {
	my $self = shift;
	$self->context->define_vmethod( $_ => json => sub { $self->json(@_) } ) for qw(hash list scalar);
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Template::Plugin::JSON - Adds a .json vmethod for all TT values.

=head1 SYNOPSIS

	[% USE JSON %];

	<script type="text/javascript">

		var foo = [% foo.json %];

	</script>

=head1 DESCRIPTION

This plugin provides a C<.json> vmethod to all value types when loaded.

With no argument it will try to load L<JSON::XS>, then L<JSON::Any>. Afterwords
it will try L<JSON::Syck> and then L<JSON::Converter> for upgrade
compatibility.  If used as C<[% USE JSON("Syck") %]> or
C<[% USE JSON("Converter") %]> it will load that specific plugin.

L<JSON::XS> is loaded before L<JSON::Any> due to specific options.

If no plugin could be loaded an exception is thrown. Check for errors from
L<Template/process>.

=head1 SEE ALSO

L<JSON::Syck>, L<JSON::Converter>, L<Template::Plugin::VMethods>


=head1 VERSION CONTROL

This module is maintained using Darcs. You can get the latest version from
L<http://nothingmuch.woobling.org/Template-Plugin-JSON/>, and use C<darcs send>
to commit changes.

=head1 AUTHOR

Yuval Kogman <nothingmuch@woobling.org>

=head1 COPYRIGHT & LICENSE

Copyright (c) 2006 Infinity Interactive, Yuval Kogman.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

=cut

