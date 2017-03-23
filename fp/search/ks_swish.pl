#!/usr/bin/env perl
use strict;
use warnings;

package My::Indexer;
use base qw( SWISH::Prog::Indexer );
use KSx::Simple;
use Data::Dump qw( dump );
use File::Path qw( make_path );
use SWISH::3 qw(:constants);
use SWISH::Prog::Config;
use SWISH::Prog::Aggregator::FS;

my $config = { path_to_invindex => 'ks_invindex', };
make_path( $config->{path_to_invindex} );

my $simple = KSx::Simple->new(
    path     => $config->{path_to_invindex},
    language => 'en',
);

my $s3 = SWISH::3->new( handler => \&handler );
$s3->analyzer->set_tokenize(0);    # let KS do it

sub process {

    #warn "process! $_[1]";
    $s3->parse_buffer( $_[1]->as_string );

}

sub handler {
    my $data = shift;

    select(STDERR);

    #print '~' x 80, "\n";

    my %doc;

    #dump $data->config->get_properties->keys;

    #my $props = $data->properties;

    #print "Properties\n";
    #for my $p ( keys %$props ) {
    #    my $varray = $props->{$p};

    #printf( "    <%s>%s</%s>\n", $p, join( ' ', @$varray ), $p );
    #}

    #print "Doc\n";
    for my $d ( SWISH_DOC_FIELDS() ) {

        #printf( "%15s: %s\n", $d, $data->doc->$d );
        $doc{$d} = $data->doc->$d;
    }

    #    print "WordList\n";
    #    while ( my $swishword = $data->wordlist->next ) {
    #        print '-' x 50, "\n";
    #        for my $w ( SWISH_WORD_FIELDS() ) {
    #            printf( "%15s: %s\n", $w, $swishword->$w );
    #        }
    #    }

    my $metas = $data->metanames;

    #print "Metanames\n";
    for my $m ( keys %$metas ) {

        #my $toks = $metas->{$m};
        $doc{$m} = join( "\n", @{ $metas->{$m} } );

        #dump $toks;
        #print "    <$m>@$toks</$m>\n";
    }

    # TODO flesh this out with hashref of metaname content
    # and properties

    $simple->add_doc( \%doc );
}

package main;

# run the program

my $aggr = SWISH::Prog::Aggregator::FS->new(
    debug   => 1,
    verbose => 1,
    indexer => My::Indexer->new( config => SWISH::Prog::Config->new )
);

warn "crawling ...";
$aggr->crawl(@ARGV);
my $count = $aggr->count;
warn "crawl done. $count documents processed";

