#!/usr/bin/perl -w

use strict;

# perl round-robin-league-schedule.pl 5 Bye Andrew Omar Dan Brian Ian Sean Ramon David Ben Kevin
    
die "usage: $0 weeks bye-player player1 player2 ..." unless @ARGV >= 4;
    
my $weeks = shift @ARGV;
my $bye = shift @ARGV;
my @players = @ARGV;    

#@players = sort qw(A B C D E F G H I);

# add a bye if necessary
if ( @players % 2 == 1 ) {    
    push( @players, $bye );
}

# column orientated array of weeks
my $schedule = [ map { [  map { undef } ( 0 .. $#players ) ] } ( 1 .. $weeks ) ];

my $o = 0;

for my $p ( ( 0 .. $#players ) ) {
    my $player = $players[$p];
    for my $w ( ( 0 .. $weeks - 1 ) ) {
        my $week = $schedule->[$w];
        # if player not yet scheduled for this week
        if ( ! defined $week->[$p] ) {
            # loop over all the players for an opponent
            for ( ( 0 .. $#players ) ) {
                my $opponent = $players[$o];
                if ( $opponent ne $player && ! grep { defined $_ && $opponent eq $_ } @$week ) {
                    $week->[$p] = $opponent;
                    $week->[$o] = $player;
                    $o = ($o + 1) % @players;
                    goto FOUND_OPPONENT;
                }
                $o = ($o + 1) % @players;
            }
            $week->[$p] = $bye; # bye
        }
        FOUND_OPPONENT: 
    }
}

output( \@players, $schedule );

sub output {
    my ( $players, $schedule ) = @_;
    my $weeks = 1 + $#$schedule;
    my $width = 0;
    for ( @$players ) {
        $width = length($_) if length($_) > $width;
    }
    print "-" x 40, "\n";
    for my $p ( 0 .. $#players ) {
        printf( "|| %*s ||", -$width, $players[$p] );
        for my $w ( 0 .. $weeks - 1 ) {
            printf( " %*s |", -$width, $schedule->[$w]->[$p] || '-' );
        }
        print "\n";
    }
}

sub DUMP {
    use Data::Dumper;
    print Dumper(@_);    
}

# END
