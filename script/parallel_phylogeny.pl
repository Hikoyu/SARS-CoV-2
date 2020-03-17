#!/usr/bin/env perl

# Copyright (c) 2020 Hikoyu Suzuki
# This script is released under the MIT License.

use strict;
use warnings;
use threads;
use threads::shared;
use Thread::Queue;
use Math::BigFloat;
use File::Copy 'move';
use List::Util 'reduce';

my $cmd = "raxml-ng";
my $opt = "--threads 1";
my $dir = "phylogeny/RAxML-NG";

my $num_threads = shift(@ARGV);
my $num_chunks = shift(@ARGV);
my $tree_search_iterations = Math::BigFloat->new(shift(@ARGV));
my $bootstraps_replicates = Math::BigFloat->new(shift(@ARGV));
my $analysis_prefix = shift(@ARGV);
my $msa_file = shift(@ARGV);
my $msa_format = shift(@ARGV);
my $data_type = shift(@ARGV);
my $out_group = shift(@ARGV);
my $model = shift(@ARGV);

$num_threads = 1 unless $num_threads;
$num_chunks = 1 unless $num_chunks;
$num_chunks = 65535 if $num_chunks > 65535;
$tree_search_iterations = 1 unless $tree_search_iterations;
$tree_search_iterations = 65535 if $tree_search_iterations > 65535;
$bootstraps_replicates = 1 unless $bootstraps_replicates;
$bootstraps_replicates = 65535 if $bootstraps_replicates > 65535;

system("$cmd $opt --parse --prefix $dir/$data_type/$analysis_prefix --msa $msa_file --msa-format $msa_format --data-type $data_type --model $model") and die "Failed to execute $cmd --parse\n";
move("$dir/$data_type/$analysis_prefix.raxml.log", "$dir/$data_type/$analysis_prefix.parse.raxml.log");

my @final_loglikelihood : shared;
my @aic_score : shared;
my @aicc_score : shared;
my @bic_score : shared;
my @free_parameters : shared;
my @threads = ();
my $input = Thread::Queue->new;
my $output = Thread::Queue->new;

for (my $thread_id = 0;$thread_id < $num_threads;$thread_id++) {
	$threads[$thread_id] = async {
		threads->set_thread_exit_only(1);
		while (defined(my $chunk = $input->dequeue)) {
			my $chunk_id = $chunk >> 16;
			my $num_iterations = $chunk & 0xFFFF;
			my $seed = int(rand(0xFFFFFFFF));
			my $stderr = "\n### chunk $chunk_id ###\n" . `$cmd $opt --search --tree rand{$num_iterations},pars{$num_iterations} --seed $seed --prefix $dir/$data_type/$analysis_prefix.$chunk_id --msa $dir/$data_type/$analysis_prefix.raxml.rba --outgroup $out_group 2>&1`;
			die "Failed to execute $cmd --search: thread $thread_id\n" if $?;
			move("$dir/$data_type/$analysis_prefix.$chunk_id.raxml.log", "$dir/$data_type/$analysis_prefix.search.$chunk_id.raxml.log");
			($final_loglikelihood[$chunk_id]) = $stderr =~ /Final LogLikelihood: -\d+\.\d+/g;
			($aic_score[$chunk_id]) = $stderr =~ /AIC score: \d+\.\d+/g;
			($aicc_score[$chunk_id]) = $stderr =~ /AICc score: \d+\.\d+/g;
			($bic_score[$chunk_id]) = $stderr =~ /BIC score: \d+\.\d+/g;
			($free_parameters[$chunk_id]) = $stderr =~ /Free parameters \(model \+ branch lengths\): \d+/g;
			$output->enqueue($stderr);
		}
		return(1);
	};
}

$threads[$num_threads] = async {
	threads->set_thread_exit_only(1);
	while (defined(my $stderr = $output->dequeue)) {print STDERR $stderr;}
	return(1);
};

for (my $i = 0;$i < $num_chunks;$i++) {
	my $num_iterations = Math::BigFloat->new($tree_search_iterations / ($num_chunks - $i))->bceil->as_int;
	$input->enqueue($i << 16 | $num_iterations) if threads->list(threads::running) > $num_threads;
	$tree_search_iterations -= $num_iterations;
}

my $thread_fin_flag = 1;
$input->end;
for (my $thread_id = 0;$thread_id < $num_threads;$thread_id++) {$thread_fin_flag = $threads[$thread_id]->join if $thread_fin_flag;}
map {$_->detach} threads->list or die "Worker threads abnormally exited\n" unless $thread_fin_flag;
$output->end;
$threads[$num_threads]->join or die "Data merge thread abnormally exited\n";

