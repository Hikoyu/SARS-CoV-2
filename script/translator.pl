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
	"TTY" => "F", "TTR" => "L",
	"TCY" => "S", "TCR" => "S", "TCM" => "S", "TCK" => "S", "TCS" => "S", "TCW" => "S", "TCH" => "S", "TCB" => "S", "TCV" => "S", "TCD" => "S", "TCN" => "S", "TC" => "S",
	"TAY" => "Y", "TAR" => "*",
	"TGY" => "C",
	"CTY" => "L", "CTR" => "L", "CTM" => "L", "CTK" => "L", "CTS" => "L", "CTW" => "L", "CTH" => "L", "CTB" => "L", "CTV" => "L", "CTD" => "L", "CTN" => "L",
	"CCY" => "P", "CCR" => "P", "CCM" => "P", "CCK" => "P", "CCS" => "P", "CCW" => "P", "CCH" => "P", "CCB" => "P", "CCV" => "P", "CCD" => "P", "CCN" => "P",
	"CAY" => "H", "CAR" => "Q",
	"CGY" => "R", "CGR" => "R", "CGM" => "R", "CGK" => "R", "CGS" => "R", "CGW" => "R", "CGH" => "R", "CGB" => "R", "CGV" => "R", "CGD" => "R", "CGN" => "R",
	"ATY" => "I",               "ATM" => "I",                             "ATW" => "I", "ATH" => "I",
	"ACY" => "T", "ACR" => "T", "ACM" => "T", "ACK" => "T", "ACS" => "T", "ACW" => "T", "ACH" => "T", "ACB" => "T", "ACV" => "T", "ACD" => "T", "ACN" => "T",
	"AAY" => "N", "AAR" => "K",
	"AGY" => "S", "AGR" => "R",
	"GTY" => "V", "GTR" => "V", "GTM" => "V", "GTK" => "V", "GTS" => "V", "GTW" => "V", "GTH" => "V", "GTB" => "V", "GTV" => "V", "GTD" => "V", "GTN" => "V",
	"GCY" => "A", "GCR" => "A", "GCM" => "A", "GCK" => "A", "GCS" => "A", "GCW" => "A", "GCH" => "A", "GCB" => "A", "GCV" => "A", "GCD" => "A", "GCN" => "A",
	"GAY" => "D", "GAR" => "E",
	"GGY" => "G", "GGR" => "G", "GGM" => "G", "GGK" => "G", "GGS" => "G", "GGW" => "G", "GGH" => "G", "GGB" => "G", "GGV" => "G", "GGD" => "G", "GGN" => "G",
	"YTA" => "L", "YTG" => "L", "YTR" => "L",
	"MGA" => "R", "MGG" => "R", "MGR" => "R",
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
