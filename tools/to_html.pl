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
if ( $hostname eq "DESKTOP-Q2NPTQ8" ) { $lib_dir = "H:/Documents/tools/lib"; }
die("don't know where are the Java libraries") if ( ! defined($lib_dir) );

print "$0\n";
my $base_dir = $0;
$base_dir =~ s{^(.*)\\[^\\]*\\[^\\]*$}{$1};
my $xalan_dir = $lib_dir."/xalan-j_2_7_1";
my $start_dir = "..";
#my $start_dir = $base_dir;
my $xlst_file = $start_dir."/css/strict.xsl";
my $map_file = $start_dir."/hack/map.xml";

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
       ( stat($xlst_file)->mtime >= stat($outfile)->mtime ) ||
       ( stat($map_file)->mtime >= stat($outfile)->mtime ) ) {
    #my @cmds = ("/cygdrive/c/java/prg/jdk18_64/bin/java.exe",
    my @cmds = ("java.exe",
        "-cp",
        "$xalan_dir/xalan.jar",
        "org.apache.xalan.xslt.Process",
        "-IN",
        "$infile",
        "-XSL",
        "$xlst_file",
        "-OUT",
        "$outfile");
    if (system(@cmds)) {
        unlink $outfile;
        die("run Java ($!)");
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
