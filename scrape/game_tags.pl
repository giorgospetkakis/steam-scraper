#!/usr/bin/perl

# Steam Game User-Defined Tag Scraper
# A script to gather user defined tags for all steam games
# and write them to a csv file
# Written by Giorgos Petkakis, 2017
use strict;
use warnings;

my $apps_path = "data/appids";
my $out_path = "data/tag-graph";
my $store_page;
my $output_str = "";
my $line_count = 0;
my $line_max = `cat $apps_path | wc -l`;

open(my $apps, '<:encoding(UTF-8)', $apps_path) or die "Could not open apps file";

# Read every line (get every appid)
while(my $line = <$apps>) {
    if($line_count < 1946 ) {
        $line_count = $line_count + 1;
        next;
    }
    chomp $line;
    # Get the store page for the app
    $store_page = `local/get-cached-url.sh $line`;

    while($store_page =~ m/\"tagid\"\:([0-9]*)\,\"name\"\:\"(.*?)\"\,\"count\"\:([0-9]*)/) {
        # Write to the output string in csv format appid,tag,votes
        $output_str .= "$line,$1,$3,$2\n";
        $store_page = $';
    }
    open(my $output, '>>:encoding(UTF-8)', $out_path) or die "Could not open output file";
    print $output $output_str;
    close $output;

    $output_str = "";
    $line_count = $line_count + 1;
    print "Processed $line_count of $line_max";
}