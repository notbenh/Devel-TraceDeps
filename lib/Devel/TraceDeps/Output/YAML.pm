package Devel::TraceDeps::Output::YAML;
use strict;
use warnings;
use YAML::Any;

sub output {
  my ($fh,%store) = @_;
  print Dump(\%store);
}

# vi:ts=2:sw=2:et:sta
1;
