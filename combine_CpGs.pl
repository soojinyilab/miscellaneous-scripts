#!/usr/bin/perl
use strict;
use warnings;


my $input = $ARGV[0];
my %hash;

open(INPUT, $input) or die $!;

my $s = $1 if ($input =~ m/(.*)?_S/);

my $out = $s."_combined_CpG.txt";

open(OUT,'>', $out);

while (my $line = <INPUT>) {

	my @line = split(/\t/, $line); chomp @line;

	my ($scaffold, $pos, $strand, $c_count, $t_count) = @line[0..4];

	if ($strand eq '+') {

		$hash{$scaffold}{$pos}{'c'} += $c_count;
		$hash{$scaffold}{$pos}{'t'} += $t_count;

	} elsif ($strand eq '-') {

		$pos = $pos - 1;

		$hash{$scaffold}{$pos}{'c'} += $c_count;
		$hash{$scaffold}{$pos}{'t'} += $t_count;
	}
}
close (INPUT);

foreach my $scaffold (keys %hash) {

	foreach my $pos (keys %{$hash{$scaffold}}) {

		my $c_count = $hash{$scaffold}{$pos}{'c'};
		my $t_count = $hash{$scaffold}{$pos}{'t'};

		print OUT "$scaffold\t$pos\t+\t$c_count\t$t_count\n";
	}
}

system("sort -Vk 1,2 -o $out $out");

