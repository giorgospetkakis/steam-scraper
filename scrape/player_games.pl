#!/usr/bin/perl

# Steam Player Information Scraper
# A script to gather player data using the Steam API
# Written by Giorgos Petkakis, 2017

use strict;
use warnings;
use JSON;
use Data::Dumper;

my $filename = $_[0];

# Open ids file
open (my $IN, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename'";

# Read through every line
while (my $line = <$IN>) {
    # my $column_count = 1;
    chomp $line;
    my $apps = {
        id => $line
    };

# Get the apps from the API
    getUserApps($line, $apps);

# Write to file
    if ($apps) {
        my ($app_info) = encode_json $apps;
        `echo $app_info >> $filename\_games`;
    }
}
close $OUT;

# Query API for player games
sub getUserApps {
    my $api_response = `curl -s "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key="KEY"\&steamid=$_[0]\&format=json&include_played_free_games"`;
    
    # Get appid in $1 and playtime in $2
    while ($api_response =~ m/\"appid\": ([0-9]+),\s*\"playtime_forever\": ([0-9]+)/) {
        $_[1]{$1} = $2;
        $api_response = $';
    }
    return $_[1];
}
