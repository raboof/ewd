#!/usr/bin/perl

use HTML::TableExtract;

sub trim {
   return $_[0] =~ s/^[\p{FORMAT}\s]+|[\p{FORMAT}\s]+$//rg;
}

my @files = <sources/www.cs.utexas.edu/~EWD/index??xx.html>;

my @ewds = ();

my %language = {};
open LANG, "meta/languages.tsv" or die;
while (<LANG> =~ /(.*)\t(.*)/g) {
  $language{$1} = $2;
}

$/ = undef;

foreach my $file (@files) {
  open FILE, $file or die "Couldn't open file $file: $!";
  binmode(FILE, ":utf8");
  my $content = <FILE>;
  my $te = HTML::TableExtract->new(headers => ['EWD number', 'Title', 'transcriptions']);
  $te->parse($content);
  foreach $ts ($te->tables) {
    foreach $row ($ts->rows) {
      my $file = trim($$row[2]);
      $file =~ s/(.*\.html).*/\1/mis;
      my $title = trim($$row[1]);
      $title =~ s/ \(English\)//;
      my %ewd = (
        'nr' => trim($$row[0]),
        'title' => $title,
        'file' => $file,
        'language' => $language{$file}
      );
      if ($ewd{'file'} !~ /^\s*$/) {
        push(@ewds, \%ewd);
      }
    }
  }
}

open INDEX, ">target/index.html" or die "Could not open index";
binmode(INDEX, ":utf8");

print INDEX <<EOF;
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link href="https://fonts.googleapis.com/css?family=Lobster|Raleway" rel="stylesheet">
  <link href="assets/common.css" rel="stylesheet">
  <link href="assets/index.css" rel="stylesheet">
  <script src="assets/index.js"></script>
</head>
<body>
<div class="metabar">
  <a id="nl" class="lang" href="#" onclick="disableLang('nl')">NL</a>
  <a id="nonl" class="inactive" href="#" onclick="enableLang('nl')">NL</a>
  <a id="en" class="lang" href="#" onclick="disableLang('en')">EN</a>
  <a id="noen" class="inactive" href="#" onclick="enableLang('en')">EN</a>
</div>
<h1>Edsger W. Dijkstra</h1>
<div class="body">
<ul>
EOF

foreach my $ewd (reverse @ewds) {
  print INDEX "<li class='ewd $$ewd{'language'}'><a href='$$ewd{'file'}'>$$ewd{'title'}</a></li>\n";
}

print INDEX <<EOF;
</ul>
</div>
</body>
EOF
