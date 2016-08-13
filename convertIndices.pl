#!/usr/bin/perl

use HTML::TableExtract;

$/ = undef;

sub trim {
   return $_[0] =~ s/^[\p{FORMAT}\s]+|[\p{FORMAT}\s]+$//rg;
}

my @files = <sources/www.cs.utexas.edu/~EWD/index??xx.html>;

my @ewds = ();

foreach my $file (@files) { 
  open FILE, $file or die "Couldn't open file $file: $!";
  binmode(FILE, ":utf8");
  my $content = <FILE>;
  my $te = HTML::TableExtract->new(headers => ['EWD number', 'Title', 'transcriptions']);
  $te->parse($content);
  foreach $ts ($te->tables) {
    foreach $row ($ts->rows) {
      my %ewd = (
        'nr' => trim($$row[0]),
        'title' => trim($$row[1]),
        'file' => trim($$row[2])
      );
      push(@ewds, \%ewd);
    }
  }
}

open INDEX, ">target/index.html" or die "Could not open index";
binmode(INDEX, ":utf8");

print INDEX <<EOF;
<html>
<head>
  <meta charset="UTF-8">
  <link href="https://fonts.googleapis.com/css?family=Lobster|Raleway" rel="stylesheet">
  <link href="assets/index.css" rel="stylesheet">
</head>
<body>
<h1>Edsger W. Dijkstra</h1>
<ul>
EOF

foreach my $ewd (reverse @ewds) {
  print INDEX "<li class='ewd'><a href='$$ewd{'file'}'>$$ewd{'title'}</a></li>\n";
}

print INDEX <<EOF;
</ul>
</body>
EOF
