package Devel::TraceDeps::Output::YAMLTree;
use strict;
use warnings;
use YAML::Any;
use Memoize;

my %store = ();
sub path2pkg { $_ = shift; m/\.pm/ ? join '::', grep{length} split /\W/, [m/(.*)\.pm/]->[0] : $_ };

use Data::Dumper;

memoize('upk');
sub upk { 
  my $key = shift;
  my $seen= ref($_[0]) eq 'HASH' ? shift : {$key => 0};
  my $pkg = path2pkg($key);
  return $key unless $store{$pkg};
  my $out = {};
  foreach my $item (@{$store{$pkg}}) {
    next unless $item->{req};
    push @{ $out->{$key}->{$item->{file}} }
       , { #map{ $_=> $item->{$_} } qw{line req}
           line => $item->{line},
           req  => [ $seen->{$item->{req}} # cicurlar dep
                     ? $item->{req}
                     : do{ $seen->{$item->{req}} = scalar(keys %$seen);
                           upk($item->{req}, $seen, $item->{req})
                         }
                   ]
         };
  }
  return $out;
}; 
  

sub output {
  my $fh = shift;
  %store = @_;

  
  print Dump(upk('main'));
}

# vi:ts=2:sw=2:et:sta
1;

__END__

main:                                                                                                                                                         
- file: /tmp/Dep_test/go.pl
  line: 2
  req: strict.pm
  trace: '1'
- file: /tmp/Dep_test/go.pl
  line: 3
  req: warnings.pm
  trace: '2'
- file: /tmp/Dep_test/go.pl
  line: 4
  req: This/Thing.pm
  trace: '3
