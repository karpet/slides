#!/usr/bin/env perl
use strict;
use warnings;
use SWISH::3;
use KinoSearch::Searcher;
use KinoSearch::QueryParser;
use Data::Dump qw( dump );

my $analyzer = KinoSearch::Analysis::PolyAnalyzer->new(
    language => 'en',

);
my $searcher = KinoSearch::Searcher->new(
    index => 'ks_invindex',

);

my $qp = KinoSearch::QueryParser->new(
    fields   => [ SWISH::3::SWISH_DOC_FIELDS(), 'swishdefault' ],
    schema   => $searcher->get_schema,
    analyzer => $analyzer,

);
$qp->set_heed_colons(1);

for my $query_string (@ARGV) {
    my $query = $qp->parse($query_string);
    my $hits  = $searcher->hits(
        query      => $query,
        offset     => 0,
        num_wanted => 10,
    );

    printf "Total hits: %d\n", $hits->total_hits;

    while ( my $hit = $hits->next ) {
        printf( "%s %s '%s'\n",
            int( $hit->get_score * 1000 ),
            $hit->{uri}, $hit->{swishtitle}, );

        #print dump $hit->get_fields;
    }
}
