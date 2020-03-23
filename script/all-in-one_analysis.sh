#!/bin/bash

# Copyright (c) 2020 Hikoyu Suzuki
# This script is released under the MIT License.

#########################
# Settings for analyses #
#########################
analysis_prefix="SARS-CoV-2_200320"
orf_reference_prefix="ref/MN908947.orf"
genome_sequence_file="genome/$analysis_prefix.fna"
ref_sample="MN908947"
excluded_samples="LR757997,MN988713,MT020781,MT039888,MT066156,MT163721,MT184913,MT184912,MT184911,MT184910,MT184909,MT184908,MT184907,MT159722,MT159721,MT159720,MT159719,MT159718,MT159717,MT159716,MT159715,MT159714,MT159713,MT159712,MT159711,MT159710,MT159709,MT159708,MT159707,MT159706,MT159705"
num_threads=4


###################################################
# Extract reference ORF sequences from 'MN908947' #
###################################################
bedtools getfasta -name -fi $genome_sequence_file -bed $orf_reference_prefix.bed -fo - | perl -F":" -lane 'print $F[0];' | tee $orf_reference_prefix.fna | script/translator.pl >$orf_reference_prefix.faa


#########################################################
# Search ORF sequences from other genomes by using FATE #
#########################################################
fate.pl search -p $num_threads -x -h tblastn $genome_sequence_file $orf_reference_prefix.faa | perl -F"\t" -lane 'BEGIN{$excluded_samples = join("|", map {"^$_"} split(/,/, shift(@ARGV)));} $_ = "#" . $_ if $F[0] =~ /$excluded_samples/ || $F[4] < 50;print;' $excluded_samples >fate/$analysis_prefix.orf.bed


##########################################################
# Construct MSA of each ORF sequence by using DIALIGN-TX #
##########################################################
script/parallel_msa.pl $num_threads $analysis_prefix $genome_sequence_file fate/$analysis_prefix.orf.bed $orf_reference_prefix.bed


################################################
# Extract variable/persimony-informative sites #
################################################
perl -F"\t" -lane 'BEGIN{$ref_sample = shift(@ARGV);$excluded_samples = join("|", map {"^$_"} split(/,/, shift(@ARGV)));} $F[0] = "!" . $F[0] if $F[0] =~ /$ref_sample/;$F[0] = "#" . $F[0] if $F[0] =~ /$excluded_samples/;print $F[0]' $ref_sample $excluded_samples $genome_sequence_file.fai >genome/sample_list.txt
perl -F"\t" -lane 'BEGIN{$analysis_prefix = shift(@ARGV);} print $F[3], "\t", "dialign/$analysis_prefix.$F[3].aln.fna";' $analysis_prefix $orf_reference_prefix.bed >dialign/msa_list.txt
sed -i '' -e 's/MN996532/#MN996532/' genome/sample_list.txt
sed -i '' -e 's/MG772933/#MG772933/' genome/sample_list.txt
script/variable_sites_extractor.pl 1 $orf_reference_prefix.bed genome/sample_list.txt dialign/msa_list.txt >dialign/variable_sites.txt
script/variable_sites_extractor.pl 0 $orf_reference_prefix.bed genome/sample_list.txt dialign/msa_list.txt >/dev/null
mv variable_site_position_list.txt parsimony-informative_site_position_list.txt dialign/
sed -i '' -e 's/#MN996532/MN996532/' genome/sample_list.txt
sed -i '' -e 's/#MG772933/MG772933/' genome/sample_list.txt
script/variable_sites_extractor.pl dialign/parsimony-informative_site_position_list.txt $orf_reference_prefix.bed genome/sample_list.txt dialign/msa_list.txt >dialign/parsimony-informative_sites.txt


#########################
# Phylogenetic analyses #
#########################
source script/phylogenetic_analysis.sh
