#!/bin/bash

########################################################################
# Construct phylogenetic tree based on DNA sequences by using RAxML-NG #
########################################################################
orf_list=`awk '{print $4}' ref/MN908947_cds.bed`
file_list=`for orf in $orf_list; do echo "dialign/SARS-CoV-2_200222.cds.$orf.aln.fna"; done`
perl -lne '$id = $_ and next if /^>/;$seq{$id} .= $_; END{print join("\n", map {$_, $seq{$_}} sort(keys(%seq)));}' $file_list >phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna

# Do not use partitioned model
modeltest-ng -d nt -i phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna -o phylogeny/DNA/model_test/univ/uni/SARS-CoV-2_200222.cds
model=`grep -A 2 'Best model according to BIC' phylogeny/DNA/model_test/univ/uni/SARS-CoV-2_200222.cds.out | perl -lane 'print $F[1] if $F[0] eq "Model:"'`
raxml-ng --all --prefix phylogeny/DNA/RAxML-NG/univ/uni/SARS-CoV-2_200222.cds --msa phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna --msa-format FASTA --data-type DNA --model $model --outgroup MG772933.1_Bat_SARS-like_coronavirus_isolate_bat-SL-CoVZC45 --bs-trees 1000

# Use partitioned model for 1st/2nd and 3rd codon position
perl -lne '++$flag and next if /^>/;$len += length($_) if $flag == 1; END{print "DNA, p1_p2 = 1-$len/3, 2-$len/3\nDNA, p3 = 3-$len/3";}' phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna >phylogeny/DNA/SARS-CoV-2_200222.cds.univ_3rd.txt
modeltest-ng -d nt -i phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna -q phylogeny/DNA/SARS-CoV-2_200222.cds.univ_3rd.txt -o phylogeny/DNA/model_test/univ/3rd/SARS-CoV-2_200222.cds
raxml-ng --all --prefix phylogeny/DNA/RAxML-NG/univ/3rd/SARS-CoV-2_200222.cds --msa phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna --msa-format FASTA --data-type DNA --model phylogeny/DNA/model_test/univ/3rd/SARS-CoV-2_200222.cds.part.bic --outgroup MG772933.1_Bat_SARS-like_coronavirus_isolate_bat-SL-CoVZC45 --bs-trees 1000

# Use partitioned model for each codon position
perl -lne '++$flag and next if /^>/;$len += length($_) if $flag == 1; END{print "DNA, p1 = 1-$len/3\nDNA, p2 = 2-$len/3\nDNA, p3 = 3-$len/3";}' phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna >phylogeny/DNA/SARS-CoV-2_200222.cds.univ_sep.txt
modeltest-ng -d nt -i phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna -q phylogeny/DNA/SARS-CoV-2_200222.cds.univ_sep.txt -o phylogeny/DNA/model_test/univ/sep/SARS-CoV-2_200222.cds
raxml-ng --all --prefix phylogeny/DNA/RAxML-NG/univ/sep/SARS-CoV-2_200222.cds --msa phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna --msa-format FASTA --data-type DNA --model phylogeny/DNA/model_test/univ/sep/SARS-CoV-2_200222.cds.part.bic --outgroup MG772933.1_Bat_SARS-like_coronavirus_isolate_bat-SL-CoVZC45 --bs-trees 1000

# Use partitioned model for each ORF
perl -lne '($len{$ARGV}, $id, $flag) = ($len{$id}, $ARGV, 0) if $id ne $ARGV;++$flag and next if /^>/;$len{$id} += length($_) if $flag == 1; END{$pos = 0;foreach (sort {$len{$a} <=> $len{$b}} keys(%len)) {print "DNA, ", [split(/\./, $_)]->[2], " = ", $pos + 1, "-$len{$_}";$pos = $len{$_};}}' $file_list >phylogeny/DNA/SARS-CoV-2_200222.cds.part_uni.txt
modeltest-ng -d nt -i phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna -q phylogeny/DNA/SARS-CoV-2_200222.cds.part_uni.txt -o phylogeny/DNA/model_test/part/uni/SARS-CoV-2_200222.cds
raxml-ng --all --prefix phylogeny/DNA/RAxML-NG/part/uni/SARS-CoV-2_200222.cds --msa phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna --msa-format FASTA --data-type DNA --model phylogeny/DNA/model_test/part/uni/SARS-CoV-2_200222.cds.part.bic --outgroup MG772933.1_Bat_SARS-like_coronavirus_isolate_bat-SL-CoVZC45 --bs-trees 1000