$input = Thread::Queue->new;
$output = Thread::Queue->new;

for (my $thread_id = 0;$thread_id < $num_threads;$thread_id++) {
	$threads[$thread_id] = async {
		threads->set_thread_exit_only(1);
		while (defined(my $chunk = $input->dequeue)) {
			my $chunk_id = $chunk >> 16;
			my $num_iterations = $chunk & 0xFFFF;
			my $seed = int(rand(0xFFFFFFFF));
			my $stderr = "\n### chunk $chunk_id ###\n" . `$cmd $opt --bootstrap --bs-trees $num_iterations --seed $seed --prefix $dir/$data_type/$analysis_prefix.$chunk_id --msa $dir/$data_type/$analysis_prefix.raxml.rba --outgroup $out_group 2>&1`;
			die "Failed to execute $cmd --bootstrap: thread $thread_id\n" if $?;
			move("$dir/$data_type/$analysis_prefix.$chunk_id.raxml.log", "$dir/$data_type/$analysis_prefix.bootstrap.$chunk_id.raxml.log");
			$output->enqueue($stderr);
		}
		return(1);
	};
}

$threads[$num_threads] = async {
	threads->set_thread_exit_only(1);
	while (defined(my $stderr = $output->dequeue)) {print STDERR $stderr;}
	return(1);
};

for (my $i = 0;$i < $num_chunks;$i++) {
	my $num_iterations = Math::BigFloat->new($bootstraps_replicates / ($num_chunks - $i))->bceil->as_int;
	$input->enqueue($i << 16 | $num_iterations) if threads->list(threads::running) > $num_threads;
	$bootstraps_replicates -= $num_iterations;
}

$input->end;
for (my $thread_id = 0;$thread_id < $num_threads;$thread_id++) {$thread_fin_flag = $threads[$thread_id]->join if $thread_fin_flag;}
map {$_->detach} threads->list or die "Worker threads abnormally exited\n" unless $thread_fin_flag;
$output->end;
$threads[$num_threads]->join or die "Data merge thread abnormally exited\n";

open(ALL_BOOTSTRAP_TREE, ">", "$dir/$data_type/$analysis_prefix.raxml.bootstraps") or die "Failed to make file: $dir/$data_type/$analysis_prefix.raxml.bootstraps\n";
foreach my $bootstrap_tree_file (glob("$dir/$data_type/$analysis_prefix.*.raxml.bootstraps")) {
	open(BOOTSTRAP_TREE, "<", $bootstrap_tree_file) or die "Failed to open file: bootstrap_tree_file\n";
	while (my $line = <BOOTSTRAP_TREE>) {print ALL_BOOTSTRAP_TREE $line;}
	close(BOOTSTRAP_TREE);
}
close(ALL_BOOTSTRAP_TREE);

system("$cmd $opt --bsconverge --bs-trees $dir/$data_type/$analysis_prefix.raxml.bootstraps --prefix $dir/$data_type/$analysis_prefix --outgroup $out_group") and die "Failed to execute $cmd --bsconverge\n";
move("$dir/$data_type/$analysis_prefix.raxml.log", "$dir/$data_type/$analysis_prefix.bsconverge.raxml.log");

@final_loglikelihood = map {substr($_, rindex($_, " ") + 1)} @final_loglikelihood;
my $best_tree_id = reduce {$final_loglikelihood[$a] > $final_loglikelihood[$b] ? $a : $b} (0..$num_chunks - 1);
print STDERR "Best Tree: $dir/$data_type/$analysis_prefix.$best_tree_id.raxml.bestTree\n";
print STDERR "Final LogLikelihood: $final_loglikelihood[$best_tree_id]\n";
print STDERR "$aic_score[$best_tree_id]\n";
print STDERR "$aicc_score[$best_tree_id]\n";
print STDERR "$bic_score[$best_tree_id]\n";
print STDERR "$free_parameters[$best_tree_id]\n";

system("$cmd $opt --support --tree $dir/$data_type/$analysis_prefix.$best_tree_id.raxml.bestTree --bs-trees $dir/$data_type/$analysis_prefix.raxml.bootstraps --prefix $dir/$data_type/$analysis_prefix --outgroup $out_group") and die "Failed to execute $cmd --support\n";
move("$dir/$data_type/$analysis_prefix.raxml.log", "$dir/$data_type/$analysis_prefix.support.raxml.log");
move("$dir/$data_type/$analysis_prefix.raxml.support", "$dir/$data_type/$analysis_prefix.raxml.support.nwk");
exit;
