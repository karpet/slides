#!/usr/bin/env perl
use strict;
use warnings;

{

    package Foo;
    our $public = 'i am a public variable in package ' . __PACKAGE__;
    my $private = 'i am a private variable in package ' . __PACKAGE__;
}

our $public = 'i am a public variable in package ' . __PACKAGE__;
my $private = 'i am a private variable in package ' . __PACKAGE__;

printf( "\$Foo::public   = %s\n", $Foo::public );
printf( "\$Foo::private  = %s\n", $Foo::private );
printf( "\$main::public  = %s\n", $main::public );
printf( "\$main::private = %s\n", $main::private );
printf( "\$public        = %s\n", $public );
printf( "\$private       = %s\n", $private );
