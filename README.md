# SARS-CoV-2 genome sequence data analyses

## System requirement
|     |                                          |
| --- | ---------------------------------------- |
| CPU | x86-64 (e.g. Intel Core i3/i5/i7 series) |
| RAM | 8 GB or above                            |
| OS  | 64-bit Linux or macOS                    |

## Software dependencies
| Package name | Version      | Site URL                                             |
| ------------ | ------------ | ---------------------------------------------------- |
| Perl         | 5.8 or later | https://www.perl.org (Preinstalled in OS)            |
| BEDTools     | 2.29.2       | https://github.com/arq5x/bedtools2                   |
| NCBI-BLAST+  | 2.2.29       | http://ftp.ncbi.nlm.nih.gov/blast/executables/blast+ |
| FATE         | 2.7.1        | https://github.com/Hikoyu/FATE                       |
| DIALIGN-TX   | 1.0.2        | https://dialign-tx.gobics.de/download                |
| ModelTest-NG | 0.1.6        | https://github.com/ddarriba/modeltest                |
| RAxML-NG     | 0.9.0        | https://github.com/amkozlov/raxml-ng                 |

## Preparation before analysis
Above softwares must be installed and in your PATH.
Some softwares need to be compiled. (e.g. BEDTools)
For Linux users, 'modeltest-ng', including binary distribution, may cause a segmentation fault error when parallel execution is enabled.
Consider using 'modeltest-mpi' as 'modeltest-ng' in stead (or set a shell variable 'num_threads' to 1).

## Re-analysis
Clone this repository and remove old data before re-analysis.
Then, simply execute 'script/all-in-one_analysis.sh' in the top of the repository.

```
$ git clone https://github.com/Hikoyu/SARS-CoV-2
$ cd SARS-CoV-2
$ rm ref/MN908947.orf.f?a genome/*.fna.* fate/*.bed dialign/*.fna phylogeny/*.* phylogeny/*/DNA/*/*/*.* phylogeny/*/AA/*/*.*
$ ./script/all-in-one_analysis.sh
```
Now, you can get the multiple sequence alignments of open reading frames, the lists of variable/parsimony-informative sites, and the maximum-likelihood phylogenies.
If you want to re-analyze only estimating phylogeny, remove old phylogenetic analysis data and execute 'script/phylogenetic_analysis.sh' in the top of the repository.

```
$ git clone https://github.com/Hikoyu/SARS-CoV-2
$ cd SARS-CoV-2
$ rm phylogeny/*.* phylogeny/*/DNA/*/*/*.* phylogeny/*/AA/*/*.*
$ ./script/phylogenetic_analysis.sh
```
Now, you can get the maximum-likelihood phylogenies.

## Calculation time
Phylogenetic analyses take a lot of time.
They took over 2 days in total on Linux workstation (4C/8T Intel Xeon E3-1240L v3, 16 GB RAM).
More CPU cores and/or newer streaming SIMD extensions may contribute to reduce the calculation time.
If you intend to just test, reduce the bootstraps replicates to 100 via 'bootstraps_replicates' shell variable in `script/phylogenetic_analysis.sh`.

## Data formats and file extensions
| Data format | File extension | Description             |
| ----------- | -------------- | ----------------------- |
| FASTA (DNA) | *.fna          | DNA sequence file       |
| FASTA (AA)  | *.faa          | AA sequence file        |
| FASTA index | *.fai          | fasta index file        |
| BED         | *.bed          | annotation data file    |
| Newick      | *.nwk          | phylogenetic tree file  |

