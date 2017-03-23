# Copyright 2010 by Peter Karman. Licensed under the same terms as Perl.
#
# similar to opensearch.psgi but using
# Search::OpenSearch::Server::Plack for much less code.
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
use Search::OpenSearch::Server::Plack;
use Data::Dump qw( dump );

# should only need to change this path
my $index_ks = '/Users/karpet/projects/search_bench/fpks.index/';

# nothing else
my $engine_config = {
    type   => 'KSx',
    index  => [$index_ks],
    facets => {
        names       => [qw( topics people places orgs author )],
        sample_size => 10_000,
    },
    fields => [qw( topics people places orgs author )],
    debug  => $ENV{PERL_DEBUG} || 0,
};

my $DEFAULT_PAGE = <<EOF;
<html>
 <!-- based on http://www.extjs.com/deploy/dev/examples/form/custom.html -->
 <head>
  <title>Demo Search::OpenSearch</title>
  
  <script type="text/javascript"
          src="http://extjs.cachefly.net/ext-3.2.0/adapter/ext/ext-base.js"></script>
  <script type="text/javascript"
          src="http://extjs.cachefly.net/ext-3.2.0/ext-all.js"></script>
  <script type="text/javascript" 
          src="static/ext-searchfield.js"></script>
  <script type="text/javascript"
          src="static/ext-livegrid.js"></script>
  <script type="text/javascript"
          src="http://localhost/~karpet/livegrid/build/livegrid-all.js"></script>
  <link type="text/css" rel="stylesheet" 
        href="http://extjs.cachefly.net/ext-3.2.0/resources/css/ext-all.css" />         
  <link rel="stylesheet" type="text/css" 
        href="http://extjs.cachefly.net/ext-3.2.0/examples/form/combos.css" />
  <link rel="stylesheet" type="text/css" 
        href="http://extjs.cachefly.net/ext-3.2.0/examples/shared/examples.css" />
  <link rel="stylesheet" type="text/css" href="static/ext-search.css" />
  <link rel="stylesheet" type="text/css" href="http://localhost/~karpet/livegrid/build/resources/css/ext-ux-livegrid.css" />
 </head>
 <body>
 <script type="text/javascript" src="http://extjs.cachefly.net/ext-3.2.0/examples/shared/examples.js"></script>
 <div style="width:700px;" id="search-panel"></div>
 </body>
</html>
EOF

{

    package MyServer;
    @MyServer::ISA = ('Search::OpenSearch::Server::Plack');

    sub handle_no_query {
        my ( $self, $response ) = @_;
        $response->status(200);
        $response->content_type('text/html');
        $response->body($DEFAULT_PAGE);
        return $response;
    }
}

my $app = MyServer->new( engine_config => $engine_config );

builder {

    # necessary for Ext callback to work
    enable "JSONP";

    # serve our static content from same dir as this script
    mount "/static" => Plack::App::File->new( root => "./" );
    mount "/resources/images/default" =>
        Plack::App::File->new( root => "./" );

    # serve dynamic content using MyServer
    mount '/' => $app;
};
