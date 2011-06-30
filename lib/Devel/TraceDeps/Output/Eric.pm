package Devel::TraceDeps::Output::Eric;
use strict;
use warnings;

sub output {
  my ($fh,%store) = @_;
  foreach my $key (keys(%store)) {
    print $fh $key, "\n";
    foreach my $item (@{$store{$key}}) {
      print $fh join("\n", '  -----',
        map({"  $_: $item->{$_}"} keys %$item)), "\n";
    }
  }
}

# vi:ts=2:sw=2:et:sta
1;
