#!/usr/bin/perl

use strict;
use warnings;
use File::Find;
use Digest::MD5;

# Store all results
my @result = ();

# find_duplicated(@dir_list)
sub find_duplicated(@)
{
  my @dir_list = @_;
  if ($#dir_list < 0)
  {
    return (undef);
  }

  my @files;

  # Here is the list of files under the the @dir_list array
  # Polulate @files here.
  find(sub
      {
        push @files,$_ if (-f $_ and /\.txt$/);
      }, @dir_list);

  # My MD5 Hash
  my %md5;
  # Loop on what we find by md5
  foreach my $file (@files)
  {
    next if $file =~ /^\.\.?$/;
    open(FILE, $file) or next;
    binmode(FILE);
    push(@{ $md5 {Digest::MD5->new->addfile(*FILE)->hexdigest}}, $file);
    close(FILE);
  }

  foreach my $hash(keys %md5)
  {
  	if( $#{$md5{$hash}} >= 1 )
    {
      push(@result, [@{$md5{$hash}}]);
    }
  }
  return @result
}

my @duplicated_files = find_duplicated(@ARGV);

foreach my $cur_dump (@duplicated_files)
{
  print("Duplicated files:\n");
  foreach my $curl_file (@$cur_dump)
  {
    print ("\t$curl_file\n");
  }
}
