#!/usr/bin/env perl
use strict;
use warnings;
use Weather::Storm;
use Data::Dump qw( dump );

my $thunderstorm = Weather::Storm->new( temperature => 30 );
my $cyclone = new Weather::Storm temperature => 70;

printf "\$thunderstorm: %s\n", $thunderstorm;
printf "\$cyclone:      %s\n", $cyclone;

dump $thunderstorm;
dump $cyclone;

printf "After the \$thunderstorm there will be %s.\n",
    $thunderstorm->forecast;
printf "After the \$cyclone there will be %s.\n", $cyclone->forecast();
printf "The \$thunderstorm temperature is %s.\n",
    $thunderstorm->get_temperature();
printf "The \$cyclone temperature is %s.\n", $cyclone->get_temperature;

# force $thunderstorm to be DESTROYed
$thunderstorm = undef;

$cyclone->set_temperature(50);

printf "Now the \$cyclone temperature is %s.\n", $cyclone->get_temperature;

$cyclone->precipitation('100');
printf "The cyclone caused %d inches of precipitation.\n",
    $cyclone->precipitation;
