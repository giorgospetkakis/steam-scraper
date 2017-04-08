#!/usr/bin/perl

# Steam Game Name Scraper
# A script to gather names based on their appid
# Written by Giorgos Petkakis, 2017

use strict;
use warnings;
use JSON;

my %games;
my $output_filename = $_[0];

getGameNames();
if (%games) {
    my ($game_info) = encode_json \%games;
    open(my $out, '>:encoding(UTF-8)', $output_filename) or die "Could not open file $output_filename";
    print $out $game_info;
    close $out;
}

sub getGameNames {
    my $api_response = `curl -s http://api.steampowered.com/ISteamApps/GetAppList/v2`;

    while ($api_response =~ m/appid\"\: ([0-9]*),\s*\"name\"\: \"(.*)\"/) {
        $games{$1} = $2;
        $api_response = $';
    }
}
