#!/usr/bin/perl

package Template::Plugin::JSON;
use base qw/Template::Plugin::VMethods/;

use Carp qw/croak/;

our $VERSION = "0.03";

our @SCALAR_OPS = our @LIST_OPS = our @HASH_OPS = ("json");

sub new {
    my ( $self, $c, $driver ) = @_;
    $self->_load_driver($driver);
    $self->SUPER::new($c);
}

sub _load_driver {
    my ( $self, $driver ) = @_;

    if ( $driver ) {
        $self->_load_specific_driver($driver);
    } else {
        $self->_load_any_driver;
    }
}

sub _load_specific_driver {
    my ( $self, $driver ) = @_;

	local $@;

   	foreach my $module ( "JSON::$driver", $driver ) {
		my $method = lc("_load_${module}_driver");
		$method =~ s/\W+/_/g;

		$self->can($method) || next;

		my $module_file = "${module}.pm";
		$module_file =~ s{::}{/}g;

		eval { require $module_file };
		return $self->$method;
	}

	croak "Unknown JSON driver: $driver";
}

sub _load_any_driver {
    my $self = shift;

	return if defined &json;

	local $@;
    if ( eval { require JSON::XS; 1 } ) {
        $self->_load_json_xs_driver;
	} elsif ( eval { require JSON::Any; 1 } ) {
		$self->_load_json_any_driver;
	} elsif ( eval { require JSON::Syck; 1 } ) {
		$self->_load_json_syck_driver;
	} elsif ( eval { require JSON::Converter; 1 } ) {
		$self->_load_json_converter_driver;
	} else {
		croak "Couldn't find a JSON driver, please install JSON::Any or JSON::XS";
	}
}

sub _load_json_xs_driver {
    my $self = shift;
	my $j = JSON::XS->new->utf8->allow_nonref;
    *json = sub { $j->encode(shift) }
}

sub _load_json_syck_driver {
    my $self = shift;
    *json = \&JSON::Syck::Dump;
}

sub _load_json_converter_driver {
    my $self = shift;

    my $conv   = JSON::Converter->new;
    *json = sub {
        my $data = shift;
        ref $data ? $conv->objToJson($data) : $conv->valueToJson($data);
    };
}

sub _load_json_any_driver {
    my $self = shift;
    JSON::Any->import();
    my $conv = JSON::Any->new(allow_nonref => 1);
    *json = sub {  
        $conv->encode($_[0]); 
    };
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

With no argument it will try to load L<JSON::Syck> and then L<JSON::Converter>.
If used as C<[% USE JSON("Syck") %]> or C<[% USE JSON("Converter") %]> it will
load that specific plugin.

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

