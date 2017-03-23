#!/usr/bin/env perl
use strict;
use warnings;
use Weather qw( sky_color );

my @new_weather = qw( storms calm winds );
my $n           = 4;
while ( $n-- ) {
    printf "$n: The color of the sky is %s.\n", sky_color();
    printf "$n: The forecast calls for %s.\n",  Weather->forecast();
    printf "%s\n",                              '-' x 40;
}

for (@new_weather) {
    Weather->add_weather($_);
}

$n = 4;
while ( $n-- ) {
    printf "$n: The color of the sky is %s.\n", sky_color();
    printf "$n: The forecast calls for %s.\n",  Weather->forecast();
    printf "%s\n",                              '-' x 40;
}
