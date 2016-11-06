#!/usr/bin/perl -w

use strict;

my $basedir = $0;
$basedir =~ s{^(.*)\\[^\\]*\\[^\\]*$}{$1};
my $outfile = "$basedir/gsitemap.xml";

sub handle_file {
    my $file = shift;
    return if ( /\.xml$/ );
    if ( /\.html$/ ) {
        my $source = $file;
        $source =~ s/.html$/.xml/;
        if ( ! -f "$basedir/$source" ) {
            print "$file is ignored\n";
            return;
	  }
        open(SOURCE,"$basedir/$source") or die("cannot open source file $basedir/$source ($!)");
        for (my $i=0; $i<4; $i++) {
            <SOURCE>;
        }
        my $line = <SOURCE>;
        if ( $line !~ m{<DATE><YEAR>(.*)</YEAR><MONTH>(.*)</MONTH><DAY>(.*)</DAY></DATE>} ) {
            $line = <SOURCE>;
        }
        close SOURCE;
        if ( $line !~ m{<DATE><YEAR>([12][0-9][0-9][0-9])</YEAR><MONTH>(1?[0-9])</MONTH><DAY>([1-3]?[0-9])</DAY></DATE>} ) {
            die("cannot find date in source file $source");
        }
        print OUTFILE "  <url>\n";
        print OUTFILE "    <loc>http://mazure.fr/$file</loc>\n";
        printf OUTFILE "    <lastmod>%04d-%02d-%02d</lastmod>\n", $1, $2, $3;
    } else {
        print OUTFILE "  <url>\n";
        print OUTFILE "    <loc>http://mazure.fr/$file</loc>\n";
    }
    my $dir = $file;
    $dir =~ s{/.*$}{};
    if ( $dir eq "perso") {
        print OUTFILE "    <changefreq>monthly</changefreq>\n";
    } elsif ( $dir eq "bouffe") {
        print OUTFILE "    <changefreq>monthly</changefreq>\n";
    } elsif ( $dir eq "tastes") {
        print OUTFILE "    <changefreq>monthly</changefreq>\n";
    } elsif ( $dir eq "quality") {
        print OUTFILE "    <changefreq>monthly</changefreq>\n";
    } elsif ( $dir eq "notes") {
        print OUTFILE "    <changefreq>weekly</changefreq>\n";
    } elsif ( $dir eq "links") {
        print OUTFILE "    <changefreq>weekly</changefreq>\n";
    } elsif ( $dir eq "content_tables") {
        print OUTFILE "    <changefreq>weekly</changefreq>\n";
    } elsif ( $dir eq "attic") {
        print OUTFILE "    <changefreq>never</changefreq>\n";
    } elsif ( $dir eq "hardcore") {
        print OUTFILE "    <changefreq>yearly</changefreq>\n";
    } elsif ( $dir eq "hack") {
        print OUTFILE "    <changefreq>yearly</changefreq>\n";
    } elsif ( $dir eq "index.htm") {
        print OUTFILE "    <changefreq>monthly</changefreq>\n";
    } elsif ( $dir eq "robots.txt") {
        print OUTFILE "    <changefreq>monthly</changefreq>\n";
    } elsif ( $dir eq "favicon.ico") {
        print OUTFILE "    <changefreq>yearly</changefreq>\n";
    } elsif ( $dir eq "icon.png") {
        print OUTFILE "    <changefreq>yearly</changefreq>\n";
    } else {
        die ("unknown directory: $dir");
    }
    print OUTFILE "  </url>\n";
} 

sub loop_on_files {
    my $dir = shift;
    opendir(DIR, "$basedir/$dir") or die("cannot open $dir");
    my @list = readdir(DIR);
    closedir(DIR);
    foreach ( @list ) {
        next if ( /^\./ || -d "$basedir/$dir/$_" );
        handle_file("$dir/$_");
    }
}

sub loop_on_dirs {
    my $dir = shift;
    opendir(DIR, $dir) or die("cannot open $dir");
    my @list = readdir(DIR);
    closedir(DIR);
    foreach ( @list ) {
        next if ( /^\./ || $_ eq "sources" || $_ eq "css" || $_ eq "tools" || $_ eq "images");
        if ( -d "$basedir/$_" ) {
            loop_on_files("$_");
        } else {
            handle_file("$_");
        }
    }
}

open(OUTFILE,">$outfile") or die("cannot open file $outfile");
print OUTFILE "<?xml version='1.0' encoding='UTF-8'?>\n";
print OUTFILE "<urlset xmlns='http://www.google.com/schemas/sitemap/0.84'>\n";
loop_on_dirs($basedir);
print OUTFILE "</urlset>\n";
close(OUTFILE);