## Files and directories
```
SARS-CoV-2
├── README.md
├── conf => including config files for DIALIGN-TX
│   ├── BLOSUM.diag_prob_t10
│   ├── BLOSUM.scr
│   ├── BLOSUM75.diag_prob_t2
│   ├── BLOSUM75.scr
│   ├── BLOSUM90.scr
│   ├── dna_diag_prob_100_exp_110000
│   ├── dna_diag_prob_100_exp_220000
│   ├── dna_diag_prob_100_exp_330000
│   ├── dna_diag_prob_100_exp_550000
│   ├── dna_diag_prob_150_exp_110000
│   ├── dna_diag_prob_200_exp_110000
│   ├── dna_diag_prob_250_exp_110000
│   └── dna_matrix.scr
├── dialign => including open reading frame sequence data and multiple sequence alignment data
│   ├── SARS-CoV-2_200318.E.aln.fna
│   ├── SARS-CoV-2_200318.E.fna
│   ├── SARS-CoV-2_200318.M.aln.fna
│   ├── SARS-CoV-2_200318.M.fna
│   ├── SARS-CoV-2_200318.N.aln.fna
│   ├── SARS-CoV-2_200318.N.fna
│   ├── SARS-CoV-2_200318.ORF10.aln.fna
│   ├── SARS-CoV-2_200318.ORF10.fna
│   ├── SARS-CoV-2_200318.ORF3a.aln.fna
│   ├── SARS-CoV-2_200318.ORF3a.fna
│   ├── SARS-CoV-2_200318.ORF6.aln.fna
│   ├── SARS-CoV-2_200318.ORF6.fna
│   ├── SARS-CoV-2_200318.ORF7a.aln.fna
│   ├── SARS-CoV-2_200318.ORF7a.fna
│   ├── SARS-CoV-2_200318.ORF8.aln.fna
│   ├── SARS-CoV-2_200318.ORF8.fna
│   ├── SARS-CoV-2_200318.S.aln.fna
│   ├── SARS-CoV-2_200318.S.fna
│   ├── SARS-CoV-2_200318.orf1ab_D.aln.fna
│   ├── SARS-CoV-2_200318.orf1ab_D.fna
│   ├── SARS-CoV-2_200318.orf1ab_U.aln.fna
│   ├── SARS-CoV-2_200318.orf1ab_U.fna
│   ├── msa_list.txt
│   ├── parsimony-informative_site_position_list.txt
│   ├── parsimony-informative_sites.txt
│   ├── variable_site_position_list.txt
│   └── variable_sites.txt
├── fate
│   └── SARS-CoV-2_200318.orf.bed => open reading frame annotation data
├── genome => including SARS-CoV-2 genome sequence data
│   ├── SARS-CoV-2_200318.fna
│   ├── SARS-CoV-2_200318.fna.fai
│   ├── SARS-CoV-2_200318.fna.nhr
│   ├── SARS-CoV-2_200318.fna.nin
│   ├── SARS-CoV-2_200318.fna.nsq
│   └── sample_list.txt
├── phylogeny
│   ├── ModelTest-NG
│   │   ├── AA
│   │   │   ├── part => including model test data using partitioned model for each ORF
│   │   │   │   ├── SARS-CoV-2_200318.ckp
│   │   │   │   ├── SARS-CoV-2_200318.log
│   │   │   │   ├── SARS-CoV-2_200318.out
│   │   │   │   ├── SARS-CoV-2_200318.part.aic
│   │   │   │   ├── SARS-CoV-2_200318.part.aicc
│   │   │   │   ├── SARS-CoV-2_200318.part.bic
│   │   │   │   ├── SARS-CoV-2_200318.part.txt
│   │   │   │   └── SARS-CoV-2_200318.tree
│   │   │   └── univ => including model test data without using partitioned model
│   │   │       ├── SARS-CoV-2_200318.ckp
│   │   │       ├── SARS-CoV-2_200318.log
│   │   │       ├── SARS-CoV-2_200318.out
│   │   │       └── SARS-CoV-2_200318.tree
│   │   └── DNA
│   │       ├── part
│   │       │   ├── 3rd => including model test data using partitioned model for each ORF and also 1st/2nd and 3rd codon position
│   │       │   │   ├── SARS-CoV-2_200318.ckp
│   │       │   │   ├── SARS-CoV-2_200318.log
│   │       │   │   ├── SARS-CoV-2_200318.out
│   │       │   │   ├── SARS-CoV-2_200318.part.aic
│   │       │   │   ├── SARS-CoV-2_200318.part.aicc
│   │       │   │   ├── SARS-CoV-2_200318.part.bic
│   │       │   │   ├── SARS-CoV-2_200318.part.txt
│   │       │   │   └── SARS-CoV-2_200318.tree
│   │       │   ├── sep => including phylogenetic analysis data using partitioned model for each ORF and also each codon position
│   │       │   │   ├── SARS-CoV-2_200318.ckp
│   │       │   │   ├── SARS-CoV-2_200318.log
│   │       │   │   ├── SARS-CoV-2_200318.out
│   │       │   │   ├── SARS-CoV-2_200318.part.aic
│   │       │   │   ├── SARS-CoV-2_200318.part.aicc
│   │       │   │   ├── SARS-CoV-2_200318.part.bic
│   │       │   │   ├── SARS-CoV-2_200318.part.txt
│   │       │   │   └── SARS-CoV-2_200318.tree
│   │       │   └── uni => including model test data using partitioned model for each ORF
│   │       │       ├── SARS-CoV-2_200318.ckp
│   │       │       ├── SARS-CoV-2_200318.log
│   │       │       ├── SARS-CoV-2_200318.out
│   │       │       ├── SARS-CoV-2_200318.part.aic
│   │       │       ├── SARS-CoV-2_200318.part.aicc
│   │       │       ├── SARS-CoV-2_200318.part.bic
│   │       │       ├── SARS-CoV-2_200318.part.txt
│   │       │       └── SARS-CoV-2_200318.tree
│   │       └── univ
│   │           ├── 3rd => including model test data using partitioned model for each ORF and also 1st/2nd and 3rd codon position
│   │           │   ├── SARS-CoV-2_200318.ckp
│   │           │   ├── SARS-CoV-2_200318.log
│   │           │   ├── SARS-CoV-2_200318.out
│   │           │   ├── SARS-CoV-2_200318.part.aic
│   │           │   ├── SARS-CoV-2_200318.part.aicc
│   │           │   ├── SARS-CoV-2_200318.part.bic
│   │           │   ├── SARS-CoV-2_200318.part.txt
│   │           │   └── SARS-CoV-2_200318.tree
│   │           ├── sep => including model test data using partitioned model for each codon position
│   │           │   ├── SARS-CoV-2_200318.ckp
│   │           │   ├── SARS-CoV-2_200318.log
│   │           │   ├── SARS-CoV-2_200318.out
│   │           │   ├── SARS-CoV-2_200318.part.aic
│   │           │   ├── SARS-CoV-2_200318.part.aicc
│   │           │   ├── SARS-CoV-2_200318.part.bic
│   │           │   ├── SARS-CoV-2_200318.part.txt
│   │           │   └── SARS-CoV-2_200318.tree
│   │           └── uni => including model test data without using partitioned model
│   │               ├── SARS-CoV-2_200318.ckp
│   │               ├── SARS-CoV-2_200318.log
│   │               ├── SARS-CoV-2_200318.out
│   │               └── SARS-CoV-2_200318.tree
│   ├── RAxML-NG
│   │   ├── AA
│   │   │   ├── part => including phylogenetic analysis data using partitioned model for each ORF
│   │   │   │   ├── SARS-CoV-2_200318.0.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.0.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.0.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.0.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.0.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.1.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.1.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.1.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.1.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.1.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.10.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.10.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.10.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.10.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.10.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.11.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.11.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.11.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.11.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.11.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.2.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.2.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.2.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.2.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.2.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.3.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.3.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.3.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.3.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.3.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.4.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.4.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.4.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.4.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.4.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.5.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.5.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.5.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.5.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.5.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.6.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.6.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.6.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.6.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.6.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.7.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.7.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.7.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.7.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.7.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.8.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.8.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.8.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.8.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.8.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.9.raxml.bestModel
│   │   │   │   ├── SARS-CoV-2_200318.9.raxml.bestTree
│   │   │   │   ├── SARS-CoV-2_200318.9.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.9.raxml.mlTrees
│   │   │   │   ├── SARS-CoV-2_200318.9.raxml.startTree
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.0.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.1.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.10.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.11.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.2.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.3.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.4.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.5.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.6.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.7.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.8.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bootstrap.9.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.bsconverge.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.parse.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.raxml.bootstraps
│   │   │   │   ├── SARS-CoV-2_200318.raxml.rba
│   │   │   │   ├── SARS-CoV-2_200318.raxml.reduced.partition
│   │   │   │   ├── SARS-CoV-2_200318.raxml.reduced.phy
│   │   │   │   ├── SARS-CoV-2_200318.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │   │   │   ├── SARS-CoV-2_200318.search.0.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.1.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.10.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.11.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.2.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.3.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.4.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.5.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.6.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.7.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.8.raxml.log
│   │   │   │   ├── SARS-CoV-2_200318.search.9.raxml.log
│   │   │   │   └── SARS-CoV-2_200318.support.raxml.log
│   │   │   └── univ => including phylogenetic analysis data without using partitioned model
│   │   │       ├── SARS-CoV-2_200318.0.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.0.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.0.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.0.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.0.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.1.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.1.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.1.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.1.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.1.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.10.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.10.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.10.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.10.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.10.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.11.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.11.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.11.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.11.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.11.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.2.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.2.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.2.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.2.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.2.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.3.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.3.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.3.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.3.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.3.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.4.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.4.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.4.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.4.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.4.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.5.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.5.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.5.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.5.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.5.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.6.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.6.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.6.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.6.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.6.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.7.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.7.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.7.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.7.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.7.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.8.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.8.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.8.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.8.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.8.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.9.raxml.bestModel
│   │   │       ├── SARS-CoV-2_200318.9.raxml.bestTree
│   │   │       ├── SARS-CoV-2_200318.9.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.9.raxml.mlTrees
│   │   │       ├── SARS-CoV-2_200318.9.raxml.startTree
│   │   │       ├── SARS-CoV-2_200318.bootstrap.0.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.1.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.10.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.11.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.2.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.3.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.4.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.5.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.6.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.7.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.8.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bootstrap.9.raxml.log
│   │   │       ├── SARS-CoV-2_200318.bsconverge.raxml.log
│   │   │       ├── SARS-CoV-2_200318.parse.raxml.log
│   │   │       ├── SARS-CoV-2_200318.raxml.bootstraps
│   │   │       ├── SARS-CoV-2_200318.raxml.rba
│   │   │       ├── SARS-CoV-2_200318.raxml.reduced.phy
│   │   │       ├── SARS-CoV-2_200318.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │   │       ├── SARS-CoV-2_200318.search.0.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.1.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.10.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.11.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.2.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.3.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.4.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.5.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.6.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.7.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.8.raxml.log
│   │   │       ├── SARS-CoV-2_200318.search.9.raxml.log
│   │   │       └── SARS-CoV-2_200318.support.raxml.log
│   │   └── DNA
│   │       ├── part
│   │       │   ├── 3rd => including phylogenetic analysis data using partitioned model for each ORF and also 1st/2nd and 3rd codon position
│   │       │   │   ├── SARS-CoV-2_200318.0.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.0.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.0.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.0.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.0.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.1.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.1.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.1.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.1.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.1.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.10.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.10.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.10.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.10.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.10.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.11.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.11.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.11.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.11.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.11.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.2.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.2.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.2.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.2.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.2.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.3.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.3.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.3.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.3.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.3.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.4.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.4.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.4.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.4.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.4.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.5.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.5.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.5.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.5.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.5.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.6.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.6.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.6.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.6.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.6.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.7.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.7.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.7.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.7.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.7.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.8.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.8.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.8.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.8.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.8.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.9.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.9.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.9.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.9.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.9.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.0.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.1.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.10.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.11.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.2.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.3.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.4.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.5.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.6.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.7.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.8.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.9.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bsconverge.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.parse.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.raxml.rba
│   │       │   │   ├── SARS-CoV-2_200318.raxml.reduced.partition
│   │       │   │   ├── SARS-CoV-2_200318.raxml.reduced.phy
│   │       │   │   ├── SARS-CoV-2_200318.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │       │   │   ├── SARS-CoV-2_200318.search.0.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.1.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.10.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.11.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.2.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.3.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.4.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.5.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.6.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.7.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.8.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.9.raxml.log
│   │       │   │   └── SARS-CoV-2_200318.support.raxml.log
│   │       │   ├── sep => including phylogenetic analysis data using partitioned model for each ORF and also each codon position
│   │       │   │   ├── SARS-CoV-2_200318.0.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.0.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.0.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.0.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.0.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.1.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.1.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.1.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.1.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.1.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.10.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.10.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.10.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.10.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.10.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.11.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.11.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.11.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.11.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.11.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.2.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.2.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.2.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.2.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.2.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.3.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.3.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.3.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.3.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.3.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.4.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.4.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.4.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.4.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.4.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.5.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.5.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.5.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.5.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.5.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.6.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.6.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.6.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.6.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.6.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.7.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.7.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.7.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.7.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.7.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.8.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.8.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.8.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.8.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.8.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.9.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200318.9.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200318.9.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.9.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200318.9.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.0.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.1.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.10.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.11.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.2.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.3.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.4.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.5.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.6.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.7.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.8.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bootstrap.9.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.bsconverge.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.parse.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200318.raxml.rba
│   │       │   │   ├── SARS-CoV-2_200318.raxml.reduced.partition
│   │       │   │   ├── SARS-CoV-2_200318.raxml.reduced.phy
│   │       │   │   ├── SARS-CoV-2_200318.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │       │   │   ├── SARS-CoV-2_200318.search.0.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.1.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.10.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.11.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.2.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.3.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.4.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.5.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.6.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.7.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.8.raxml.log
│   │       │   │   ├── SARS-CoV-2_200318.search.9.raxml.log
│   │       │   │   └── SARS-CoV-2_200318.support.raxml.log
│   │       │   └── uni => including phylogenetic analysis data using partitioned model for each ORF
│   │       │       ├── SARS-CoV-2_200318.0.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.0.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.0.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.0.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.0.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.1.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.1.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.1.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.1.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.1.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.10.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.10.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.10.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.10.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.10.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.11.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.11.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.11.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.11.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.11.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.2.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.2.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.2.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.2.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.2.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.3.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.3.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.3.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.3.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.3.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.4.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.4.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.4.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.4.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.4.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.5.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.5.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.5.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.5.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.5.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.6.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.6.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.6.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.6.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.6.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.7.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.7.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.7.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.7.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.7.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.8.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.8.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.8.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.8.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.8.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.9.raxml.bestModel
│   │       │       ├── SARS-CoV-2_200318.9.raxml.bestTree
│   │       │       ├── SARS-CoV-2_200318.9.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.9.raxml.mlTrees
│   │       │       ├── SARS-CoV-2_200318.9.raxml.startTree
│   │       │       ├── SARS-CoV-2_200318.bootstrap.0.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.1.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.10.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.11.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.2.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.3.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.4.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.5.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.6.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.7.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.8.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bootstrap.9.raxml.log
│   │       │       ├── SARS-CoV-2_200318.bsconverge.raxml.log
│   │       │       ├── SARS-CoV-2_200318.parse.raxml.log
│   │       │       ├── SARS-CoV-2_200318.raxml.bootstraps
│   │       │       ├── SARS-CoV-2_200318.raxml.rba
│   │       │       ├── SARS-CoV-2_200318.raxml.reduced.partition
│   │       │       ├── SARS-CoV-2_200318.raxml.reduced.phy
│   │       │       ├── SARS-CoV-2_200318.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │       │       ├── SARS-CoV-2_200318.search.0.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.1.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.10.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.11.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.2.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.3.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.4.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.5.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.6.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.7.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.8.raxml.log
│   │       │       ├── SARS-CoV-2_200318.search.9.raxml.log
│   │       │       └── SARS-CoV-2_200318.support.raxml.log
│   │       └── univ
│   │           ├── 3rd => including phylogenetic analysis data using partitioned model for 1st/2nd and 3rd codon position
│   │           │   ├── SARS-CoV-2_200318.0.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.0.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.0.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.0.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.0.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.1.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.1.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.1.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.1.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.1.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.10.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.10.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.10.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.10.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.10.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.11.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.11.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.11.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.11.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.11.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.2.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.2.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.2.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.2.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.2.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.3.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.3.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.3.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.3.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.3.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.4.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.4.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.4.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.4.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.4.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.5.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.5.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.5.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.5.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.5.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.6.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.6.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.6.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.6.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.6.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.7.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.7.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.7.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.7.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.7.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.8.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.8.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.8.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.8.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.8.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.9.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.9.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.9.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.9.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.9.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.bootstrap.0.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.1.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.10.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.11.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.2.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.3.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.4.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.5.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.6.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.7.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.8.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.9.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bsconverge.raxml.log
│   │           │   ├── SARS-CoV-2_200318.parse.raxml.log
│   │           │   ├── SARS-CoV-2_200318.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.raxml.rba
│   │           │   ├── SARS-CoV-2_200318.raxml.reduced.partition
│   │           │   ├── SARS-CoV-2_200318.raxml.reduced.phy
│   │           │   ├── SARS-CoV-2_200318.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │           │   ├── SARS-CoV-2_200318.search.0.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.1.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.10.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.11.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.2.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.3.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.4.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.5.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.6.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.7.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.8.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.9.raxml.log
│   │           │   └── SARS-CoV-2_200318.support.raxml.log
│   │           ├── sep => including phylogenetic analysis data using partitioned model for each codon position
│   │           │   ├── SARS-CoV-2_200318.0.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.0.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.0.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.0.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.0.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.1.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.1.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.1.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.1.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.1.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.10.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.10.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.10.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.10.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.10.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.11.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.11.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.11.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.11.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.11.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.2.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.2.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.2.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.2.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.2.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.3.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.3.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.3.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.3.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.3.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.4.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.4.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.4.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.4.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.4.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.5.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.5.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.5.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.5.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.5.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.6.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.6.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.6.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.6.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.6.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.7.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.7.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.7.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.7.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.7.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.8.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.8.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.8.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.8.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.8.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.9.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200318.9.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200318.9.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.9.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200318.9.raxml.startTree
│   │           │   ├── SARS-CoV-2_200318.bootstrap.0.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.1.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.10.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.11.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.2.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.3.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.4.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.5.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.6.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.7.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.8.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bootstrap.9.raxml.log
│   │           │   ├── SARS-CoV-2_200318.bsconverge.raxml.log
│   │           │   ├── SARS-CoV-2_200318.parse.raxml.log
│   │           │   ├── SARS-CoV-2_200318.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200318.raxml.rba
│   │           │   ├── SARS-CoV-2_200318.raxml.reduced.partition
│   │           │   ├── SARS-CoV-2_200318.raxml.reduced.phy
│   │           │   ├── SARS-CoV-2_200318.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │           │   ├── SARS-CoV-2_200318.search.0.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.1.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.10.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.11.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.2.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.3.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.4.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.5.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.6.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.7.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.8.raxml.log
│   │           │   ├── SARS-CoV-2_200318.search.9.raxml.log
│   │           │   └── SARS-CoV-2_200318.support.raxml.log
│   │           └── uni => including phylogenetic analysis data without using partitioned model
│   │               ├── SARS-CoV-2_200318.0.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.0.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.0.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.0.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.0.raxml.startTree
│   │               ├── SARS-CoV-2_200318.1.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.1.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.1.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.1.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.1.raxml.startTree
│   │               ├── SARS-CoV-2_200318.10.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.10.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.10.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.10.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.10.raxml.startTree
│   │               ├── SARS-CoV-2_200318.11.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.11.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.11.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.11.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.11.raxml.startTree
│   │               ├── SARS-CoV-2_200318.2.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.2.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.2.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.2.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.2.raxml.startTree
│   │               ├── SARS-CoV-2_200318.3.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.3.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.3.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.3.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.3.raxml.startTree
│   │               ├── SARS-CoV-2_200318.4.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.4.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.4.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.4.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.4.raxml.startTree
│   │               ├── SARS-CoV-2_200318.5.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.5.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.5.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.5.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.5.raxml.startTree
│   │               ├── SARS-CoV-2_200318.6.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.6.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.6.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.6.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.6.raxml.startTree
│   │               ├── SARS-CoV-2_200318.7.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.7.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.7.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.7.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.7.raxml.startTree
│   │               ├── SARS-CoV-2_200318.8.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.8.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.8.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.8.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.8.raxml.startTree
│   │               ├── SARS-CoV-2_200318.9.raxml.bestModel
│   │               ├── SARS-CoV-2_200318.9.raxml.bestTree
│   │               ├── SARS-CoV-2_200318.9.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.9.raxml.mlTrees
│   │               ├── SARS-CoV-2_200318.9.raxml.startTree
│   │               ├── SARS-CoV-2_200318.bootstrap.0.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.1.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.10.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.11.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.2.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.3.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.4.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.5.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.6.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.7.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.8.raxml.log
│   │               ├── SARS-CoV-2_200318.bootstrap.9.raxml.log
│   │               ├── SARS-CoV-2_200318.bsconverge.raxml.log
│   │               ├── SARS-CoV-2_200318.parse.raxml.log
│   │               ├── SARS-CoV-2_200318.raxml.bootstraps
│   │               ├── SARS-CoV-2_200318.raxml.rba
│   │               ├── SARS-CoV-2_200318.raxml.reduced.phy
│   │               ├── SARS-CoV-2_200318.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │               ├── SARS-CoV-2_200318.search.0.raxml.log
│   │               ├── SARS-CoV-2_200318.search.1.raxml.log
│   │               ├── SARS-CoV-2_200318.search.10.raxml.log
│   │               ├── SARS-CoV-2_200318.search.11.raxml.log
│   │               ├── SARS-CoV-2_200318.search.2.raxml.log
│   │               ├── SARS-CoV-2_200318.search.3.raxml.log
│   │               ├── SARS-CoV-2_200318.search.4.raxml.log
│   │               ├── SARS-CoV-2_200318.search.5.raxml.log
│   │               ├── SARS-CoV-2_200318.search.6.raxml.log
│   │               ├── SARS-CoV-2_200318.search.7.raxml.log
│   │               ├── SARS-CoV-2_200318.search.8.raxml.log
│   │               ├── SARS-CoV-2_200318.search.9.raxml.log
│   │               └── SARS-CoV-2_200318.support.raxml.log
│   ├── SARS-CoV-2_200318.aln.concat.faa
│   └── SARS-CoV-2_200318.aln.concat.fna
├── ref => including reference open reading frame annotation data
│   ├── MN908947.orf.bed
│   ├── MN908947.orf.faa
│   └── MN908947.orf.fna
└── script => including in-house script files
    ├── LICENSE
    ├── all-in-one_analysis.sh
    ├── parallel_msa.pl
    ├── parallel_phylogeny.pl
    ├── phylogenetic_analysis.sh
    ├── translator.pl
    └── variable_sites_extractor.pl
```

