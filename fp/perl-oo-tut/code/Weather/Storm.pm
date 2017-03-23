package Weather::Storm;
use strict;
use warnings;
use base qw( Weather );
use Carp;

# example constructor
# "new" is a conventional, not a required, name.
sub new {
    my $class = shift;
    return bless( {@_}, $class );
}

sub get_temperature {
    my $self = shift;
    return $self->{temperature};
}

sub set_temperature {
    my $self = shift;
    my $temp = shift or croak "temperature required";
    $self->{temperature} = $temp;
}

sub precipitation {
    my $self = shift;
    if (@_) {
        $self->{precipitation} = shift;
    }
    return $self->{precipitation};
}

sub add_weather {
    my $self = shift;
    printf("Thanks for adding %s", join(', ', @_));
    $self->SUPER::add_weather(@_);
}

# example of the built-in destructor method
sub DESTROY {
    my $self = shift;
    printf "The storm %s has ended. The forecast is %s.\n", $self,
        $self->forecast;
}

1;

__END__

=head1 NAME

Weather::Storm - example subclass of Weather

=head1 SYNOPSIS

 use Weather::Storm;
 
 my $storm = Weather::Storm->new(
    temperature => 50
 );

 printf("Precipitation: %s\n", $storm->precipitation);
 $storm->set_temperature(80);
 printf("Temperature: %s\n", $storm->get_temperature);

=head1 DESCRIPTION

Example class of subclassing.

=head1 METHODS

=head2 new( I<params> )

Constructore. Returns a Weather::Storm object.

=head2 precipitation([ I<precip> ]);

Get/set the precipitation attribute value.

=head2 get_temperature

Returns the temperature attribute value.

=head2 set_temperature( I<temp> )

Set the temperature attribute value.

=head2 add_weather( I<weather> )

Add to the superclass weather data.

=head1 AUTHOR

Peter Karman peter@peknet.com

=head1 COPYRIGHT & LICENSE

Copyright 2010 Peter Karman.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

