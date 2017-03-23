#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dump qw( dump );

#
# reference examples
#

# anonymous scalar ref
my $scalar_ref = \'hello world';
print "\$scalar_ref : $$scalar_ref\n";
printf "%s\n", $scalar_ref;
printf "%s\n", dump($scalar_ref);
print "\n";

# named scalar ref
my $scalar      = 'hello world';
my $scalar_ref2 = \$scalar;
print "\$scalar_ref2 : $$scalar_ref2\n";
printf "%s\n", $scalar_ref2;
printf "%s\n", dump($scalar_ref2);
print "\n";

# anonymous array ref
my $array_ref = [ 'hello', 'world' ];
print "\$array_ref : " . join( ", ", @$array_ref ) . "\n";
print "the second element of \$array_ref is $array_ref->[1]\n";
printf "%s\n", $array_ref;
printf "%s\n", dump($array_ref);
print "\n";

# named array ref
my @array = ( 'hello', 'world' );
my $array_ref2 = \@array;
print "\$array_ref2 : " . join( ", ", @$array_ref2 ) . "\n";
print "the second element of \$array_ref2 is $array_ref2->[1]\n";
printf "%s\n", $array_ref2;
printf "%s\n", dump($array_ref2);
print "\n";

# anonymous hash ref
my $hash_ref = { 'color' => 'red', 'size' => 'large' };
print "the keys in \$hash_ref are : " . join( ", ", keys %$hash_ref ) . "\n";
print "the values in \$hash_ref are : "
    . join( ", ", values %$hash_ref ) . "\n";
print "the value of the \$hash_ref 'color' key : $hash_ref->{'color'}\n";
printf "%s\n", $hash_ref;
printf "%s\n", dump($hash_ref);
print "\n";

# named hash ref
my %hash = ( 'color' => 'red', 'size' => 'large' );
my $hash_ref2 = \%hash;
print "the keys in \$hash_ref2 are : "
    . join( ", ", keys %$hash_ref2 ) . "\n";
print "the values in \$hash_ref2 are : "
    . join( ", ", values %$hash_ref2 ) . "\n";
print "the value of the \$hash_ref2 'color' key : $hash_ref2->{'color'}\n";
# this next line is identical to the one above.
print "the value of the \$hash 'color' key : $hash{'color'}\n";
printf "%s\n", $hash_ref2;
printf "%s\n", dump($hash_ref2);
print "\n";

# anonymous code ref
my $code_ref = sub { print "I am anonymous code.\n" };
&$code_ref;       # dereference to execute
$code_ref->();    # same thing
printf "%s\n", dump($code_ref);
print "\n";

# named code ref
sub i_am_code { print "I am named code.\n" }
my $code_ref2 = \&i_am_code;
&$code_ref2;
$code_ref2->();
printf "%s\n", dump($code_ref2);

