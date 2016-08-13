#!/usr/bin/perl

sub getbody {
  my ($article, $title) = @_;

  if ($article =~ /<div id="content">(.*)/mis) {
    $article = $1;
  }
  if ($article =~ /.*(<p class="noindent">)?<u>\Q$title\E<\/u>(<\/p>)?(.*)/mis) {
    $article = $3;
  }

  return $article;
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
my $article = <STDIN>;

my $parsed = parse($article);

print <<EOF;
<html>
<head>
  <title>$parsed->{'title'}</title>
  <link href="https://fonts.googleapis.com/css?family=Lobster|Raleway" rel="stylesheet">
  <link href="assets/transcriptions.css" rel="stylesheet">
  <meta name="generator" content="convertArticle.pl">
</head>
<body>
<h1>$parsed->{'title'}</h1>
$parsed->{'body'}
</body>
</html>
EOF
