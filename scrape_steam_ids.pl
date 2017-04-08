#!/usr/bin/perl

# Steam UID Scraper.
# A script to gather Steam IDs using the Steam API
# Written by Giorgos Petkakis, 2017

use strict;
use warnings;

$main::filename = "ids.txt";

# Start with most recent UID entry
my @queue = (`tail -n 1 "$main::filename"`);
`echo "\n\r" >> $main::filename`;

# Branching queue loop start
while(@queue) {
    # Get next queue item
    my $next_item = shift @queue;
    getUserIDs($next_item);
}

# Get Friend List UIDS
sub getUserIDs {
    my @api_response = split(/\n/, `curl -s "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=3D31F24513C0F5242FE5B3917816A745\&steamid=$_[0]" | grep -Eoh "[0-9]{17}"`);

    # Add all UIDS to the queue
    foreach my $UID (@api_response) {
        if (not `grep "$UID" $main::filename`) {
            # Make sure they have reviews
            # if(`curl -s steamcommunity.com/profiles/$UID/recommended | cat | wc -m` > 50) {
                `echo "$UID" >> $main::filename`;
            # }
            push @queue, $UID;
        }
    }
}
