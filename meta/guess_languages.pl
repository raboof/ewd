#!/usr/bin/perl

use strict;
use warnings;

use HTML::TableExtract;
use Lingua::Identify qw(:language_identification);

$/ = undef;

my @files = <../sources/www.cs.utexas.edu/~EWD/transcriptions/*/*.htm*>;
push(@files, '../sources/www.cs.utexas.edu/~EWD/transcriptions/EWD12xx/EWD 1202/EWD1202.html');

foreach my $file (@files) {
  open FILE, $file or die "Couldn't open file $file: $!";
  my $content = <FILE>;
  my $lang = langof($content);
  if ($lang && $file =~ /.*\/(.*).htm*/) {
    my $file = $1;
    $file =~ s/ewd/EWD/;
    print $file . "\t" . $lang . "\n";
  }
}
