package Weather;
use strict;
use warnings;
use base qw( Exporter );

our @EXPORT_OK = qw( sky_color );

my @colors_of_the_sky = qw( blue grey pink white );

sub sky_color {
    return _get_random_idx( \@colors_of_the_sky );
}

my @kinds_of_weather = qw( rain sunshine hail fog thunder );

sub forecast {
    return _get_random_idx( \@kinds_of_weather );
}

sub add_weather {
    my $self = shift;
    my $kind = shift or die "weather required";
    push @kinds_of_weather, $kind;
}

# private methods start with _
sub _get_random_idx {
    my $array = shift;
    return $array->[ rand( scalar @$array ) ];
}

1;    # MUST end with a true value.

__END__

=pod

=head1 NAME

Weather - example class showing functions and methods

=head1 SYNOPSIS

 use Weather qw( sky_color );
 
 printf("The sky color is %s.\n", sky_color());
 Weather->forecast();
 Weather->add_weather();
 
=head1 DESCRIPTION

Read the source. This is an example class.

=head1 METHODS

=head2 forecast()

=head2 add_weather( I<weather> )

=head1 FUNCTIONS

=head2 sky_color

Returns string. Importable, as in SYNOPSIS.

=head1 AUTHOR

Peter Karman peter@peknet.com

=head1 COPYRIGHT & LICENSE

Copyright 2010 Peter Karman.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
