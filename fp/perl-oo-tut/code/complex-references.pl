#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dump qw( dump );

my $complex_ref = {
    'some_code' => sub { printf "%s\n", "I am anonymous." },
    'some_list' => [qw( foo bar )],
    'some_pairs'  => { color => 'blue', name => 'Joe' },
    'some_number' => \1234,
};

dump($complex_ref);

printf "The 2nd element in some_list: %s\n", $complex_ref->{some_list}->[1];

printf "The value of key 'color' is %s\n",
    $complex_ref->{some_pairs}->{color};

printf "The number is %d\n", ${ $complex_ref->{some_number} };

printf "The elements in the list are: %s\n",
    join( ", ", @{ $complex_ref->{some_list} } );

# execute the code
$complex_ref->{some_code}->();

# execute it a different way
&{ $complex_ref->{some_code} };

printf "The keys of the \$complex_ref are: %s\n",
    join( ", ", keys %$complex_ref );
