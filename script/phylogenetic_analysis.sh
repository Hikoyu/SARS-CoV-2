#!/bin/bash

# Copyright (c) 2020 Hikoyu Suzuki
# This script is released under the MIT License.

#########################
# Settings for analyses #
#########################
analysis_prefix="SARS-CoV-2_200407"
orf_reference_prefix="ref/MN908947.orf"
model_type="bic"
out_group="MG772933.1"
msa_format="FASTA"
tree_search_iterations=100
bootstraps_replicates=1000
num_threads=4
num_chunks=12
active_model=(1 1 1 1 1 1 0 0)


#########################################################
# Concatenate MSA of each ORF for phylogenetic analyses #
#########################################################
file_list=`perl -F"\t" -lane 'print $F[1]' famsa/msa_list.txt`
perl -lne '$id = substr($_, 0, index("$_:", ":")) and next if /^>/;$seq{$id} .= $_; END{print join("\n", map {$_, $seq{$_}} sort(keys(%seq)));}' $file_list | tee phylogeny/$analysis_prefix.aln.concat.fna | script/translator.pl >phylogeny/$analysis_prefix.aln.concat.faa


##################################################################
# Construct phylogenies based on DNA sequences by using RAxML-NG #
##################################################################
data_type="DNA"
msa_file="phylogeny/$analysis_prefix.aln.concat.fna"

# Do not use partitioned model
if [ ${active_model[0]} -ne 0 ] ; then
	modeltest-ng -p $num_threads -d nt -i $msa_file -o phylogeny/ModelTest-NG/$data_type/univ/uni/$analysis_prefix
	model=`grep -A 2 -i "Best model according to $model_type" phylogeny/ModelTest-NG/$data_type/univ/uni/$analysis_prefix.out | perl -lane 'print $F[1] if $F[0] eq "Model:"'`
	script/parallel_phylogeny.pl $num_threads $num_chunks $tree_search_iterations $bootstraps_replicates univ/uni/$analysis_prefix $msa_file $msa_format $data_type $out_group $model
fi

# Use partitioned model for 1st/2nd and 3rd codon position
if [ ${active_model[1]} -ne 0 ] ; then
	perl -lne '++$flag and next if /^>/;$len += length($_) if $flag == 1; END{print "DNA, p1_p2 = 1-$len/3, 2-$len/3\nDNA, p3 = 3-$len/3";}' $msa_file >phylogeny/ModelTest-NG/$data_type/univ/3rd/$analysis_prefix.part.txt
	modeltest-ng -p $num_threads -d nt -i $msa_file -o phylogeny/ModelTest-NG/$data_type/univ/3rd/$analysis_prefix -q phylogeny/ModelTest-NG/$data_type/univ/3rd/$analysis_prefix.part.txt
	model="phylogeny/ModelTest-NG/$data_type/univ/3rd/$analysis_prefix.part.$model_type"
	script/parallel_phylogeny.pl $num_threads $num_chunks $tree_search_iterations $bootstraps_replicates univ/3rd/$analysis_prefix $msa_file $msa_format $data_type $out_group $model
fi

# Use partitioned model for each codon position
if [ ${active_model[2]} -ne 0 ] ; then
	perl -lne '++$flag and next if /^>/;$len += length($_) if $flag == 1; END{print "DNA, p1 = 1-$len/3\nDNA, p2 = 2-$len/3\nDNA, p3 = 3-$len/3";}' $msa_file >phylogeny/ModelTest-NG/$data_type/univ/sep/$analysis_prefix.part.txt
	modeltest-ng -p $num_threads -d nt -i $msa_file -o phylogeny/ModelTest-NG/$data_type/univ/sep/$analysis_prefix -q phylogeny/ModelTest-NG/$data_type/univ/sep/$analysis_prefix.part.txt
	model="phylogeny/ModelTest-NG/$data_type/univ/sep/$analysis_prefix.part.$model_type"
	script/parallel_phylogeny.pl $num_threads $num_chunks $tree_search_iterations $bootstraps_replicates univ/sep/$analysis_prefix $msa_file $msa_format $data_type $out_group $model
fi

# Use partitioned model for each ORF
if [ ${active_model[3]} -ne 0 ] ; then
	perl -lne '($len{$ARGV}, $id, $flag) = ($len{$id}, $ARGV, 0) if $id ne $ARGV;++$flag and next if /^>/;$len{$id} += length($_) if $flag == 1; END{$pos = 0;foreach (sort {$len{$a} <=> $len{$b}} keys(%len)) {$id = [split(/\./, $_)]->[1];print "DNA, $id = ", $pos + 1, "-$len{$_}";$pos = $len{$_};}}' $file_list >phylogeny/ModelTest-NG/$data_type/part/uni/$analysis_prefix.part.txt
	modeltest-ng -p $num_threads -d nt -i $msa_file -o phylogeny/ModelTest-NG/$data_type/part/uni/$analysis_prefix -q phylogeny/ModelTest-NG/$data_type/part/uni/$analysis_prefix.part.txt
	model="phylogeny/ModelTest-NG/$data_type/part/uni/$analysis_prefix.part.$model_type"
	script/parallel_phylogeny.pl $num_threads $num_chunks $tree_search_iterations $bootstraps_replicates part/uni/$analysis_prefix $msa_file $msa_format $data_type $out_group $model
