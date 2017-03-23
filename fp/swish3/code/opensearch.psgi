# Copyright 2010 by Peter Karman. Licensed under the same terms as Perl.
#
# Demo of the Search::OpenSearch modules
# and Plack. To run this demo, you'll need to create
# at least one index (the default assumes KSx)
# using swish3 as part of the SWISH::Prog package.
# I used the reuters corpus from http://svn.peknet.com/search_bench/
# Then change the $index_* variables below to the path to your index(es).
# Once you've created the index, you can search it with this app.
# Enter:
#  % plackup opensearch.psgi
# and then point your browser at http://localhost:5000
#
#
use strict;
use warnings;
use Carp;
use Plack::Request;
use Plack::App::URLMap;
use Plack::App::File;
use Plack::Builder;
use Search::OpenSearch;
use Data::Dump qw( dump );

my $index_ks       = '/Users/karpet/projects/search_bench/fpks.index/';
my $index_swish    = '/Users/karpet/projects/search_bench/fpnative.index';
my $default_engine = 'KSx';
my %formats        = (
    'XML'  => 'application/xml',
    'JSON' => 'application/json',
);

my $ks_engine = Search::OpenSearch->engine(
    type   => 'KSx',
    index  => [$index_ks],
    facets => {
        names       => [qw( topics people places orgs author )],
        sample_size => 10_000,
    },
    fields => [qw( topics people places orgs author )],
);
my $swish_engine = Search::OpenSearch->engine(
    type   => 'SWISH',
    index  => [$index_swish],
    facets => {
        names       => [qw( topics people places orgs author )],
        sample_size => 10_000,
    },
    fields => [qw( topics people places orgs author )],
);

my $DEFAULT_PAGE = <<EOF;
<html>
 <!-- based on http://www.extjs.com/deploy/dev/examples/form/custom.html -->
 <head>
  <title>Demo Search::OpenSearch</title>
  
  <script type="text/javascript"
          src="http://extjs.cachefly.net/ext-3.1.0/adapter/ext/ext-base.js"></script>
  <script type="text/javascript"
          src="http://extjs.cachefly.net/ext-3.1.0/ext-all.js"></script>
  <script type="text/javascript" 
          src="static/ext-searchfield.js"></script>
  <script type="text/javascript"
          src="static/ext-search.js"></script>
  <link type="text/css" rel="stylesheet" 
        href="http://extjs.cachefly.net/ext-3.1.0/resources/css/ext-all.css" />         
  <link rel="stylesheet" type="text/css" 
        href="http://extjs.cachefly.net/ext-3.1.0/examples/form/combos.css" />
  <link rel="stylesheet" type="text/css" 
        href="http://extjs.cachefly.net/ext-3.1.0/examples/shared/examples.css" />
  <link rel="stylesheet" type="text/css" 
        href="static/ext-search.css" />

 </head>
 <body>
 <script type="text/javascript" src="http://extjs.cachefly.net/ext-3.1.0/examples/shared/examples.js"></script>
 <div style="width:700px;" id="search-panel"></div>
 </body>
</html>
EOF

my $app = sub {
    my $req   = Plack::Request->new(shift);
    my $query = $req->parameters->{q};
    my $res;
    if ( !defined $query ) {
        $res = $req->new_response(200);
        $res->content_type('text/html');
        $res->body($DEFAULT_PAGE);
    }
    else {
        my %args = ();
        for my $param (qw( q s o p h c L f format )) {
            $args{$param} = $req->parameters->{$param};
        }

        # map some Ext param names to Engine API
        if ( defined $req->parameters->{start} ) {
            $args{'o'} = $req->parameters->{start};
        }
        if ( defined $req->parameters->{limit} ) {
            $args{'p'} = $req->parameters->{limit};
        }

        $args{format} = uc( $args{format} || 'JSON' );
        if ( !exists $formats{ $args{format} } ) {
            warn "bad format $args{format} -- using JSON\n";
            $args{format} = 'JSON';
        }
        my $engine = $req->parameters->{'engine'} || $default_engine;
        my $response;
        if ( $engine eq 'KSx' ) {
            $response = $ks_engine->search(%args);
        }
        elsif ( $engine eq 'SWISH' ) {
            $response = $swish_engine->search(%args);
        }
        if ( !$response ) {
            $res = $req->new_response(400);
            $res->content_type('text/plain');
            $res->body("bad engine type: $engine");
        }
        else {

            # uncomment to get pretty JSON
            #$response->debug(1) if $args{format} eq 'JSON';

            $res = $req->new_response(200);
            $res->content_type( $formats{ $args{format} } );
            $res->body("$response");
        }
    }
    return $res->finalize;
};

builder {

    # necessary for Ext callback to work
    enable "JSONP";

    # serve our static content from same dir as this script
    mount "/static" => Plack::App::File->new( root => "./" );
    mount "/resources/images/default" =>
        Plack::App::File->new( root => "./" );

    # serve dynamic content using our $app
    mount '/' => $app;
};
