#!/usr/bin/perl

$/ = undef;
my $article = <STDIN>;

$article =~ s/href="..\/..\//href="https:\/\/www.cs.utexas.edu\/~EWD\/$1/gi;
$article =~ s/..\/transcriptions.css/assets\/transcriptions.css/gi;

$article =~ s/meta name="generator" content="Adobe GoLive 6"/meta name="generator" content="convertArticle.pl"/gi;

if ($article =~ /<title>(E.W.\s*Dijkstra Archive: )?(.*?)( \(EWD\s*\d+\))?<\/title>/mi) {
  my $title = $2;
  # print STDERR $title;
  $article =~ s/(<body.*?>)/$1<div id="title"><h1>$title<\/h1><\/div>/gi;
}

$article =~ s/<head>/<head><link href="https:\/\/fonts.googleapis.com\/css\?family=Lobster|Raleway" rel="stylesheet">/gi;

if ($article !~ /transcriptions.css/) {
  $article =~ s/<head>/<head><link href="assets\/transcriptions.css" rel="stylesheet" media="screen">/gi;
}

print $article;
