#!/bin/bash

# Copyright (c) 2020 Hikoyu Suzuki
# This script is released under the MIT License.

#########################
# Settings for analyses #
#########################
analysis_prefix="SARS-CoV-2_200414"
orf_reference_prefix="ref/MN908947.orf"
genome_sequence_file="genome/$analysis_prefix.fna"
ref_sample="MN908947"
excluded_samples="MT159705,MT159706,MT159707,MT159708,MT159709,MT159710,MT159711,MT159712,MT159713,MT159714,MT159715,MT159716,MT159717,MT159718,MT159719,MT159720,MT159721,MT159722,MT184907,MT184908,MT184909,MT184910,MT184911,MT184912,MT184913"
excluded_samples="$excluded_samples,LR757997,MT198651,MT198653,MT233520,MT233521,MT256917,MT256918,MT256924,MT263460,MT281530,MT292576,MT292577,MT292578,MT292579,MT292580,MT292581,MT292582,MT308692,MT308693,MT308694,MT308695,MT308696,MT308697,MT308698,MT308699,MT308700"
excluded_samples="$excluded_samples,MN988713,MT039888,MT066156,MT163721,MT198652,MT233519,MT233522,MT246456,MT246458,MT246463,MT246465,MT246473,MT246482,MT246483,MT246485,MT251973,MT253706,MT258377,MT258379,MT258380,MT258381,MT258382,MT258383,MT259238,MT259242,MT259255,MT259259,MT259265,MT259270,MT259272,MT259273,MT259277,MT259279,MT259283,MT259284,MT263385,MT263387,MT263389,MT263393,MT263397,MT263401,MT263407,MT263409,MT263413,MT263418,MT263420,MT263421,MT263426,MT263427,MT263431,MT263436,MT263441,MT263443,MT263445,MT263451,MT263453,MT263454,MT263455,MT263459,MT263461,MT263466,MT276331,MT292570,MT292574,MT292575,MT293156,MT293158,MT293160,MT293165,MT293167,MT293180,MT293193,MT293196,MT293198,MT293200,MT293203,MT293207,MT293213,MT293217,MT293224,MT304477,MT304478,MT304483,MT304489,MT304491,MT308704"
num_threads=4


###################################################
# Extract reference ORF sequences from 'MN908947' #
###################################################
bedtools getfasta -name -fi $genome_sequence_file -bed $orf_reference_prefix.bed -fo - | perl -F":" -lane 'print $F[0];' | tee $orf_reference_prefix.fna | script/translator.pl >$orf_reference_prefix.faa


#########################################################
# Search ORF sequences from other genomes by using FATE #
#########################################################
num_samples=`grep ">" $genome_sequence_file | wc -l`
fate.pl search -p $num_threads -m $num_samples -x -h tblastn $genome_sequence_file $orf_reference_prefix.faa | perl -F"\t" -lane 'BEGIN{$excluded_samples = join("|", map {"^$_"} split(/,/, shift(@ARGV)));} $_ = "#" . $_ if $F[0] =~ /$excluded_samples/ || $F[4] < 50;print;' $excluded_samples >fate/$analysis_prefix.orf.bed


#####################################################
# Construct MSA of each ORF sequence by using FAMSA #
#####################################################
script/codon_based_msa.pl $num_threads $analysis_prefix $genome_sequence_file fate/$analysis_prefix.orf.bed $orf_reference_prefix.bed


################################################
# Extract variable/persimony-informative sites #
################################################
perl -F"\t" -lane 'BEGIN{$ref_sample = shift(@ARGV);$excluded_samples = join("|", map {"^$_"} split(/,/, shift(@ARGV)));} $F[0] = "!" . $F[0] if $F[0] =~ /$ref_sample/;$F[0] = "#" . $F[0] if $F[0] =~ /$excluded_samples/;print $F[0]' $ref_sample $excluded_samples $genome_sequence_file.fai >genome/sample_list.txt
perl -F"\t" -lane 'BEGIN{$analysis_prefix = shift(@ARGV);} print $F[3], "\t", "famsa/$analysis_prefix.$F[3].aln.fna";' $analysis_prefix $orf_reference_prefix.bed >famsa/msa_list.txt
sed -i '' -e 's/MN996532/#MN996532/' genome/sample_list.txt
sed -i '' -e 's/MG772933/#MG772933/' genome/sample_list.txt
script/variable_sites_extractor.pl 1 $orf_reference_prefix.bed genome/sample_list.txt famsa/msa_list.txt >famsa/variable_sites.txt
script/variable_sites_extractor.pl 0 $orf_reference_prefix.bed genome/sample_list.txt famsa/msa_list.txt >/dev/null
mv variable_site_position_list.txt parsimony-informative_site_position_list.txt famsa/
sed -i '' -e 's/#MN996532/MN996532/' genome/sample_list.txt
sed -i '' -e 's/#MG772933/MG772933/' genome/sample_list.txt
script/variable_sites_extractor.pl famsa/parsimony-informative_site_position_list.txt $orf_reference_prefix.bed genome/sample_list.txt famsa/msa_list.txt >famsa/parsimony-informative_sites.txt


#########################
# Phylogenetic analyses #
#########################
source script/phylogenetic_analysis.sh
