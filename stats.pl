#!/usr/bin/env perl

use autodie;

my $filename = @ARGV[0];
my $amount = 5;
open(my $file, '<', $filename);

my @revbank = split "\n", do { local $/ = <$file> };

sub parse_log {
    my($add, $regex, $amount, @log) = @_;
    my %statistics;
    foreach my $line (@log) {
        if($line =~ /$regex/) {
            if($add) {
                $statistics{$+{thing}} += $+{amount};
            } else {
                # Count
                $statistics{$+{thing}}++;
            }
        }
    }
    my $i = 0;
    foreach my $thing (sort { $statistics{$b} <=> $statistics{$a} } keys %statistics) {
        printf "%-40s %s\n", $thing, $statistics{$thing};
        $i++;
        last if $i>$amount;
    }
    print "\n";
}

sub product_stats {
    my($product) = @_;
    print "\e[31m--= $product =--\e[0m\n";
    my @log = grep { /$product/ } @revbank;
    my $regex = qr/     (?<thing>\w+)/;
    parse_log(0, $regex, $amount, @log);
}

sub total_deposits {
    print "\e[31m--= Total Deposits =--\e[0m\n";
    my @log = grep { /# Deposit/ } @revbank;
    my $regex = qr/     (?<thing>\w+) .+ EUR (?<amount>\d+.\d+)/;
    parse_log(1, $regex, $amount, @log);
}

sub best_selling {
    print "\e[31m--= Best Selling =--\e[0m\n";
    my @log = grep { /LOSE/ } @revbank;
    my $regex = qr/# (?<thing>.+)/;
    parse_log(0, $regex, $amount, @log);
}

total_deposits;
best_selling;
product_stats("RevBBQ");
product_stats("BringYourOwnBBQ");
product_stats("Club-Mate");
product_stats("Kookbonus");
