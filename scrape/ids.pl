#!/usr/bin/perl

# Steam UID Scraper.
# A script to gather Steam IDs using the Steam API
# Written by Giorgos Petkakis, 2017

use strict;
use warnings;

$main::filename = $_[0];

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
    my @api_response = split(/\n/, `curl -s "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key="KEY"\&steamid=$_[0]" | grep -Eoh "[0-9]{17}"`);

    # Add all UIDS to the queue
    foreach my $UID (@api_response) {
        # Check is UID is unique to the set (surpisingly fast with large amounts of data)
        if (not `grep "$UID" $main::filename`) {
            # Make sure they have reviews
                `echo "$UID" >> $main::filename`;
            push @queue, $UID;
        }
    }
}
