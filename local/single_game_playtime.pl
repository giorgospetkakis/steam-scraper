#!/usr/bin/perl -w

# Steam Game Game PLaytime Tool
# A script to get players' cumulative playtime for a single game from existing data
# Written by Giorgos Petkakis, 2017

# Edit: This code is terribly inefficient and I feel bad about it. It will be changed eventually.

my $filename = "data/ids_games";
my $output_filename = "data/gpp/";
my %output;

# Get all lines from the gametime files
open (my $IN, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename'";
    while (my $line = <$IN>) {
        chomp $line;
        # Get playtime for each argument
            foreach my $arg (@ARGV){
                my $game_time = getGameFreqPerPlayer($line, $arg);
                if($game_time) {
                    $output{$arg} .= $game_time . "\n";
                }
        }
    }
close $IN;

    foreach my $app (@ARGV) {
        if($output{$app}){
            open (my $OUT, '>:encoding(UTF-8)', $output_filename . $app) or die "Could not create file $app";
            print $OUT $output{$app};
            close $OUT;
        }
    }

sub getGameFreqPerPlayer {
    my $games_list = $_[0];
    my $appid = $_[1];

    while ($games_list =~ m/$appid\:([0-9]*)/) {
        return $1;
    }
}