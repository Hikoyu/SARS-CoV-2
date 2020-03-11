#!/usr/bin/env perl

# Copyright (c) 2020 Hikoyu Suzuki
# This script is released under the MIT License.

use strict;
use warnings;
use threads;
use Thread::Queue;

my $cmd = "dialign-tx";
my $opt = "-T conf";
my $dir = "dialign";

my $num_threads = shift(@ARGV);
my $analysis_prefix = shift(@ARGV);
my $genome_sequence_file = shift(@ARGV);
my $orf_annotation_file = shift(@ARGV);

$num_threads = 1 unless $num_threads;

my @threads = ();
my $input = Thread::Queue->new;
my $output = Thread::Queue->new;

for (my $thread_id = 0;$thread_id < $num_threads;$thread_id++) {
	$threads[$thread_id] = async {
		threads->set_thread_exit_only(1);
		open(BED, "<", $orf_annotation_file) or die "Failed to open file: $orf_annotation_file\n";
		while (defined(my $orf = $input->dequeue)) {
			open(EXTRACT_SEQ, "|-", "bedtools getfasta -s -fi $genome_sequence_file -bed - -fo $dir/$analysis_prefix.$orf.fna") or die "Failed to extract sequences: $orf\n";
			seek(BED, 0, 0);
			while (my $line = <BED>) {
				my @col = split(/\t/, $line);
				print EXTRACT_SEQ $line if $col[3] =~ /:$orf$/;
			}
			close(EXTRACT_SEQ);
			my $stderr = "\n### $orf ###\n" . `$cmd $opt $dir/$analysis_prefix.$orf.fna $dir/$analysis_prefix.$orf.aln.fna 2>&1`;
			die "Failed to execute $cmd: $orf\n" if $?;
			$output->enqueue($stderr);
		}
		close(BED);
		return(1);
	};
}

$threads[$num_threads] = async {
	threads->set_thread_exit_only(1);
	while (defined(my $stderr = $output->dequeue)) {print STDERR $stderr;}
	return(1);
};

while (my $line = <>) {
	chomp($line);
	my @col = split(/\t/, $line);
	$input->enqueue($col[3]) if threads->list(threads::running) > $num_threads;	
}

my $thread_fin_flag = 1;
$input->end;
for (my $thread_id = 0;$thread_id < $num_threads;$thread_id++) {$thread_fin_flag = $threads[$thread_id]->join if $thread_fin_flag;}
die "Worker threads abnormally exited\n" unless $thread_fin_flag;
$output->end;
$threads[$num_threads]->join or die "Data merge thread abnormally exited\n";
exit;
