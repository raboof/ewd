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
  if ($article =~ /.*(<p class="noindent">)?<u>\Q$title\E\s*<\/u>\.?(<\/p>)?(.*)/mis) {
    $article = $3;
  }

  return tidySnippet($article);
}

sub parse {
  my $article = shift;
  my %result = {};

  $article =~ s/href="..\/..\//href="https:\/\/www.cs.utexas.edu\/~EWD\/$1/gi;

  if ($article =~ /<title>(E.W.\s*Dijkstra Archive: )?(&ldquo;)?(.*?)\.?(&rdquo;)?(\s*\(EWD\s*\d+\))?\s*<\/title>/mi) {
    $result{'title'} = $3;
    $article =~ s/<h1>\Q$result{'title'}\E<\/h1>//mi;
  }

  $result{'body'} = getbody($article, $result{'title'});

  return \%result;
}

sub convertArticle {
  my ($filename_in, $filename_out) = @_;
  open ARTICLE, $filename_in;
  binmode(ARTICLE, ":utf8");
  my $article = `iconv -c --from UTF-8 --to UTF-8 "$filename_in"`;

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
    <meta name="generator" content="convertArticle.pl">
  </head>
  <body>
  <div class="metabar">
    <div class="metabar-inner">
      <a href="index.html">HOME</a>
    </div>
  </div>
  <h1>$parsed->{'title'}</h1>
  <div class='body'>$parsed->{'body'}</div>
  </body>
  </html>
EOF
}

sub targetName {
  my $source = shift;
  if ($source =~ /EWD978/) {
    return "EWD978.html"
  }
  if ($source =~ /.*\/(.*)/) {
    return $1;
  }
  die "Could not determine output filename for $source";
}

$/ = undef;

my @files = <sources/www.cs.utexas.edu/~EWD/transcriptions/EWD*/*.htm*>;
push(@files, 'sources/www.cs.utexas.edu/~EWD/transcriptions/EWD12xx/EWD 1202/EWD1202.html');
foreach my $file (@files) {
  convertArticle($file, 'target/' . targetName($file));
}
