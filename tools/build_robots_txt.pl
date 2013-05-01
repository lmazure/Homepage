#!/usr/bin/perl -w

use strict;

my $basedir = $0;
$basedir =~ s{^(.*)\\[^\\]*\\[^\\]*$}{$1};
my $outfile = "$basedir/robots.txt";

sub scan_dir {
   my $file = shift;
   if ( -d "$basedir/$file" ) {
       opendir(DIR,"$basedir/$file");
       my @list = readdir(DIR);
       closedir(DIR);
       foreach( @list ) {
           scan_dir("$file/$_") if ( $_ ne "." && $_ ne ".." );
       }
   }
   elsif ( -f "$basedir/$file" ) {
       if ( ( $file =~ /\.xml$/ ) && ( $file ne "./gsitemap.xml" ) ) {
          $file =~ s/^\.//;
          print OUTFILE "Disallow: $file\n";
       }
   }
}

open(OUTFILE,">$outfile") or die("cannot open file $outfile");
print OUTFILE "User-Agent: *\n";
scan_dir(".");
print OUTFILE "Allow: /";
close(OUTFILE);