fi

# Use Partitioned model for each ORF and also 1st/2nd and 3rd codon position
if [ ${active_model[4]} -ne 0 ] ; then
	perl -lne '($len{$ARGV}, $id, $flag) = ($len{$id}, $ARGV, 0) if $id ne $ARGV;++$flag and next if /^>/;$len{$id} += length($_) if $flag == 1; END{$pos = 0;foreach (sort {$len{$a} <=> $len{$b}} keys(%len)) {$id = [split(/\./, $_)]->[1];print "DNA, $id = ", $pos + 1, "-$len{$_}/3, ", $pos + 2, "-$len{$_}/3";print "DNA, ${id}_p3 = ", $pos + 3, "-$len{$_}/3";$pos = $len{$_};}}' $file_list >phylogeny/ModelTest-NG/$data_type/part/3rd/$analysis_prefix.part.txt
	modeltest-ng -p $num_threads -d nt -i $msa_file -o phylogeny/ModelTest-NG/$data_type/part/3rd/$analysis_prefix -q phylogeny/ModelTest-NG/$data_type/part/3rd/$analysis_prefix.part.txt
	model="phylogeny/ModelTest-NG/$data_type/part/3rd/$analysis_prefix.part.$model_type"
	script/parallel_phylogeny.pl $num_threads $num_chunks $tree_search_iterations $bootstraps_replicates part/3rd/$analysis_prefix $msa_file $msa_format $data_type $out_group $model
fi

# Use partitioned model for each ORF and also each codon position
if [ ${active_model[5]} -ne 0 ] ; then
	perl -lne '($len{$ARGV}, $id, $flag) = ($len{$id}, $ARGV, 0) if $id ne $ARGV;++$flag and next if /^>/;$len{$id} += length($_) if $flag == 1; END{$pos = 0;foreach (sort {$len{$a} <=> $len{$b}} keys(%len)) {$id = [split(/\./, $_)]->[1];print "DNA, ${id}_p1 = ", $pos + 1, "-$len{$_}/3";print "DNA, ${id}_p2 = ", $pos + 2, "-$len{$_}/3";print "DNA, ${id}_p3 = ", $pos + 3, "-$len{$_}/3";$pos = $len{$_};}}' $file_list >phylogeny/ModelTest-NG/$data_type/part/sep/$analysis_prefix.part.txt
	modeltest-ng -p $num_threads -d nt -i $msa_file -o phylogeny/ModelTest-NG/$data_type/part/sep/$analysis_prefix -q phylogeny/ModelTest-NG/$data_type/part/sep/$analysis_prefix.part.txt
	model="phylogeny/ModelTest-NG/$data_type/part/sep/$analysis_prefix.part.$model_type"
	script/parallel_phylogeny.pl $num_threads $num_chunks $tree_search_iterations $bootstraps_replicates part/sep/$analysis_prefix $msa_file $msa_format $data_type $out_group $model
fi


#################################################################
# Construct phylogenies based on AA sequences by using RAxML-NG #
#################################################################
data_type="AA"
msa_file="phylogeny/$analysis_prefix.aln.concat.faa"

# Do not use partitioned model
if [ ${active_model[6]} -ne 0 ] ; then
	modeltest-ng -p $num_threads -d aa -i $msa_file -o phylogeny/ModelTest-NG/$data_type/univ/$analysis_prefix
	model=`grep -A 2 -i "Best model according to $model_type" phylogeny/ModelTest-NG/$data_type/univ/$analysis_prefix.out | perl -lane 'print $F[1] if $F[0] eq "Model:"'`
	script/parallel_phylogeny.pl $num_threads $num_chunks $tree_search_iterations $bootstraps_replicates univ/$analysis_prefix $msa_file $msa_format $data_type $out_group $model
fi

# Use partitioned model for each ORF
if [ ${active_model[7]} -ne 0 ] ; then
	perl -lne '($len{$ARGV}, $id, $flag) = ($len{$id}, $ARGV, 0) if $id ne $ARGV;++$flag and next if /^>/;$len{$id} += length($_) if $flag == 1; END{$pos = 0;foreach (sort {$len{$a} <=> $len{$b}} keys(%len)) {print "PROT, ", [split(/\./, $_)]->[1], " = ", $pos / 3 + 1, "-", $len{$_} / 3;$pos = $len{$_};}}' $file_list >phylogeny/ModelTest-NG/$data_type/part/$analysis_prefix.part.txt
	modeltest-ng -p $num_threads -d aa -i $msa_file -o phylogeny/ModelTest-NG/$data_type/part/$analysis_prefix -q phylogeny/ModelTest-NG/$data_type/part/$analysis_prefix.part.txt
	model="phylogeny/ModelTest-NG/$data_type/part/$analysis_prefix.part.$model_type"
	script/parallel_phylogeny.pl $num_threads $num_chunks $tree_search_iterations $bootstraps_replicates part/$analysis_prefix $msa_file $msa_format $data_type $out_group $model
fi
