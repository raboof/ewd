#!/usr/bin/perl

use strict;

use Encode qw(decode encode);

use HTML::Tidy;
my $tidy = HTML::Tidy->new();

sub tidySnippet {
  my $snippet = shift;
  my $document = $tidy->clean($snippet);
  if ($document =~ /<body>(.*)<\/body>/mis) {
    return $1;
  }
  return $document;
}

sub getbody {
  my ($article, $title) = @_;

  if ($article =~ /<div id="content">(.*)/mis) {
    $article = $1;
  }
  if ($article =~ /.*(<p class="noindent">)?(<u>|<h1>)\Q$title\E\s*\.?(<\/u>|<\/h1>)\.?(<\/p>)?(.*)/mis) {
    $article = $5;
  }

  return tidySnippet($article);
}

sub parse {
  my $article = shift;
  my %result = {};

  $article =~ s/href="..\/..\//href="https:\/\/www.cs.utexas.edu\/~EWD\/$1/gi;

  if ($article =~ /<title>(E.W.\s*Dijkstra Archive:\s*)?(&ldquo;)?(.*?)\.?(&rdquo;)?(\s*\(EWD\s*\d+\w*\))?\s*<\/title>/mi) {
    $result{'title'} = $3;
    $article =~ s/<h1>\Q$result{'title'}\E<\/h1>//mi;
  }

  $result{'body'} = getbody($article, $result{'title'});

  return \%result;
}

sub convertArticle {
  my ($filename_in, $filename_out) = @_;
  open ARTICLE, "iconv -c --from UTF-8 --to UTF-8 \"$filename_in\"|";;
  binmode(ARTICLE, ":utf8");
  my $article = <ARTICLE>;

  my $parsed = parse($article);

  open OUT, ">$filename_out";
  binmode(OUT, ":utf8");
  print OUT <<EOF;
  <!DOCTYPE html>
  <html>
  <head>
    <title>$parsed->{'title'}</title>
    <link href="https://fonts.googleapis.com/css?family=Lobster|Raleway" rel="stylesheet">
    <link href="assets/common.css" rel="stylesheet">
    <link href="assets/transcriptions.css" rel="stylesheet">
    <link href="assets/tweet-selection.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-1.12.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="assets/tweet-selection.js"></script>
    <meta name="generator" content="convertArticle.pl">
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:site" content="\@raboofje" />
    <meta name="twitter:description" content="From the Edsger Dijkstra EWD archive: $parsed->{'title'}" />
    <meta name="twitter:title" content="$parsed->{'title'}" />
    <meta name="twitter:image" content="http://raboof.github.io/ewd/assets/dijkstra.jpeg" />
  </head>
  <body>
  <div class="metabar">
    <div class="metabar-inner">
      <a href="index.html">HOME</a>
    </div>
  </div>
  <h1>$parsed->{'title'}</h1>
  <div class='body'>$parsed->{'body'}</div>
  <script>
\$('.body').tweetSelection({
  ellipsis: '...',
  quoteLeft: '\\'',
  quoteRight: '\\'',
  via: 'raboofje'
});
  </script>
  </body>
  </html>
EOF
}

sub targetName {
  my $source = shift;
  if ($source =~ /EWD978/) {
    return "EWD978.html"
  }
  if ($source =~ /.*\/(.*)\.html?/) {
    my $file = $1;
    $file =~ s/ewd/EWD/;
    return $file . ".html";
  }
  die "Could not determine output filename for $source";
}

$/ = undef;

my @files = <sources/www.cs.utexas.edu/~EWD/transcriptions/EWD*/*.htm*>;
push(@files, 'sources/www.cs.utexas.edu/~EWD/transcriptions/EWD12xx/EWD 1202/EWD1202.html');
foreach my $file (@files) {
  convertArticle($file, 'target/' . targetName($file));
}
