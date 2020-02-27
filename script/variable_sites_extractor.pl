#!/usr/bin/env perl
use strict;
use warnings;
use List::Util 'min', 'max', 'sum', 'reduce';
use constant offset => 3;

my $detection_type = shift(@ARGV);
my @pickup_sites = ();
if (-f $detection_type) {
	open(SITE, "<", $detection_type) or die "Failed to open the site position list file: $detection_type\n";
	while (my $line = <SITE>) {
		chomp($line);
		push(@pickup_sites, $line);
	}
	close(SITE);
	print STDERR "Detection type: variable sites in the site position list file: $detection_type\n";
} else {
	print STDERR "Detection type: ", $detection_type ? "variable" : "parsimony-informative", " sites\n";
}

my %ref_start_pos = ();
my $bed_file = shift(@ARGV);
open(BED, "<", $bed_file) or die "Failed to open the BED file: $bed_file\n";
while (my $line = <BED>) {
	next if $line =~ /^["#"]/;
	chomp($line);
	my @col = split(/\t/, $line);
	$ref_start_pos{$col[0]}{$col[3]} = $col[1];
}
close(BED);

my @sample_list = ();
my $sample_list_file = shift(@ARGV);
open(LIST, "<", $sample_list_file) or die "Failed to open the sample list file: $sample_list_file\n";
while (my $line = <LIST>) {
	next if $line =~ /^["#"]/;
	chomp($line);
	push(@sample_list, $line);
}
close(LIST);

my $ref = $sample_list[0];
die "Reference sequence: $ref not found in the BED file: $bed_file\n" if !exists($ref_start_pos{$ref});

print STDERR "Reference sequence: $ref\n";

my %mismatch_penalties = ();
my %variable_sites = ();
my %parsimony_informative_sites = ();
while (my $line = <>) {
	chomp($line);
	my @col = split(/\t/, $line);
	die "Target sequence: $col[0] not found in the BED file: $bed_file\n" if !exists($ref_start_pos{$ref}{$col[0]});
	
	my $id = "";
	my %seq = ();
	open(FASTA, "<", $col[1]) or die "Failed to open the FASTA file; $col[1]\n";
	while (my $line = <FASTA>) {
		chomp($line);
		$id = substr($line, 1) and $seq{$id} = "" or next if $line =~ /^>/;
		$seq{$id} .= uc($line);
	}
	close(FASTA);
	
	die "Reference sequence: $ref not found in the FASTA file: $col[1]\n" if !exists($seq{$ref});
	foreach (@sample_list) {die "Sequence: $_ not found in FASTA file: $col[1]\n" if !exists($seq{$_});}
	die "Sequences in the FASTA file: $col[1] do not appear to be aligned\n" unless reduce {$a == $b ? $a : 0} map {length($_)} values(%seq);
	
	my $pos = $ref_start_pos{$ref}{$col[0]};
	my $len = length($seq{$ref});
	for (my $i = 0;$i < $len;$i++) {
		$pos += substr($seq{$ref}, $i, 1) ne "-";
		my %site = map {$_ => substr($seq{$_}, $i, 1)} @sample_list;
		my %num_samples = ();
		map {$num_samples{$_}++} values(%site);
		next if keys(%num_samples) <= 1;	# remove non-variables sites
		next if exists($num_samples{"-"});	# remove gapped sites
		$mismatch_penalties{$pos} = sum(map {$_ * log($_)} map {$_ / @sample_list} values(%num_samples));
		map {$variable_sites{$_}{$pos} = $site{$_}} keys(%site);
		$parsimony_informative_sites{$pos} = 1 if scalar(grep {$_ > 1} values(%num_samples)) > 1;
	}
}

@pickup_sites = $detection_type ? keys(%{$variable_sites{$ref}}) : keys(%parsimony_informative_sites) and print STDERR scalar(@pickup_sites), $detection_type ? " variable" : " parsimony-informative", " sites found\n" unless @pickup_sites;
@pickup_sites = sort {$a <=> $b} grep {exists($variable_sites{$ref}{$_})} @pickup_sites;
die "No ", $detection_type ? "variable" : "parsimony-informative", " sites found", -f $detection_type ? " in the site position list file: $detection_type\n" : "\n" unless @pickup_sites;

my %match_score = ();
foreach my $id (@sample_list) {
	$match_score{$id} = sum(map {$mismatch_penalties{$_} * ($variable_sites{$id}{$_} ne $variable_sites{$ref}{$_})} keys(%parsimony_informative_sites));
}

my $longest_sample_name_len = max(map {length($_)} keys(%variable_sites));
for (my $i = 0;$i < length($pickup_sites[-1]);$i++) {
	print " " x ($longest_sample_name_len + offset), join("", map {$i + length($_) < length($pickup_sites[-1]) ? " " : substr($_, $i + length($_) - length($pickup_sites[-1]), 1)} @pickup_sites), "\n"
}
print "-" x ($longest_sample_name_len + @pickup_sites + offset), "\n";
print $ref, " " x ($longest_sample_name_len - length($ref) + offset), join("", map {$variable_sites{$ref}{$_}} @pickup_sites), "\n";
foreach my $id (sort {$match_score{$b} <=> $match_score{$a} || $a cmp $b} grep {$_ ne $ref} @sample_list) {
	print $id, " " x ($longest_sample_name_len - length($id) + offset), join("", map {$variable_sites{$id}{$_} eq $variable_sites{$ref}{$_} ? "." : $variable_sites{$id}{$_}} grep {exists($variable_sites{$ref}{$_})} @pickup_sites), "\n";
}
