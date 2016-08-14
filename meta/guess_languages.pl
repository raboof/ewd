#!/usr/bin/perl

use strict;
use warnings;

use HTML::TableExtract;
use Lingua::Identify qw(:language_identification);

$/ = undef;

my @files = <../sources/www.cs.utexas.edu/~EWD/transcriptions/*/*.html>;
foreach my $file (@files) {
  open FILE, $file or die "Couldn't open file $file: $!";
  my $content = <FILE>;
  my $lang = langof($content);
  if ($lang && $file =~ /.*\/(.*)/) {
    print $1 . "\t" . $lang . "\n";
  }
}
