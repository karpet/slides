#!/usr/bin/perl
#
# example KinoSearch searcher
#

use strict;
use warnings;
use KinoSearch::Searcher;
use KSSchema;
use Getopt::Long;

my $index = 'ks_index';
my $uri   = '';
GetOptions( 'index=s' => \$index, 'uri=s' => \$uri );

die "$0 --index <name> [query | --uri=URI]\n" unless ( @ARGV or $uri );

my $query = lc( join( ' ', @ARGV ) );
my $searcher
    = KinoSearch::Searcher->new( invindex => KSSchema->open($index) );
my $hits = $searcher->search( query => $query, );
my $hit_count = $hits->total_hits;

print "hits: $hit_count\n";
while ( my $hit = $hits->fetch_hit_hashref ) {
    my $score = sprintf( "%0.3f", $hit->{score} );
    print "$score $hit->{uri}\n";
}
