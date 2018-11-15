#!/bin/perl -w

use strict;
use warnings;
use diagnostics;
use File::stat;
use Sys::Hostname;

# get the directory name
my $hostname = hostname;
my $lib_dir;
if ( $hostname eq "Kirikou" ) { $lib_dir = "C:/Users/Laurent/Documents/lib"; }
if ( $hostname eq "bianca" ) { $lib_dir = "C:/Documents and Settings/Laurent/Mes documents/lib"; }
if ( $hostname eq "samsung" ) { $lib_dir = "C:/Documents and Settings/Laurent/Mes documents/lib"; }
if ( $hostname eq "INFOLOGIC-LMA" ) { $lib_dir = "H:/Documents/tools/lib"; }
if ( $hostname eq "gilgamesh" ) { $lib_dir = "H:/Documents/tools/lib"; }
die("don't know where are the Java libraries") if ( ! defined($lib_dir) );

print "$0\n";
my $base_dir = $0;
$base_dir =~ s{^(.*)\\[^\\]*\\[^\\]*$}{$1};
my $saxon_dir = $lib_dir."/SaxonHE9-8-0-12J";
my $start_dir = "..";
#my $start_dir = $base_dir;
my $xlst_file = $start_dir."/css/strict.xsl";
my $java_path = "/cygdrive/h/Documents/tools/jre/jre-9/bin/java.exe";

if ( ! -f $java_path ) {
        die("Java ($java_path) does not exist");
}

sub to_html {
  my $infile = shift;
  open(SOURCE,"$infile") or die("cannot open source file $infile");
  <SOURCE>;
  my $flag = <SOURCE> =~ m{<\?xml-stylesheet type="text/xsl" href="\.\./css/strict.xsl"\?>};
  close SOURCE;
  if ( ! $flag ) {
      return;
  }
  my $outfile = $infile;
  $outfile =~ s/\.xml$/\.html/;
  if ( ( ! -f $outfile ) ||
       ( stat($infile)->mtime >= stat($outfile)->mtime ) ||
       ( stat($xlst_file)->mtime >= stat($outfile)->mtime ) ) {
    my @cmds = ("$java_path",
    #my @cmds = ("java.exe",
        "-jar",
        "$saxon_dir/saxon9he.jar",
        "-s:$infile",
        "-xsl:$xlst_file",
        "-o:$outfile");
    if (system(@cmds)) {
        unlink $outfile;
        die("run Java (@cmds) failed ($!)");
    }
    if (-z $outfile) {
        unlink $outfile;
        die("$outfile is empty");
    }
    print "$outfile\n";
  }
}

sub scan_dir {
  my $file = shift;
  if ( -d $file ) {
    opendir(DIR,$file);
    my @list = readdir(DIR);
    closedir(DIR);
    foreach( @list ) {
      scan_dir("$file/$_") if ( $_ ne "." && $_ ne ".." );
    }
  }
  elsif ( -f $file ) {
    if ( $file =~ /\.xml$/ ) {
      to_html($file);
    }
  } else {
    print "Cannot handle $file\n";
  }
}

scan_dir($start_dir);
