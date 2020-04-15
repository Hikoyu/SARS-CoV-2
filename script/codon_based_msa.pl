#!/usr/bin/env perl

# Copyright (c) 2020 Hikoyu Suzuki
# This script is released under the MIT License.

use strict;
use warnings;
use threads;
use IPC::Open2;
use FindBin;

my $output_dir = "famsa";
my $output_width = 60;

my $num_threads = shift(@ARGV);
my $analysis_prefix = shift(@ARGV);
my $genome_sequence_file = shift(@ARGV);
my $orf_annotation_file = shift(@ARGV);

$num_threads = 1 unless $num_threads;

my $seq_extract_cmd = "bedtools getfasta -s -fi $genome_sequence_file -bed - -fo -"; 
my $translate_cmd = "$FindBin::RealBin/translator.pl";
my $msa_cmd = "famsa -t $num_threads STDIN STDOUT";

open(BED, "<", $orf_annotation_file) or die "Failed to open file: $orf_annotation_file\n";
while (my $line = <>) {
	chomp($line);
	my $orf = [split(/\t/, $line)]->[3];
	print STDERR "\n### $orf ###\n";
	open2(*MSA_OUT, *MSA_IN, "$seq_extract_cmd | tee $output_dir/$analysis_prefix.$orf.fna | $translate_cmd | $msa_cmd") or die "Failed to extract sequences or execute multiple alignment: $orf\n";
	my $data_input_thread = async {
		threads->set_thread_exit_only(1);
		close(MSA_OUT);
		seek(BED, 0, 0);
		while (my $line = <BED>) {
			my @col = split(/\t/, $line);
			print MSA_IN $line if $col[3] =~ /:$orf$/;
		}
		close(MSA_IN);
		return(1);		
	};
	close(MSA_IN);
	my %gap_pos = ();
	my $pos = undef;
	my $seq_id = undef;
	my $seq_len = undef;
	while (my $line = <MSA_OUT>) {
		chomp($line);
		($pos, $seq_id) = (0, $line) and next if $line =~ /^>/;
		$seq_len = length($line);
		for (my $i = 0;$i < $seq_len;$i++) {
			$gap_pos{$seq_id} .= pack("L", $pos) and next if substr($line, $i, 1) eq "-";
			$pos += 3;
		}
	}
	close(MSA_OUT);
	my %seq = ();
	my @seq_id_list = ();
	open(FASTA_IN, "<", "$output_dir/$analysis_prefix.$orf.fna") or die "Failed to open file: $output_dir/$analysis_prefix.$orf.fna\n";
	while (my $line = <FASTA_IN>) {
		chomp($line);
		$seq_id = $line and push(@seq_id_list, $seq_id) and next if $line =~ /^>/;
		$seq{$seq_id} .= $line;
	}
	close(FASTA_IN);
	open(FASTA_OUT, ">", "$output_dir/$analysis_prefix.$orf.aln.fna") or die "Failed to make file: $output_dir/$analysis_prefix.$orf.aln.fna\n";
	foreach my $seq_id (@seq_id_list) {
		my $aligned_seq = "";
		my $current_pos = 0;
		foreach my $next_pos (unpack("L*", exists($gap_pos{$seq_id}) ? $gap_pos{$seq_id} : "")) {
			$aligned_seq .= substr($seq{$seq_id}, $current_pos, $next_pos - $current_pos) . "---";
			$current_pos = $next_pos;
		}
		$aligned_seq .= substr($seq{$seq_id}, $current_pos);
		print FASTA_OUT $seq_id, "\n", join("\n", ($aligned_seq =~ /.{1,$output_width}/g)), "\n";
	}
	close(FASTA_OUT);
	$data_input_thread->join or die "data input thread abnormally exited\n";
}
close(BED);
exit;
