#!/usr/bin/env perl

# Copyright (c) 2020 Hikoyu Suzuki
# This script is released under the MIT License.

use strict;
use warnings;

my %codon = (
	"TTT" => "F", "TTC" => "F", "TTA" => "L", "TTG" => "L",
	"TCT" => "S", "TCC" => "S", "TCA" => "S", "TCG" => "S",
	"TAT" => "Y", "TAC" => "Y", "TAA" => "*", "TAG" => "*",
	"TGT" => "C", "TGC" => "C", "TGA" => "*", "TGG" => "W",
	"CTT" => "L", "CTC" => "L", "CTA" => "L", "CTG" => "L",
	"CCT" => "P", "CCC" => "P", "CCA" => "P", "CCG" => "P",
	"CAT" => "H", "CAC" => "H", "CAA" => "Q", "CAG" => "Q",
	"CGT" => "R", "CGC" => "R", "CGA" => "R", "CGG" => "R",
	"ATT" => "I", "ATC" => "I", "ATA" => "I", "ATG" => "M",
	"ACT" => "T", "ACC" => "T", "ACA" => "T", "ACG" => "T",
	"AAT" => "N", "AAC" => "N", "AAA" => "K", "AAG" => "K",
	"AGT" => "S", "AGC" => "S", "AGA" => "R", "AGG" => "R",
	"GTT" => "V", "GTC" => "V", "GTA" => "V", "GTG" => "V",
	"GCT" => "A", "GCC" => "A", "GCA" => "A", "GCG" => "A",
	"GAT" => "D", "GAC" => "D", "GAA" => "E", "GAG" => "E",
	"GGT" => "G", "GGC" => "G", "GGA" => "G", "GGG" => "G",
	"---" => "-"
);

my $aa = undef;
my $seq = "";
my $pos = 0;
while (my $line = <>) {
	chomp($line);
	print defined($aa) ? "$aa\n$line\n" : "$line\n" and ($aa, $seq, $pos) = ("", "", 0) and next if $line =~ /^>/;
	$seq .= uc($line);
	for (;$pos < length($seq);$pos += 3) {$aa .= $codon{substr($seq, $pos, 3)};}
	$pos -= 3;
}
print $aa, "\n" if defined($aa);
exit;
