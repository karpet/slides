#!/usr/bin/perl
#
# example KinoSearch indexer
#

use strict;
use warnings;
use KinoSearch::InvIndexer;
use KSSchema;
use IndexerUtils;
use Getopt::Long;

my $index   = 'ks_index';
my $verbose = 0;
GetOptions( 'index=s' => \$index, 'verbose' => \$verbose );

die "$0 --index <name> files_to_index\n" unless @ARGV;

my $invindexer
    = KinoSearch::InvIndexer->new( invindex => KSSchema->clobber($index) );

for my $file ( IndexerUtils::aggregate(@ARGV) ) {

    $invindexer->add_doc(
        {   content => IndexerUtils::normalize($file, $verbose) || '',
            uri => $file
        }
    );

}

$invindexer->finish;
