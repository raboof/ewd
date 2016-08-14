#!/usr/bin/perl

use strict;

use Encode qw(decode encode);

# TODO https://github.com/travis-ci/apt-package-whitelist/issues/3290
# use HTML::Tidy;
# my $tidy = HTML::Tidy->new();

sub tidySnippet {
  my $snippet = shift;
  return $snippet;
  # my $document = $tidy->clean($snippet);
  # if ($document =~ /<body>(.*)<\/body>/mis) {
  #   return $1;
  # }
  # return $document;
}

sub getbody {
  my ($article, $title) = @_;

  if ($article =~ /<div id="content">(.*)/mis) {
    $article = $1;
  }
  if ($article =~ /.*(<p class="noindent">)?<u>\Q$title\E<\/u>(<\/p>)?(.*)/mis) {
    $article = $3;
  }

  return tidySnippet($article);
}

sub parse {
  my $article = shift;
  my %result = {};

  $article =~ s/href="..\/..\//href="https:\/\/www.cs.utexas.edu\/~EWD\/$1/gi;

  if ($article =~ /<title>(E.W.\s*Dijkstra Archive: )?(.*?)( \(EWD\s*\d+\))?<\/title>/mi) {
    $result{'title'} = $2;
    $article =~ s/<h1>\Q$result{'title'}\E<\/h1>//mi;
  }

  $result{'body'} = getbody($article, $result{'title'});

  return \%result;
}

$/ = undef;
binmode(STDIN, ":utf8");
my $article = <STDIN>;

my $parsed = parse($article);

binmode(STDOUT, ":utf8");
print STDOUT <<EOF;
<!DOCTYPE html>
<html>
<head>
  <title>$parsed->{'title'}</title>
  <link href="https://fonts.googleapis.com/css?family=Lobster|Raleway" rel="stylesheet">
  <link href="assets/common.css" rel="stylesheet">
  <link href="assets/transcriptions.css" rel="stylesheet">
  <meta name="generator" content="convertArticle.pl">
</head>
<body>
<div class="metabar">
  <a href="index.html">HOME</a>
</div>
<h1>$parsed->{'title'}</h1>
<div class='body'>$parsed->{'body'}</div>
</body>
</html>
EOF