# Use Partitioned model for each ORF and also 1st/2nd and 3rd codon position
perl -F"\s+=?\s*|-" -lane 'print "$F[0] $F[1] = $F[2]-$F[3]/3, ", $F[2] + 1, "-$F[3]/3\n$F[0] $F[1]_p3 = ", $F[2] + 2, "-$F[3]/3"' phylogeny/DNA/SARS-CoV-2_200222.cds.part_uni.txt >phylogeny/DNA/SARS-CoV-2_200222.cds.part_3rd.txt
modeltest-ng -d nt -i phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna -q phylogeny/DNA/SARS-CoV-2_200222.cds.part_3rd.txt -o phylogeny/DNA/model_test/part/3rd/SARS-CoV-2_200222.cds
raxml-ng --all --prefix phylogeny/DNA/RAxML-NG/part/3rd/SARS-CoV-2_200222.cds --msa phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna --msa-format FASTA --data-type DNA --model phylogeny/DNA/model_test/part/3rd/SARS-CoV-2_200222.cds.part.bic --outgroup MG772933.1_Bat_SARS-like_coronavirus_isolate_bat-SL-CoVZC45 --bs-trees 1000

# Use partitioned model for each ORF and also each codon position
perl -F"\s+=?\s*|-" -lane 'print "$F[0] $F[1]_p1 = $F[2]-$F[3]/3\n$F[0] $F[1]_p2 = ", $F[2] + 1, "-$F[3]/3\n$F[0] $F[1]_p3 = ", $F[2] + 2, "-$F[3]/3"' phylogeny/DNA/SARS-CoV-2_200222.cds.part_uni.txt >phylogeny/DNA/SARS-CoV-2_200222.cds.part_sep.txt
modeltest-ng -d nt -i phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna -q phylogeny/DNA/SARS-CoV-2_200222.cds.part_sep.txt -o phylogeny/DNA/model_test/part/sep/SARS-CoV-2_200222.cds
raxml-ng --all --prefix phylogeny/DNA/RAxML-NG/part/sep/SARS-CoV-2_200222.cds --msa phylogeny/DNA/SARS-CoV-2_200222.cds.aln.concat.fna --msa-format FASTA --data-type DNA --model phylogeny/DNA/model_test/part/sep/SARS-CoV-2_200222.cds.part.bic --outgroup MG772933.1_Bat_SARS-like_coronavirus_isolate_bat-SL-CoVZC45 --bs-trees 1000


#######################################################################
# Construct phylogenetic tree based on AA sequences by using RAxML-NG #
#######################################################################
file_list=`for orf in $orf_list; do echo "dialign/SARS-CoV-2_200222.cds.$orf.aln.faa"; done`
perl -lne '$id = $_ and next if /^>/;$seq{$id} .= $_; END{print join("\n", map {$_, $seq{$_}} sort(keys(%seq)));}' $file_list >phylogeny/AA/SARS-CoV-2_200222.cds.aln.concat.faa

# Use partitioned model for each ORF
perl -lne '($len{$ARGV}, $id, $flag) = ($len{$id}, $ARGV, 0) if $id ne $ARGV;++$flag and next if /^>/;$len{$id} += length($_) if $flag == 1; END{$pos = 0;foreach (sort {$len{$a} <=> $len{$b}} keys(%len)) {print "PROT, ", [split(/\./, $_)]->[2], " = ", $pos + 1, "-$len{$_}";$pos = $len{$_};}}' $file_list >phylogeny/AA/SARS-CoV-2_200222.cds.part.txt
modeltest-ng -d aa -i phylogeny/AA/SARS-CoV-2_200222.cds.aln.concat.faa -q phylogeny/AA/SARS-CoV-2_200222.cds.part.txt -o phylogeny/AA/model_test/SARS-CoV-2_200222.cds
raxml-ng --all --prefix phylogeny/AA/RAxML-NG/SARS-CoV-2_200222.cds --msa phylogeny/AA/SARS-CoV-2_200222.cds.aln.concat.faa --msa-format FASTA --data-type AA --model phylogeny/AA/model_test/SARS-CoV-2_200222.cds.part.bic --outgroup MG772933.1_Bat_SARS-like_coronavirus_isolate_bat-SL-CoVZC45 --bs-trees 1000