## Meta data of genomes
| Accession No.   | Database name   | Collection date | Country     | State/City    | Notes                                                                  |
| --------------- | --------------- | --------------- | ----------- | ------------- | ---------------------------------------------------------------------- |
| MT126808        | Genbank         | 28-Feb-2020     | Brazil      | Sao Paulo     | Traveler from Switzerland and Italy (Milan) to Brazil                  |
| MT123290        | Genbank         | 05-Feb-2020     | China       | Guangzhou     |                                                                        |
| MT093571        | Genbank         | 07-Feb-2020     | Sweden      |               |                                                                        |
| MT066176        | Genbank         | 05-Feb-2020     | Taiwan      | Taipei        |                                                                        |
| MT066175        | Genbank         | 31-Jan-2020     | Taiwan      | Taipei        |                                                                        |
| MT049951        | Genbank         | 17-Jan-2020     | China       | Yunnan        |                                                                        |
| MT163721        | Genbank         | 01-Mar-2020     | USA         | Washington    |                                                                        |
| MT163720        | Genbank         | 01-Mar-2020     | USA         | Washington    |                                                                        |
| MT163719        | Genbank         | 01-Mar-2020     | USA         | Washington    |                                                                        |
| MT163718        | Genbank         | 29-Feb-2020     | USA         | Washington    |                                                                        |
| MT163717        | Genbank         | 28-Feb-2020     | USA         | Washington    |                                                                        |
| MT163716        | Genbank         | 27-Feb-2020     | USA         | Washington    |                                                                        |
| MT066156        | Genbank         | 30-Jan-2020     | Italy       |               |                                                                        |
| LC528233        | Genbank         | 10-Feb-2020     | Japan       | Kanagawa      | Diamond Princess cruise ship?                                          |
| LC528232        | Genbank         | 10-Feb-2020     | Japan       | Kanagawa      | Diamond Princess cruise ship?                                          |
| LC529905        | Genbank         |    Jan-2020     | Japan       | Tokyo         |                                                                        |
| MT123293        | Genbank         | 29-Jan-2020     | China       | Guangzhou     |                                                                        |
| MT123292        | Genbank         | 27-Jan-2020     | China       | Guangzhou     |                                                                        |
| MT123291        | Genbank         | 29-Jan-2020     | China       | Guangzhou     |                                                                        |
| MT093631        | Genbank         | 08-Jan-2020     | China       | Wuhan         |                                                                        |
| MT121215        | Genbank         | 02-Feb-2020     | China       | Shanghai      |                                                                        |
| MT050493        | Genbank         | 31-Jan-2020     | India       | Kerala        |                                                                        |
| MT012098        | Genbank         | 27-Jan-2020     | India       | Kerala        |                                                                        |
| MT152824        | Genbank         | 24-Feb-2020     | USA         | Washington    |                                                                        |
| MT135044        | Genbank         | 28-Jan-2020     | China       | Beijing       |                                                                        |
| MT135043        | Genbank         | 28-Jan-2020     | China       | Beijing       |                                                                        |
| MT135042        | Genbank         | 28-Jan-2020     | China       | Beijing       |                                                                        |
| MT135041        | Genbank         | 26-Jan-2020     | China       | Beijing       |                                                                        |
| MT188341        | Genbank         | 05-Mar-2020     | USA         | Minnesota     |                                                                        |
| MT188340        | Genbank         | 07-Mar-2020     | USA         | Minnesota     |                                                                        |
| MT188339        | Genbank         | 09-Mar-2020     | USA         | Minnesota     |                                                                        |
| MT184913        | Genbank         | 24-Feb-2020     | USA         |               | USA-CruiseA-26                                                         |
| MT184912        | Genbank         | 17-Feb-2020     | USA         |               | USA-CruiseA-25                                                         |
| MT184911        | Genbank         | 17-Feb-2020     | USA         |               | USA-CruiseA-24                                                         |
| MT184910        | Genbank         | 18-Feb-2020     | USA         |               | USA-CruiseA-23                                                         |
| MT184909        | Genbank         | 21-Feb-2020     | USA         |               | USA-CruiseA-22                                                         |
| MT184908        | Genbank         | 21-Feb-2020     | USA         |               | USA-CruiseA-21                                                         |
| MT184907        | Genbank         | 18-Feb-2020     | USA         |               | USA-CruiseA-19                                                         |
| LR757998        | Genbank         | 26-Dec-2019     | China       | Wuhan         | synonym: CNA0007332                                                    |
| LR757997        | Genbank         | 31-Dec-2019     | China       | Wuhan         | synonym: CNA0007333                                                    |
| LR757996        | Genbank         | 01-Jan-2020     | China       | Wuhan         | synonym: CNA0007334                                                    |
| LR757995        | Genbank         | 05-Jan-2020     | China       | Wuhan         | synonym: CNA0007335                                                    |
| MT159722        | Genbank         | 21-Feb-2020     | USA         |               | USA-CruiseA-6                                                          |
| MT159721        | Genbank         | 21-Feb-2020     | USA         |               | USA-CruiseA-5                                                          |
| MT159720        | Genbank         | 21-Feb-2020     | USA         |               | USA-CruiseA-4                                                          |
| MT159719        | Genbank         | 18-Feb-2020     | USA         |               | USA-CruiseA-3                                                          |
| MT159718        | Genbank         | 18-Feb-2020     | USA         |               | USA-CruiseA-2                                                          |
| MT159717        | Genbank         | 17-Feb-2020     | USA         |               | USA-CruiseA-1                                                          |
| MT159716        | Genbank         | 24-Feb-2020     | USA         |               | USA-CruiseA-18                                                         |
| MT159715        | Genbank         | 24-Feb-2020     | USA         |               | USA-CruiseA-17                                                         |
| MT159714        | Genbank         | 18-Feb-2020     | USA         |               | USA-CruiseA-16                                                         |
| MT159713        | Genbank         | 18-Feb-2020     | USA         |               | USA-CruiseA-15                                                         |
| MT159712        | Genbank         | 25-Feb-2020     | USA         |               | USA-CruiseA-14                                                         |
| MT159711        | Genbank         | 20-Feb-2020     | USA         |               | USA-CruiseA-13                                                         |
| MT159710        | Genbank         | 17-Feb-2020     | USA         |               | USA-CruiseA-9                                                          |
| MT159709        | Genbank         | 20-Feb-2020     | USA         |               | USA-CruiseA-12                                                         |
| MT159708        | Genbank         | 17-Feb-2020     | USA         |               | USA-CruiseA-11                                                         |
| MT159707        | Genbank         | 17-Feb-2020     | USA         |               | USA-CruiseA-10                                                         |
| MT159706        | Genbank         | 17-Feb-2020     | USA         |               | USA-CruiseA-8                                                          |
| MT159705        | Genbank         | 17-Feb-2020     | USA         |               | USA-CruiseA-7                                                          |
| MT118835        | Genbank         | 23-Feb-2020     | USA         | California    |                                                                        |
| MT106054        | Genbank         | 11-Feb-2020     | USA         | Texas         |                                                                        |
| MT106053        | Genbank         | 10-Feb-2020     | USA         | California    |                                                                        |
| MT106052        | Genbank         | 06-Feb-2020     | USA         | California    |                                                                        |
| MT072688        | Genbank         | 13-Jan-2020     | Nepal       | Kathmandu     |                                                                        |
| MT044258        | Genbank         | 27-Jan-2020     | USA         | California    |                                                                        |
| MT044257        | Genbank         | 28-Jan-2020     | USA         | Illinois      |                                                                        |
| MT039888        | Genbank         | 29-Jan-2020     | USA         | Massachusetts |                                                                        |
| MT039887        | Genbank         | 31-Jan-2020     | USA         | Wisconsin     |                                                                        |
| MT039890        | Genbank         |    Jan-2020     | South Korea |               |                                                                        |
| MT039873        | Genbank         | 20-Jan-2020     | China       | Hangzhou      | synonym: GWHABKS00000000                                               |
| MT027064        | Genbank         | 29-Jan-2020     | USA         | California    |                                                                        |
| MT027063        | Genbank         | 29-Jan-2020     | USA         | California    |                                                                        |
| MT027062        | Genbank         | 29-Jan-2020     | USA         | California    |                                                                        |
| MT020881        | Genbank         | 25-Jan-2020     | USA         | Washington    |                                                                        |
| MT020880        | Genbank         | 25-Jan-2020     | USA         | Washington    |                                                                        |
| MT020781        | Genbank         | 29-Jan-2020     | Finland     | Lapland       |                                                                        |
| MT019533        | Genbank         | 01-Jan-2020     | China       | Wuhan         | synonym: GWHABKJ00000000                                               |
| MT019532        | Genbank         | 30-Dec-2019     | China       | Wuhan         | synonym: GWHABKI00000000                                               |
| MT019531        | Genbank         | 30-Dec-2019     | China       | Wuhan         | synonym: GWHABKH00000000                                               |
| MT019530        | Genbank         | 30-Dec-2019     | China       | Wuhan         | synonym: GWHABKG00000000                                               |
| MT019529        | Genbank         | 23-Dec-2019     | China       | Wuhan         | synonym: GWHABKF00000000                                               |
| MT007544        | Genbank         | 25-Jan-2020     | Australia   | Victoria      |                                                                        |
| MN996531        | Genbank         | 30-Dec-2019     | China       | Wuhan         | synonym: GWHABKO00000000                                               |
| MN996530        | Genbank         | 30-Dec-2019     | China       | Wuhan         | synonym: GWHABKN00000000                                               |
| MN996529        | Genbank         | 30-Dec-2019     | China       | Wuhan         | synonym: GWHABKM00000000                                               |
| MN996528        | Genbank         | 30-Dec-2019     | China       | Wuhan         | synonym: GWHABKL00000000                                               |
| MN996527        | Genbank         | 30-Dec-2019     | China       | Wuhan         | synonym: GWHABKK00000000                                               |
| MN997409        | Genbank         | 22-Jan-2020     | USA         | Arizona       |                                                                        |
| MN994468        | Genbank         | 22-Jan-2020     | USA         | California    |                                                                        |
| MN994467        | Genbank         | 23-Jan-2020     | USA         | California    |                                                                        |
| MN988713        | Genbank         | 21-Jan-2020     | USA         | Illinois      |                                                                        |
| MN988669        | Genbank         | 02-Jan-2020     | China       | Wuhan         |                                                                        |
| MN988668        | Genbank         | 02-Jan-2020     | China       | Wuhan         |                                                                        |
| MN985325        | Genbank         | 19-Jan-2020     | USA         | Washington    |                                                                        |
| MN975262        | Genbank         | 11-Jan-2020     | China       | Shenzhen      | Traveler from Shenzhen to Wuhan (10 years old)                         |
| MN938384        | Genbank         | 10-Jan-2020     | China       | Shenzhen      | Traveler from Shenzhen to Wuhan (66 years old)                         |
| MN908947        | Genbank         | 30-Dec-2019     | China       | Wuhan         |                                                                        |
| LC521925        | Genbank         | 25-Jan-2020     | Japan       | Aichi         |                                                                        |
| LC522975        | Genbank         | 31-Jan-2020     | Japan       | Tokyo         |                                                                        |
| LC522974        | Genbank         | 31-Jan-2020     | Japan       | Tokyo         |                                                                        |
| LC522973        | Genbank         | 29-Jan-2020     | Japan       | Tokyo         |                                                                        |
| LC522972        | Genbank         | 29-Jan-2020     | Japan       | Kyoto         |                                                                        |
| MN996532        | Genbank         | 24-Jul-2013     | China       |               | Bat (Rhinolophus affinis) coronavirus RaTG13, synonym: GWHABKP00000000 |
| MG772933        | Genbank         |    Feb-2017     | China       |               | Bat (Rhinolophus sinicus) SARS-like coronavirus                        |

