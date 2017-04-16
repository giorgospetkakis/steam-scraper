#!/usr/bin/perl

# Steam Game Analysis Tools
# A script to combine data from the Steam API
# Written by Giorgos Petkakis, 2017

use strict;
use warnings;

my $filename = @_[0];
my $names_ref_filename = @_[1];
my $delim = "\$\$";
my %gameFrequencies;
my %playerPerGame;

my $names_ref;


getGameFreq();

sub getGameFreq {    
    getNamesRef();
    open (my $IN, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename'";

# Read through every line
    while (my $line = <$IN>) {
        while($line =~ m/([0-9]*)\:([0-9]*)/) {
            $gameFrequencies{$1} += $2;
            $playerPerGame{$1} += 1;
            $line = $';
        }
    }
    close $IN;

    open (my $game_stats, '>>:encoding(UTF-8)', "$filename\_record") or die "Could not write to file.";
        foreach my $game (sort { $gameFrequencies{$b} <=> $gameFrequencies{$a} } keys %gameFrequencies) {
            if ($names_ref =~ m/\"$game\"\:\"(.*?)"/) {
                my $name = $1;
                print $game_stats "$name$delim$game$delim$playerPerGame{$game}$delim$gameFrequencies{$game}\n";
            }
    }
    close $game_stats;
}

sub getNamesRef {
    open (my $names, '<:encoding(UTF-8)', $names_ref_filename) or die "Could not open file '$names_ref'";

    {
        local $/;
        $names_ref = <$names>;
    }

    chomp $names_ref;
    $names_ref .= " \$";
    close $names;
}