Meta data were supplemented from National Genomics Data Center (https://bigd.big.ac.cn/search).

## Summary of maximum-likelihood phylogenetic analyses
| No. | Data type | Partition                                        | Final LogLikelihood | AIC score     | AICc score    | BIC socre     | # Free parameters |
| --- | --------- | ------------------------------------------------ | ------------------- | ------------- | ------------- | ------------- | ----------------- |
| 1   | DNA       | No partition                                     | -59232.477912       | 118772.955823 | 118774.602428 | 120048.097626 | 154               |
| 2   | DNA       | Separate 3rd codon position and others           | -56820.984638       | 113969.969277 | 113971.836578 | 115327.912496 | 164               |
| 3   | DNA       | Separate each codon position                     | -56410.587382       | 113165.174764 | 113167.228672 | 114589.359115 | 172               |
| 4   | DNA       | Separate each ORF                                | -59780.961028       | 119951.922056 | 119954.562288 | 121566.549664 | 195               |
| 5   | DNA       | Separate each ORF, 3rd codon position and others | -56467.248921       | 113398.497841 | 113402.236800 | 115319.490688 | 232               |
| 6   | DNA       | Separate each ORF, each codon position           | -56095.493798       | 112712.987597 | 112717.722209 | 114874.104549 | 261               |
| 7   | AA        | No partition                                     | -33424.161700       |  67178.323399 |  67184.065538 |  68363.105822 | 165               |
| 8   | AA        | Separate each ORF                                | -33354.346518       |  67068.693035 |  67075.533980 |  68361.182951 | 180               |

## Release notes
| Release Date | Contents                                                                                     |
| ------------ | -------------------------------------------------------------------------------------------- |
| 28-Feb-2020  | initial release                                                                              |
| 12-Mar-2020  | update genome sequence data, improve parallelization efficiency and usability of the scripts |
| 18-Mar-2020  | update genome sequence data                                                                  |
| 20-Mar-2020  | update genome sequence data, remove USA-CruiseA data from the analyses                       |

## License
All in-house scripts in `script/` direcory are released under the MIT license.
See also `script/LICENSE`.
