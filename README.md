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
| FATE         | 2.8.0        | https://github.com/Hikoyu/FATE                       |
| FAMSA        | 1.5.12       | https://github.com/refresh-bio/FAMSA                 |
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
$ rm ref/*.orf.f?a genome/*.fna.* fate/*.bed famsa/*.fna phylogeny/*.* phylogeny/*/DNA/*/*/*.* phylogeny/*/AA/*/*.*
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
├── famsa => including open reading frame sequence data and multiple sequence alignment data
│   ├── SARS-CoV-2_200407.E.aln.fna
│   ├── SARS-CoV-2_200407.E.fna
│   ├── SARS-CoV-2_200407.M.aln.fna
│   ├── SARS-CoV-2_200407.M.fna
│   ├── SARS-CoV-2_200407.N.aln.fna
│   ├── SARS-CoV-2_200407.N.fna
│   ├── SARS-CoV-2_200407.ORF10.aln.fna
│   ├── SARS-CoV-2_200407.ORF10.fna
│   ├── SARS-CoV-2_200407.ORF3a.aln.fna
│   ├── SARS-CoV-2_200407.ORF3a.fna
│   ├── SARS-CoV-2_200407.ORF6.aln.fna
│   ├── SARS-CoV-2_200407.ORF6.fna
│   ├── SARS-CoV-2_200407.ORF7a.aln.fna
│   ├── SARS-CoV-2_200407.ORF7a.fna
│   ├── SARS-CoV-2_200407.ORF8.aln.fna
│   ├── SARS-CoV-2_200407.ORF8.fna
│   ├── SARS-CoV-2_200407.S.aln.fna
│   ├── SARS-CoV-2_200407.S.fna
│   ├── SARS-CoV-2_200407.orf1ab_D.aln.fna
│   ├── SARS-CoV-2_200407.orf1ab_D.fna
│   ├── SARS-CoV-2_200407.orf1ab_U.aln.fna
│   ├── SARS-CoV-2_200407.orf1ab_U.fna
│   ├── msa_list.txt
│   ├── parsimony-informative_site_position_list.txt
│   ├── parsimony-informative_sites.txt
│   ├── variable_site_position_list.txt
│   └── variable_sites.txt
├── fate
│   └── SARS-CoV-2_200407.orf.bed => open reading frame annotation data
├── genome => including SARS-CoV-2 genome sequence data
│   ├── SARS-CoV-2_200407.fna
│   ├── SARS-CoV-2_200407.fna.fai
│   ├── SARS-CoV-2_200407.fna.nhr
│   ├── SARS-CoV-2_200407.fna.nin
│   ├── SARS-CoV-2_200407.fna.nsq
│   └── sample_list.txt
├── phylogeny
│   ├── ModelTest-NG
│   │   ├── AA
│   │   └── DNA
│   │       ├── part
│   │       │   ├── 3rd => including model test data using partitioned model for each ORF and also 1st/2nd and 3rd codon position
│   │       │   │   ├── SARS-CoV-2_200407.ckp
│   │       │   │   ├── SARS-CoV-2_200407.log
│   │       │   │   ├── SARS-CoV-2_200407.out
│   │       │   │   ├── SARS-CoV-2_200407.part.aic
│   │       │   │   ├── SARS-CoV-2_200407.part.aicc
│   │       │   │   ├── SARS-CoV-2_200407.part.bic
│   │       │   │   ├── SARS-CoV-2_200407.part.txt
│   │       │   │   └── SARS-CoV-2_200407.tree
│   │       │   ├── sep => including phylogenetic analysis data using partitioned model for each ORF and also each codon position
│   │       │   │   ├── SARS-CoV-2_200407.ckp
│   │       │   │   ├── SARS-CoV-2_200407.log
│   │       │   │   ├── SARS-CoV-2_200407.out
│   │       │   │   ├── SARS-CoV-2_200407.part.aic
│   │       │   │   ├── SARS-CoV-2_200407.part.aicc
│   │       │   │   ├── SARS-CoV-2_200407.part.bic
│   │       │   │   ├── SARS-CoV-2_200407.part.txt
│   │       │   │   └── SARS-CoV-2_200407.tree
│   │       │   └── uni => including model test data using partitioned model for each ORF
│   │       └── univ
│   │           ├── 3rd => including model test data using partitioned model for each ORF and also 1st/2nd and 3rd codon position
│   │           │   ├── SARS-CoV-2_200407.ckp
│   │           │   ├── SARS-CoV-2_200407.log
│   │           │   ├── SARS-CoV-2_200407.out
│   │           │   ├── SARS-CoV-2_200407.part.aic
│   │           │   ├── SARS-CoV-2_200407.part.aicc
│   │           │   ├── SARS-CoV-2_200407.part.bic
│   │           │   ├── SARS-CoV-2_200407.part.txt
│   │           │   └── SARS-CoV-2_200407.tree
│   │           ├── sep => including model test data using partitioned model for each codon position
│   │           │   ├── SARS-CoV-2_200407.ckp
│   │           │   ├── SARS-CoV-2_200407.log
│   │           │   ├── SARS-CoV-2_200407.out
│   │           │   ├── SARS-CoV-2_200407.part.aic
│   │           │   ├── SARS-CoV-2_200407.part.aicc
│   │           │   ├── SARS-CoV-2_200407.part.bic
│   │           │   ├── SARS-CoV-2_200407.part.txt
│   │           │   └── SARS-CoV-2_200407.tree
│   │           └── uni => including model test data without using partitioned model
│   │               ├── SARS-CoV-2_200407.ckp
│   │               ├── SARS-CoV-2_200407.log
│   │               ├── SARS-CoV-2_200407.out
│   │               └── SARS-CoV-2_200407.tree
│   ├── RAxML-NG
│   │   ├── AA
│   │   └── DNA
│   │       ├── part
│   │       │   ├── 3rd => including phylogenetic analysis data using partitioned model for each ORF and also 1st/2nd and 3rd codon position
│   │       │   │   ├── SARS-CoV-2_200407.0.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.0.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.0.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.0.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.0.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.1.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.1.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.1.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.1.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.1.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.10.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.10.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.10.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.10.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.10.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.11.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.11.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.11.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.11.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.11.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.2.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.2.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.2.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.2.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.2.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.3.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.3.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.3.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.3.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.3.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.4.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.4.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.4.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.4.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.4.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.5.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.5.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.5.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.5.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.5.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.6.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.6.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.6.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.6.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.6.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.7.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.7.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.7.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.7.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.7.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.8.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.8.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.8.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.8.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.8.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.9.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.9.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.9.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.9.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.9.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.0.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.1.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.10.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.11.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.2.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.3.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.4.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.5.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.6.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.7.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.8.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.9.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bsconverge.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.parse.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.raxml.rba
│   │       │   │   ├── SARS-CoV-2_200407.raxml.reduced.partition
│   │       │   │   ├── SARS-CoV-2_200407.raxml.reduced.phy
│   │       │   │   ├── SARS-CoV-2_200407.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │       │   │   ├── SARS-CoV-2_200407.search.0.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.1.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.10.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.11.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.2.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.3.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.4.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.5.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.6.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.7.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.8.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.9.raxml.log
│   │       │   │   └── SARS-CoV-2_200407.support.raxml.log
│   │       │   ├── sep => including phylogenetic analysis data using partitioned model for each ORF and also each codon position
│   │       │   │   ├── SARS-CoV-2_200407.0.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.0.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.0.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.0.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.0.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.1.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.1.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.1.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.1.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.1.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.10.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.10.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.10.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.10.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.10.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.11.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.11.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.11.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.11.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.11.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.2.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.2.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.2.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.2.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.2.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.3.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.3.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.3.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.3.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.3.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.4.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.4.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.4.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.4.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.4.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.5.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.5.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.5.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.5.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.5.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.6.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.6.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.6.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.6.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.6.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.7.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.7.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.7.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.7.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.7.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.8.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.8.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.8.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.8.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.8.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.9.raxml.bestModel
│   │       │   │   ├── SARS-CoV-2_200407.9.raxml.bestTree
│   │       │   │   ├── SARS-CoV-2_200407.9.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.9.raxml.mlTrees
│   │       │   │   ├── SARS-CoV-2_200407.9.raxml.startTree
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.0.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.1.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.10.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.11.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.2.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.3.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.4.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.5.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.6.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.7.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.8.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bootstrap.9.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.bsconverge.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.parse.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.raxml.bootstraps
│   │       │   │   ├── SARS-CoV-2_200407.raxml.rba
│   │       │   │   ├── SARS-CoV-2_200407.raxml.reduced.partition
│   │       │   │   ├── SARS-CoV-2_200407.raxml.reduced.phy
│   │       │   │   ├── SARS-CoV-2_200407.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │       │   │   ├── SARS-CoV-2_200407.search.0.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.1.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.10.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.11.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.2.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.3.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.4.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.5.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.6.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.7.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.8.raxml.log
│   │       │   │   ├── SARS-CoV-2_200407.search.9.raxml.log
│   │       │   │   └── SARS-CoV-2_200407.support.raxml.log
│   │       │   └── uni => including phylogenetic analysis data using partitioned model for each ORF
│   │       └── univ
│   │           ├── 3rd => including phylogenetic analysis data using partitioned model for 1st/2nd and 3rd codon position
│   │           │   ├── SARS-CoV-2_200407.0.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.0.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.0.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.0.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.0.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.1.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.1.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.1.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.1.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.1.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.10.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.10.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.10.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.10.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.10.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.11.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.11.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.11.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.11.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.11.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.2.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.2.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.2.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.2.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.2.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.3.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.3.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.3.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.3.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.3.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.4.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.4.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.4.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.4.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.4.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.5.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.5.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.5.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.5.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.5.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.6.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.6.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.6.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.6.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.6.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.7.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.7.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.7.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.7.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.7.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.8.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.8.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.8.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.8.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.8.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.9.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.9.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.9.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.9.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.9.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.bootstrap.0.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.1.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.10.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.11.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.2.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.3.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.4.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.5.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.6.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.7.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.8.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.9.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bsconverge.raxml.log
│   │           │   ├── SARS-CoV-2_200407.parse.raxml.log
│   │           │   ├── SARS-CoV-2_200407.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.raxml.rba
│   │           │   ├── SARS-CoV-2_200407.raxml.reduced.partition
│   │           │   ├── SARS-CoV-2_200407.raxml.reduced.phy
│   │           │   ├── SARS-CoV-2_200407.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │           │   ├── SARS-CoV-2_200407.search.0.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.1.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.10.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.11.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.2.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.3.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.4.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.5.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.6.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.7.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.8.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.9.raxml.log
│   │           │   └── SARS-CoV-2_200407.support.raxml.log
│   │           ├── sep => including phylogenetic analysis data using partitioned model for each codon position
│   │           │   ├── SARS-CoV-2_200407.0.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.0.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.0.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.0.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.0.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.1.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.1.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.1.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.1.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.1.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.10.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.10.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.10.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.10.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.10.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.11.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.11.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.11.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.11.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.11.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.2.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.2.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.2.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.2.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.2.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.3.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.3.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.3.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.3.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.3.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.4.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.4.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.4.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.4.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.4.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.5.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.5.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.5.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.5.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.5.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.6.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.6.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.6.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.6.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.6.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.7.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.7.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.7.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.7.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.7.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.8.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.8.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.8.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.8.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.8.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.9.raxml.bestModel
│   │           │   ├── SARS-CoV-2_200407.9.raxml.bestTree
│   │           │   ├── SARS-CoV-2_200407.9.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.9.raxml.mlTrees
│   │           │   ├── SARS-CoV-2_200407.9.raxml.startTree
│   │           │   ├── SARS-CoV-2_200407.bootstrap.0.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.1.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.10.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.11.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.2.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.3.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.4.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.5.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.6.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.7.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.8.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bootstrap.9.raxml.log
│   │           │   ├── SARS-CoV-2_200407.bsconverge.raxml.log
│   │           │   ├── SARS-CoV-2_200407.parse.raxml.log
│   │           │   ├── SARS-CoV-2_200407.raxml.bootstraps
│   │           │   ├── SARS-CoV-2_200407.raxml.rba
│   │           │   ├── SARS-CoV-2_200407.raxml.reduced.partition
│   │           │   ├── SARS-CoV-2_200407.raxml.reduced.phy
│   │           │   ├── SARS-CoV-2_200407.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │           │   ├── SARS-CoV-2_200407.search.0.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.1.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.10.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.11.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.2.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.3.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.4.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.5.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.6.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.7.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.8.raxml.log
│   │           │   ├── SARS-CoV-2_200407.search.9.raxml.log
│   │           │   └── SARS-CoV-2_200407.support.raxml.log
│   │           └── uni => including phylogenetic analysis data without using partitioned model
│   │               ├── SARS-CoV-2_200407.0.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.0.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.0.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.0.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.0.raxml.startTree
│   │               ├── SARS-CoV-2_200407.1.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.1.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.1.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.1.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.1.raxml.startTree
│   │               ├── SARS-CoV-2_200407.10.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.10.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.10.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.10.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.10.raxml.startTree
│   │               ├── SARS-CoV-2_200407.11.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.11.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.11.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.11.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.11.raxml.startTree
│   │               ├── SARS-CoV-2_200407.2.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.2.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.2.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.2.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.2.raxml.startTree
│   │               ├── SARS-CoV-2_200407.3.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.3.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.3.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.3.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.3.raxml.startTree
│   │               ├── SARS-CoV-2_200407.4.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.4.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.4.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.4.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.4.raxml.startTree
│   │               ├── SARS-CoV-2_200407.5.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.5.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.5.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.5.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.5.raxml.startTree
│   │               ├── SARS-CoV-2_200407.6.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.6.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.6.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.6.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.6.raxml.startTree
│   │               ├── SARS-CoV-2_200407.7.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.7.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.7.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.7.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.7.raxml.startTree
│   │               ├── SARS-CoV-2_200407.8.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.8.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.8.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.8.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.8.raxml.startTree
│   │               ├── SARS-CoV-2_200407.9.raxml.bestModel
│   │               ├── SARS-CoV-2_200407.9.raxml.bestTree
│   │               ├── SARS-CoV-2_200407.9.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.9.raxml.mlTrees
│   │               ├── SARS-CoV-2_200407.9.raxml.startTree
│   │               ├── SARS-CoV-2_200407.bootstrap.0.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.1.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.10.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.11.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.2.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.3.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.4.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.5.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.6.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.7.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.8.raxml.log
│   │               ├── SARS-CoV-2_200407.bootstrap.9.raxml.log
│   │               ├── SARS-CoV-2_200407.bsconverge.raxml.log
│   │               ├── SARS-CoV-2_200407.parse.raxml.log
│   │               ├── SARS-CoV-2_200407.raxml.bootstraps
│   │               ├── SARS-CoV-2_200407.raxml.rba
│   │               ├── SARS-CoV-2_200407.raxml.reduced.phy
│   │               ├── SARS-CoV-2_200407.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │               ├── SARS-CoV-2_200407.search.0.raxml.log
│   │               ├── SARS-CoV-2_200407.search.1.raxml.log
│   │               ├── SARS-CoV-2_200407.search.10.raxml.log
│   │               ├── SARS-CoV-2_200407.search.11.raxml.log
│   │               ├── SARS-CoV-2_200407.search.2.raxml.log
│   │               ├── SARS-CoV-2_200407.search.3.raxml.log
│   │               ├── SARS-CoV-2_200407.search.4.raxml.log
│   │               ├── SARS-CoV-2_200407.search.5.raxml.log
│   │               ├── SARS-CoV-2_200407.search.6.raxml.log
│   │               ├── SARS-CoV-2_200407.search.7.raxml.log
│   │               ├── SARS-CoV-2_200407.search.8.raxml.log
│   │               ├── SARS-CoV-2_200407.search.9.raxml.log
│   │               └── SARS-CoV-2_200407.support.raxml.log
│   ├── SARS-CoV-2_200407.aln.concat.faa
│   └── SARS-CoV-2_200407.aln.concat.fna
├── ref => including reference open reading frame annotation data
│   ├── MN908947.orf.bed
│   ├── MN908947.orf.faa
│   └── MN908947.orf.fna
└── script
    ├── LICENSE
    ├── all-in-one_analysis.sh
    ├── codon_based_msa.pl
    ├── parallel_phylogeny.pl
    ├── phylogenetic_analysis.sh
    ├── translator.pl
    └── variable_sites_extractor.pl
```

## Meta data of genomes
| Accession No.   | Database name   | Collection date | Country     | State/City         | Notes                                                                  |
| --------------- | --------------- | --------------- | ----------- | ------------------ | ---------------------------------------------------------------------- |
| MT126808        | Genbank         | 28-Feb-2020     | Brazil      | Sao Paulo          | Traveler from Switzerland and Italy (Milan) to Brazil                  |
| MT123290        | Genbank         | 05-Feb-2020     | China       | Guangzhou          |                                                                        |
| MT093571        | Genbank         | 07-Feb-2020     | Sweden      |                    |                                                                        |
| MT066176        | Genbank         | 05-Feb-2020     | Taiwan      | Taipei             |                                                                        |
| MT066175        | Genbank         | 31-Jan-2020     | Taiwan      | Taipei             |                                                                        |
| MT049951        | Genbank         | 17-Jan-2020     | China       | Yunnan             |                                                                        |
| MT276331        | Genbank         | 29-Feb-2020     | USA         | Texas              |                                                                        |
| MT276330        | Genbank         | 28-Feb-2020     | USA         | Florida            |                                                                        |
| MT276329        | Genbank         | 28-Feb-2020     | USA         | Florida            |                                                                        |
| MT276328        | Genbank         | 27-Feb-2020     | USA         | Oregon             |                                                                        |
| MT276327        | Genbank         | 29-Feb-2020     | USA         | Georgia            |                                                                        |
| MT276326        | Genbank         | 29-Feb-2020     | USA         | Georgia            |                                                                        |
| MT276325        | Genbank         | 27-Feb-2020     | USA         | Washington         |                                                                        |
| MT276324        | Genbank         | 26-Feb-2020     | USA         | California         |                                                                        |
| MT276323        | Genbank         | 28-Feb-2020     | USA         | Rhode Island       |                                                                        |
| MT263074        | Genbank         | 10-Mar-2020     | Peru        |                    |                                                                        |
| MT256918        | Genbank         | 06-Mar-2020     | Spain       | Valencia           |                                                                        |
| MT256917        | Genbank         | 02-Mar-2020     | Spain       | Valencia           |                                                                        |
| LC534419        | Genbank         | 09-Mar-2020     | Japan       | Kanagawa           |                                                                        |
| LC534418        | Genbank         | 14-Feb-2020     | Japan       | Kanagawa           | Diamond Princess cruise ship?                                          |
| MT198652        | Genbank         | 05-Mar-2020     | Spain       | Valencia           |                                                                        |
| MT226610        | Genbank         | 20-Jan-2020     | China       |                    |                                                                        |
| MT233523        | Genbank         | 04-Mar-2020     | Spain       | Valencia           |                                                                        |
| MT233522        | Genbank         | 02-Mar-2020     | Spain       | Valencia           |                                                                        |
| MT233521        | Genbank         | 27-Feb-2020     | Spain       | Valencia           |                                                                        |
| MT233520        | Genbank         | 26-Feb-2020     | Spain       | Valencia           |                                                                        |
| MT233519        | Genbank         | 27-Feb-2020     | Spain       | Valencia           |                                                                        |
| MT198653        | Genbank         | 08-Mar-2020     | Spain       | Valencia           |                                                                        |
| MT198651        | Genbank         | 04-Mar-2020     | Spain       | Valencia           |                                                                        |
| MT163721        | Genbank         | 01-Mar-2020     | USA         | Washington         |                                                                        |
| MT163720        | Genbank         | 01-Mar-2020     | USA         | Washington         |                                                                        |
| MT163719        | Genbank         | 01-Mar-2020     | USA         | Washington         |                                                                        |
| MT163718        | Genbank         | 29-Feb-2020     | USA         | Washington         |                                                                        |
| MT163717        | Genbank         | 28-Feb-2020     | USA         | Washington         |                                                                        |
| MT163716        | Genbank         | 27-Feb-2020     | USA         | Washington         |                                                                        |
| MT066156        | Genbank         | 30-Jan-2020     | Italy       |                    |                                                                        |
| LC528233        | Genbank         | 10-Feb-2020     | Japan       | Kanagawa           | Diamond Princess cruise ship?                                          |
| LC528232        | Genbank         | 10-Feb-2020     | Japan       | Kanagawa           | Diamond Princess cruise ship?                                          |
| LC529905        | Genbank         |    Jan-2020     | Japan       | Tokyo              |                                                                        |
| MT276598        | Genbank         |    Mar-2020     | Israel      |                    |                                                                        |
| MT276597        | Genbank         |    Feb-2020     | Israel      |                    |                                                                        |
| MT263469        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263468        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263467        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263466        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263465        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263464        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263463        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263462        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263461        | Genbank         | 22-Mar-2020     | USA         | Washington         |                                                                        |
| MT263460        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263459        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263458        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263457        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263456        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263455        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263454        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263453        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263452        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263451        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263450        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263449        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263448        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263447        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT263446        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263445        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263444        | Genbank         | 20-Mar-2020     | USA         | Washington         |                                                                        |
| MT263443        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263442        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263441        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263440        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263439        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263438        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263437        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263436        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263435        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263434        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263433        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263432        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263431        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263430        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263429        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263428        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263427        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263426        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263425        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263424        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263423        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263422        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263421        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263420        | Genbank         | 20-Mar-2020     | USA         | Washington         |                                                                        |
| MT263419        | Genbank         | 20-Mar-2020     | USA         | Washington         |                                                                        |
| MT263418        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263417        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263416        | Genbank         | 21-Mar-2020     | USA         | Washington         |                                                                        |
| MT263415        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263414        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263413        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263412        | Genbank         | 22-Mar-2020     | USA         | Washington         |                                                                        |
| MT263411        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263410        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263409        | Genbank         | 22-Mar-2020     | USA         | Washington         |                                                                        |
| MT263408        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263407        | Genbank         | 22-Mar-2020     | USA         | Washington         |                                                                        |
| MT263406        | Genbank         | 21-Mar-2020     | USA         | Washington         |                                                                        |
| MT263405        | Genbank         | 21-Mar-2020     | USA         | Washington         |                                                                        |
| MT263404        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263403        | Genbank         | 20-Mar-2020     | USA         | Washington         |                                                                        |
| MT263402        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263401        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263400        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263399        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263398        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263397        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263396        | Genbank         | 22-Mar-2020     | USA         | Washington         |                                                                        |
| MT263395        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263394        | Genbank         | 22-Mar-2020     | USA         | Washington         |                                                                        |
| MT263393        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263392        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263391        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263390        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263389        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263388        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263387        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263386        | Genbank         | 22-Mar-2020     | USA         | Washington         |                                                                        |
| MT263385        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263384        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263383        | Genbank         | 24-Mar-2020     | USA         | Washington         |                                                                        |
| MT263382        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT263381        | Genbank         | 23-Mar-2020     | USA         | Washington         |                                                                        |
| MT262916        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262915        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262914        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262913        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262912        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262911        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262910        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262909        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262908        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262907        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262906        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262905        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262904        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262903        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262902        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262901        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262900        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262899        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262898        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262897        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262896        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT262993        | Genbank         | 12-Mar-2020     | Pakistan    | Khyber Pakhtunkhwa |                                                                        |
| MT259231        | Genbank         | 25-Jan-2020     | China       | Wuhan              |                                                                        |
| MT259230        | Genbank         | 25-Jan-2020     | China       | Wuhan              |                                                                        |
| MT259229        | Genbank         | 26-Jan-2020     | China       | Wuhan              |                                                                        |
| MT259228        | Genbank         | 26-Jan-2020     | China       | Wuhan              |                                                                        |
| MT259227        | Genbank         | 26-Jan-2020     | China       | Wuhan              |                                                                        |
| MT259226        | Genbank         | 10-Jan-2020     | China       | Wuhan              |                                                                        |
| MT259287        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259286        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259285        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259284        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259283        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259282        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259281        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259280        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259279        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259278        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259277        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259276        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259275        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT259274        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT259273        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259272        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259271        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259270        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259269        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT259268        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259267        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT259266        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259265        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259264        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259263        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259262        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT259261        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259260        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259259        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259258        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259257        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259256        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259255        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259254        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259253        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259252        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT259251        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT259250        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT259249        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259248        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT259247        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259246        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259245        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT259244        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259243        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT259242        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT259241        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259240        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259239        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259238        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259237        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259236        | Genbank         | 16-Mar-2020     | USA         | Washington         |                                                                        |
| MT259235        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT258383        | Genbank         | 18-Mar-2020     | USA         | California         |                                                                        |
| MT258382        | Genbank         | 18-Mar-2020     | USA         | California         |                                                                        |
| MT258381        | Genbank         | 18-Mar-2020     | USA         | California         |                                                                        |
| MT258380        | Genbank         | 18-Mar-2020     | USA         | California         |                                                                        |
| MT258379        | Genbank         | 18-Mar-2020     | USA         | California         |                                                                        |
| MT258378        | Genbank         | 18-Mar-2020     | USA         | California         |                                                                        |
| MT258377        | Genbank         | 18-Mar-2020     | USA         | California         |                                                                        |
| MT256924        | Genbank         | 11-Mar-2020     | Colombia    | Antioquia          |                                                                        |
| MT253710        | Genbank         | 21-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253709        | Genbank         | 21-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253708        | Genbank         | 21-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253707        | Genbank         | 25-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253706        | Genbank         | 22-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253705        | Genbank         | 22-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253704        | Genbank         | 25-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253703        | Genbank         | 25-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253702        | Genbank         | 21-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253701        | Genbank         | 21-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253700        | Genbank         | 25-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253699        | Genbank         | 24-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253698        | Genbank         | 23-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253697        | Genbank         | 23-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT253696        | Genbank         | 23-Jan-2020     | China       | Hangzhou           |                                                                        |
| MT251980        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT251979        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT251978        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT251977        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT251976        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT251975        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT251974        | Genbank         | 12-Mar-2020     | USA         | Washington         |                                                                        |
| MT251973        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT251972        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246490        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT246489        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246488        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246487        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT246486        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246485        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT246484        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT246483        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT246482        | Genbank         | 15-Mar-2020     | USA         | Washington         |                                                                        |
| MT246481        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246480        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246479        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246478        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246477        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246476        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246475        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246474        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246473        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246472        | Genbank         | 12-Mar-2020     | USA         | Washington         |                                                                        |
| MT246471        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246470        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246469        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246468        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246467        | Genbank         | 14-Mar-2020     | USA         | Washington         |                                                                        |
| MT246466        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246465        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246464        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246463        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246462        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246461        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246460        | Genbank         | 12-Mar-2020     | USA         | Washington         |                                                                        |
| MT246459        | Genbank         | 12-Mar-2020     | USA         | Washington         |                                                                        |
| MT246458        | Genbank         | 12-Mar-2020     | USA         | Washington         |                                                                        |
| MT246457        | Genbank         | 12-Mar-2020     | USA         | Washington         |                                                                        |
| MT246456        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246455        | Genbank         | 12-Mar-2020     | USA         | Washington         |                                                                        |
| MT246454        | Genbank         | 12-Mar-2020     | USA         | Washington         |                                                                        |
| MT246453        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246452        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246451        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246450        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT246449        | Genbank         | 13-Mar-2020     | USA         | Washington         |                                                                        |
| MT240479        | Genbank         | 04-Mar-2020     | Pakistan    | Gilgit             |                                                                        |
| MT192773        | Genbank         | 22-Jan-2020     | Viet Nam    | Ho Chi Minh        |                                                                        |
| MT192772        | Genbank         | 22-Jan-2020     | Viet Nam    | Ho Chi Minh        |                                                                        |
| MT192765        | Genbank         | 11-Mar-2020     | USA         | California         |                                                                        |
| MT192759        | Genbank         | 25-Jan-2020     | Taiwan      |                    |                                                                        |
| MT123293        | Genbank         | 29-Jan-2020     | China       | Guangzhou          |                                                                        |
| MT123292        | Genbank         | 27-Jan-2020     | China       | Guangzhou          |                                                                        |
| MT123291        | Genbank         | 29-Jan-2020     | China       | Guangzhou          |                                                                        |
| MT093631        | Genbank         | 08-Jan-2020     | China       | Wuhan              |                                                                        |
| MT121215        | Genbank         | 02-Feb-2020     | China       | Shanghai           |                                                                        |
| MT050493        | Genbank         | 31-Jan-2020     | India       | Kerala             |                                                                        |
| MT012098        | Genbank         | 27-Jan-2020     | India       | Kerala             |                                                                        |
| MT152824        | Genbank         | 24-Feb-2020     | USA         | Washington         |                                                                        |
| MT135044        | Genbank         | 28-Jan-2020     | China       | Beijing            |                                                                        |
| MT135043        | Genbank         | 28-Jan-2020     | China       | Beijing            |                                                                        |
| MT135042        | Genbank         | 28-Jan-2020     | China       | Beijing            |                                                                        |
| MT135041        | Genbank         | 26-Jan-2020     | China       | Beijing            |                                                                        |
| MT246667        | Genbank         | 19-Jan-2020     | USA         | Washington         |                                                                        |
| MT233526        | Genbank         | 19-Jan-2020     | USA         | Washington         |                                                                        |
| MN985325        | Genbank         | 19-Jan-2020     | USA         | Washington         | Returned to Washington State from Wuhan (35 years old male)            |
| MT020781        | Genbank         | 29-Jan-2020     | Finland     | Lapland            |                                                                        |
| MN996531        | Genbank         | 30-Dec-2019     | China       | Wuhan              | synonym: GWHABKO00000000                                               |
| MN996530        | Genbank         | 30-Dec-2019     | China       | Wuhan              | synonym: GWHABKN00000000                                               |
| MN996529        | Genbank         | 30-Dec-2019     | China       | Wuhan              | synonym: GWHABKM00000000                                               |
| MN996528        | Genbank         | 30-Dec-2019     | China       | Wuhan              | synonym: GWHABKL00000000                                               |
| MN996527        | Genbank         | 30-Dec-2019     | China       | Wuhan              | synonym: GWHABKK00000000                                               |
| MN908947        | Genbank         | 30-Dec-2019     | China       | Wuhan              |                                                                        |
| MT188341        | Genbank         | 05-Mar-2020     | USA         | Minnesota          |                                                                        |
| MT188340        | Genbank         | 07-Mar-2020     | USA         | Minnesota          |                                                                        |
| MT188339        | Genbank         | 09-Mar-2020     | USA         | Minnesota          |                                                                        |
| MT184913        | Genbank         | 24-Feb-2020     | USA         |                    | USA-CruiseA-26                                                         |
| MT184912        | Genbank         | 17-Feb-2020     | USA         |                    | USA-CruiseA-25                                                         |
| MT184911        | Genbank         | 17-Feb-2020     | USA         |                    | USA-CruiseA-24                                                         |
| MT184910        | Genbank         | 18-Feb-2020     | USA         |                    | USA-CruiseA-23                                                         |
| MT184909        | Genbank         | 21-Feb-2020     | USA         |                    | USA-CruiseA-22                                                         |
| MT184908        | Genbank         | 21-Feb-2020     | USA         |                    | USA-CruiseA-21                                                         |
| MT184907        | Genbank         | 18-Feb-2020     | USA         |                    | USA-CruiseA-19                                                         |
| LR757998        | Genbank         | 26-Dec-2019     | China       | Wuhan              | synonym: CNA0007332                                                    |
| LR757997        | Genbank         | 31-Dec-2019     | China       | Wuhan              | synonym: CNA0007333                                                    |
| LR757996        | Genbank         | 01-Jan-2020     | China       | Wuhan              | synonym: CNA0007334                                                    |
| LR757995        | Genbank         | 05-Jan-2020     | China       | Wuhan              | synonym: CNA0007335                                                    |
| MT159722        | Genbank         | 21-Feb-2020     | USA         |                    | USA-CruiseA-6                                                          |
| MT159721        | Genbank         | 21-Feb-2020     | USA         |                    | USA-CruiseA-5                                                          |
| MT159720        | Genbank         | 21-Feb-2020     | USA         |                    | USA-CruiseA-4                                                          |
| MT159719        | Genbank         | 18-Feb-2020     | USA         |                    | USA-CruiseA-3                                                          |
| MT159718        | Genbank         | 18-Feb-2020     | USA         |                    | USA-CruiseA-2                                                          |
| MT159717        | Genbank         | 17-Feb-2020     | USA         |                    | USA-CruiseA-1                                                          |
| MT159716        | Genbank         | 24-Feb-2020     | USA         |                    | USA-CruiseA-18                                                         |
| MT159715        | Genbank         | 24-Feb-2020     | USA         |                    | USA-CruiseA-17                                                         |
| MT159714        | Genbank         | 18-Feb-2020     | USA         |                    | USA-CruiseA-16                                                         |
| MT159713        | Genbank         | 18-Feb-2020     | USA         |                    | USA-CruiseA-15                                                         |
| MT159712        | Genbank         | 25-Feb-2020     | USA         |                    | USA-CruiseA-14                                                         |
| MT159711        | Genbank         | 20-Feb-2020     | USA         |                    | USA-CruiseA-13                                                         |
| MT159710        | Genbank         | 17-Feb-2020     | USA         |                    | USA-CruiseA-9                                                          |
| MT159709        | Genbank         | 20-Feb-2020     | USA         |                    | USA-CruiseA-12                                                         |
| MT159708        | Genbank         | 17-Feb-2020     | USA         |                    | USA-CruiseA-11                                                         |
| MT159707        | Genbank         | 17-Feb-2020     | USA         |                    | USA-CruiseA-10                                                         |
| MT159706        | Genbank         | 17-Feb-2020     | USA         |                    | USA-CruiseA-8                                                          |
| MT159705        | Genbank         | 17-Feb-2020     | USA         |                    | USA-CruiseA-7                                                          |
| MT118835        | Genbank         | 23-Feb-2020     | USA         | California         |                                                                        |
| MT106054        | Genbank         | 11-Feb-2020     | USA         | Texas              |                                                                        |
| MT106053        | Genbank         | 10-Feb-2020     | USA         | California         |                                                                        |
| MT106052        | Genbank         | 06-Feb-2020     | USA         | California         |                                                                        |
| MT072688        | Genbank         | 13-Jan-2020     | Nepal       | Kathmandu          |                                                                        |
| MT044258        | Genbank         | 27-Jan-2020     | USA         | California         |                                                                        |
| MT044257        | Genbank         | 28-Jan-2020     | USA         | Illinois           |                                                                        |
| MT039888        | Genbank         | 29-Jan-2020     | USA         | Massachusetts      |                                                                        |
| MT039887        | Genbank         | 31-Jan-2020     | USA         | Wisconsin          |                                                                        |
| MT039890        | Genbank         |    Jan-2020     | South Korea |                    |                                                                        |
| MT039873        | Genbank         | 20-Jan-2020     | China       | Hangzhou           | synonym: GWHABKS00000000                                               |
| MT027064        | Genbank         | 29-Jan-2020     | USA         | California         |                                                                        |
| MT027063        | Genbank         | 29-Jan-2020     | USA         | California         |                                                                        |
| MT027062        | Genbank         | 29-Jan-2020     | USA         | California         |                                                                        |
| MT020881        | Genbank         | 25-Jan-2020     | USA         | Washington         |                                                                        |
| MT020880        | Genbank         | 25-Jan-2020     | USA         | Washington         |                                                                        |
| MT019533        | Genbank         | 01-Jan-2020     | China       | Wuhan              | synonym: GWHABKJ00000000                                               |
| MT019532        | Genbank         | 30-Dec-2019     | China       | Wuhan              | synonym: GWHABKI00000000                                               |
| MT019531        | Genbank         | 30-Dec-2019     | China       | Wuhan              | synonym: GWHABKH00000000                                               |
| MT019530        | Genbank         | 30-Dec-2019     | China       | Wuhan              | synonym: GWHABKG00000000                                               |
| MT019529        | Genbank         | 23-Dec-2019     | China       | Wuhan              | synonym: GWHABKF00000000                                               |
| MT007544        | Genbank         | 25-Jan-2020     | Australia   | Victoria           |                                                                        |
| MN997409        | Genbank         | 22-Jan-2020     | USA         | Arizona            |                                                                        |
| MN994468        | Genbank         | 22-Jan-2020     | USA         | California         |                                                                        |
| MN994467        | Genbank         | 23-Jan-2020     | USA         | California         |                                                                        |
| MN988713        | Genbank         | 21-Jan-2020     | USA         | Illinois           |                                                                        |
| MN988669        | Genbank         | 02-Jan-2020     | China       | Wuhan              |                                                                        |
| MN988668        | Genbank         | 02-Jan-2020     | China       | Wuhan              |                                                                        |
| MN975262        | Genbank         | 11-Jan-2020     | China       | Shenzhen           | Traveler from Shenzhen to Wuhan (10 years old male)                    |
| MN938384        | Genbank         | 10-Jan-2020     | China       | Shenzhen           | Traveler from Shenzhen to Wuhan (66 years old male)                    |
| LC521925        | Genbank         | 25-Jan-2020     | Japan       | Aichi              |                                                                        |
| LC522975        | Genbank         | 31-Jan-2020     | Japan       | Tokyo              |                                                                        |
| LC522974        | Genbank         | 31-Jan-2020     | Japan       | Tokyo              |                                                                        |
| LC522973        | Genbank         | 29-Jan-2020     | Japan       | Tokyo              |                                                                        |
| LC522972        | Genbank         | 29-Jan-2020     | Japan       | Kyoto              |                                                                        |
| MN996532        | Genbank         | 24-Jul-2013     | China       |                    | Bat (Rhinolophus affinis) coronavirus RaTG13, synonym: GWHABKP00000000 |
| MG772933        | Genbank         |    Feb-2017     | China       |                    | Bat (Rhinolophus sinicus) SARS-like coronavirus                        |

Meta data were supplemented from National Genomics Data Center (https://bigd.big.ac.cn/search).

## Summary of parsimony-informative sites
```
                                    1111111111111111111111222222222222222222222222222222
                 11223334455556666880011224444556677777888011344555666777777888888889999                                     Sample Collection Date
             346809460142400573689672303124788398923478078637403568179233569001888880135
             191351463713068781919083182110107228147745637980032651423728236794578889802 - 2019 -||--------------------------------------- 2020 ---------------------------------------
             304392627716224240396222930138857477273478067267345350496674554794481235837   30-Dec     10-Jan    20-Jan    30-Jan     10-Feb    20-Feb   29-Feb    10-Mar    20-Mar         State/City
---------------------------------------------------------------------------------------- -------|----------|---------|---------|----------|---------|--------|---------|---------|----- ---------------------
MN908947.3   CTGTCCTCCCCATGAGCCAGTGCCCGTGCCGCCCTCGTCCCACTCCCCACAGTCGTCCGTACCGCTCGGGGCACG        ●          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MN996528.1   ...........................................................................        ●          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MN996529.1   ...........................................................................        ●          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MN996530.1   ...........................................................................        ●          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MN996531.1   ...........................................................................        ●          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MT019530.1   ...........................................................................        ●          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MT019532.1   ...........................................................................        ●          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MT019529.1   ........................................................................... ●      |          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MT019533.1   ...........................................................................        | ●        |         |         |          |         |        |         |         |      🇨🇳 Wuhan
LR757998.1   ...........................................................................    ●   |          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
LR757996.1   ...........................................................................        | ●        |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MN988668.1   ...........................................................................        |  ●       |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MN988669.1   ...........................................................................        |  ●       |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MT093631.2   ...........................................................................        |        ● |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MT039873.1   ...........................................................................        |          |         ●         |          |         |        |         |         |      🇨🇳 Hangzhou
MT253708.1   ...........................................................................        |          |         |●        |          |         |        |         |         |      🇨🇳 Hangzhou
MT253709.1   ...........................................................................        |          |         |●        |          |         |        |         |         |      🇨🇳 Hangzhou
MT253710.1   ...........................................................................        |          |         |●        |          |         |        |         |         |      🇨🇳 Hangzhou
MT253701.1   ...........................................................................        |          |         |●        |          |         |        |         |         |      🇨🇳 Hangzhou
MT253702.1   ...........................................................................        |          |         |●        |          |         |        |         |         |      🇨🇳 Hangzhou
MT253705.1   ...........................................................................        |          |         | ●       |          |         |        |         |         |      🇨🇳 Hangzhou
MT253696.1   ...........................................................................        |          |         |  ●      |          |         |        |         |         |      🇨🇳 Hangzhou
MT253697.1   ...........................................................................        |          |         |  ●      |          |         |        |         |         |      🇨🇳 Hangzhou
MT253698.1   ...........................................................................        |          |         |  ●      |          |         |        |         |         |      🇨🇳 Hangzhou
MT253699.1   ...........................................................................        |          |         |   ●     |          |         |        |         |         |      🇨🇳 Hangzhou
MT253700.1   ...........................................................................        |          |         |    ●    |          |         |        |         |         |      🇨🇳 Hangzhou
MT253703.1   ...........................................................................        |          |         |    ●    |          |         |        |         |         |      🇨🇳 Hangzhou
MT253704.1   ...........................................................................        |          |         |    ●    |          |         |        |         |         |      🇨🇳 Hangzhou
MT253707.1   ...........................................................................        |          |         |    ●    |          |         |        |         |         |      🇨🇳 Hangzhou
MT121215.1   ...........................................................................        |          |         |         |  ●       |         |        |         |         |      🇨🇳 Shanghai
MT192759.1   ...........................................................................        |          |         |    ●    |          |         |        |         |         |      🇹🇼 
MT066176.1   ...........................................................................        |          |         |         |     ●    |         |        |         |         |      🇹🇼 Taipei
LC534419.1   ...........................................................................        |          |         |         |          |         |        |        ●|         |      🇯🇵 Kanagawa
MT044258.1   ...........................................................................        |          |         |      ●  |          |         |        |         |         |      🇺🇸 California
MT118835.1   ...........................................................................        |          |         |         |          |         |  ●     |         |         |      🇺🇸 California
MT188340.1   ...........................................................................        |          |         |         |          |         |        |      ●  |         |      🇺🇸 Minnesota
MT262993.1   ...........................................................................        |          |         |         |          |         |        |         | ●       |      🇵🇰 Khyber Pakhtunkhwa
LC521925.1   .....T.....................................................................        |          |         |    ●    |          |         |        |         |         |      🇯🇵 Aichi
MT019531.1   ....................C......................................................        ●          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MT192772.1   .......................T...................................................        |          |         | ●       |          |         |        |         |         |      🇻🇳 Ho Chi Minh
MT192773.1   .......................T...................................................        |          |         | ●       |          |         |        |         |         |      🇻🇳 Ho Chi Minh
LC528232.1   .........................T.................................................        |          |         |         |          ●         |        |         |         |      🇯🇵 Kanagawa
LC528233.1   .........................T.................................................        |          |         |         |          ●         |        |         |         |      🇯🇵 Kanagawa
LC534418.1   .........................T.................................................        |          |         |         |          |   ●     |        |         |         |      🇯🇵 Kanagawa
MT276328.1   .........................T.................................................        |          |         |         |          |         |      ● |         |         |      🇺🇸 Oregon
MT240479.1   .........................T.................................................        |          |         |         |          |         |        |   ●     |         |      🇵🇰 Gilgit
MT276597.1   .........................T.................................................        |          |         |         |          |         |        |         |         |      🇮🇱 
MT276325.1   ..............................T............................................        |          |         |         |          |         |      ● |         |         |      🇺🇸 Washington
MT276324.1   ..............................T............................................        |          |         |         |          |         |     ●  |         |         |      🇺🇸 California
MT259230.1   ......................................T....................................        |          |         |    ●    |          |         |        |         |         |      🇨🇳 Wuhan
MT012098.1   ......................................T....................................        |          |         |      ●  |          |         |        |         |         |      🇮🇳 Kerala
MT039887.1   ......................................T....................................        |          |         |         |●         |         |        |         |         |      🇺🇸 Wisconsin
MT259228.1   .............................................T.............................        |          |         |     ●   |          |         |        |         |         |      🇨🇳 Wuhan
MT259229.1   .............................................T.............................        |          |         |     ●   |          |         |        |         |         |      🇨🇳 Wuhan
MT259231.1   .............................................T.............................        |          |         |    ●    |          |         |        |         |         |      🇨🇳 Wuhan
MT259227.1   .............................................T.............................        |          |         |     ●   |          |         |        |         |         |      🇨🇳 Wuhan
MT027064.1   ...............................................T...........................        |          |         |        ●|          |         |        |         |         |      🇺🇸 California
MT020781.2   ...............................................T...........................        |          |         |        ●|          |         |        |         |         |      🇫🇮 Lapland
MT072688.1   .................................................T.........................        |          |  ●      |         |          |         |        |         |         |      🇳🇵 Kathmandu
MT106053.1   ..................................................G........................        |          |         |         |          ●         |        |         |         |      🇺🇸 California
MN996527.1   ..................................................G........................        ●          |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MT259226.1   ...........................................................C...............        |          ●         |         |          |         |        |         |         |      🇨🇳 Wuhan
MT263429.1   ..................................................................T........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT027062.1   ..A...........G...................................................T........        |          |         |        ●|          |         |        |         |         |      🇺🇸 California
MT027063.1   ..A...........G...................................................T........        |          |         |        ●|          |         |        |         |         |      🇺🇸 California
MT123290.1   .................................T.......................................T.        |          |         |         |     ●    |         |        |         |         |      🇨🇳 Guangzhou
LC529905.1   .................................T...................G...................T.        |          |         |         |          |         |        |         |         |      🇯🇵 Tokyo
LC522972.1   .................................T...................G...................T.        |          |         |        ●|          |         |        |         |         |      🇯🇵 Kyoto
MT123291.2   ...................T..................T...................................A        |          |         |        ●|          |         |        |         |         |      🇨🇳 Guangzhou
MT123293.2   ...................TC.................T...................................A        |          |         |        ●|          |         |        |         |         |      🇨🇳 Guangzhou
MN994468.1   ......................................................T....................        |          |         | ●       |          |         |        |         |         |      🇺🇸 California
MT007544.1   ......................................................T....................        |          |         |    ●    |          |         |        |         |         |      🇦🇺 Victoria
MT093571.1   ......................................................T....................        |          |         |         |       ●  |         |        |         |         |      🇸🇪 
MT039890.1   ......................................................T....................        |          |         |         |          |         |        |         |         |      🇰🇷 
MT126808.1   .........................T.....T.....C................T....................        |          |         |         |          |         |       ●|         |         |      🇧🇷 Sao Paulo
MT246454.1   .........................T.....T.....C................T....................        |          |         |         |          |         |        |         | ●       |      🇺🇸 Washington
MT259267.1   .........................T.....T.....C................T....................        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT259285.1   ...........G.............T.....T....................C.T....................        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT263404.1   ...........G.............T.....T....................C.T....................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT163716.1   ......C...T....T.........T.....T......................T....................        |          |         |         |          |         |      ● |         |         |      🇺🇸 Washington
MT276326.1   ......C...T....T.........T.....T......................T....................        |          |         |         |          |         |        ●         |         |      🇺🇸 Georgia
MT276323.1   ........T....................T..................G..........................        |          |         |         |          |         |       ●|         |         |      🇺🇸 Rhode Island
MT192765.1   ........T....................T..................G..........................        |          |         |         |          |         |        |         |●        |      🇺🇸 California
MT263438.1   ........T....................T..................G..........................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263433.1   ........T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT251974.1   ........T....................T..............T...G..T.......................        |          |         |         |          |         |        |         | ●       |      🇺🇸 Washington
MT246480.1   ........T....................T..............T...G..T.......................        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT263411.1   ........T....................T..............T...G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT246460.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         | ●       |      🇺🇸 Washington
MT246449.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246450.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT259246.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246481.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT259264.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246467.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT259248.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT259251.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT251979.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT259278.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT259281.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT246487.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT246490.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT259239.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT259240.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT259260.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT263394.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         | ●    🇺🇸 Washington
MT263468.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263465.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263390.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263391.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263417.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263432.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263437.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263442.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263446.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263439.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263408.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263428.1   ....T...T....................T..................G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT259286.1   ....T...T..................A.T..................G..T.......................        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT259261.1   ....T...T..................A.T..................G..T.......................        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT251976.1   ....T...T....................T......T...........G..T.......................        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT263467.1   ....T...T....................T......T...........G..T.......................        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263392.1   ....T...T....................T......T...........G..T.......................        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT259235.1   ....T...T....................T..................G..T..........T............        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT259249.1   ....T...T....................T..................G..T..........T............        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT263415.1   ....T...T....................T..................G..T..........T............        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT246453.1   ...CT...T....................T..................G..T..........T............        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT259244.1   ...CT...T....................T..................G..T..........T............        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT258378.1   ...CT...T....................T..................G..T..........T............        |          |         |         |          |         |        |         |       ● |      🇺🇸 California
MT259243.1   ....T...T...............T....T..................G..T..........T............        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246484.1   ....T...T...............T....T..................G..T..........T............        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT263406.1   ....T...T...............T....T..................G..T..........T............        |          |         |         |          |         |        |         |         |●     🇺🇸 Washington
MT259256.1   ....T...T....................T..................G..T..........T.T..........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT259258.1   ....T...T....................T..................G..T..........T.T..........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT276327.1   ........T....................T..................G...................AAC....        |          |         |         |          |         |        ●         |         |      🇺🇸 Georgia
MT246470.1   ........T....................T..................G...................AAC....        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT259263.1   ........T....................T..................G...................AAC....        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246451.1   ........T....................T..................G...................AAC....        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT263402.1   ........T....................T..................G...................AAC....        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263074.1   ........T....................T..................G...................AAC....        |          |         |         |          |         |        |         ●         |      🇵🇪 
MT259250.1   T.......T....................T..................G...................AAC....        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT276329.1   T.......T....................T..................G...................AAC....        |          |         |         |          |         |       ●|         |         |      🇺🇸 Florida
MT276330.1   T.......T....................T..................G...................AAC....        |          |         |         |          |         |       ●|         |         |      🇺🇸 Florida
MT276598.1   T.......T....................T..................G...................AAC....        |          |         |         |          |         |        |         |         |      🇮🇱 
LR757995.1   ......................T..........................................C.........        |     ●    |         |         |          |         |        |         |         |      🇨🇳 Wuhan
MT123292.2   ......................T..........................................C.........        |          |         |      ●  |          |         |        |         |         |      🇨🇳 Guangzhou
MT066175.1   ......................T..........................................C.........        |          |         |         |●         |         |        |         |         |      🇹🇼 Taipei
MT050493.1   ......................T..........................................C.........        |          |         |         |●         |         |        |         |         |      🇮🇳 Kerala
MT049951.1   ......................T..C.......................................C.........        |          |      ●  |         |          |         |        |         |         |      🇨🇳 Yunnan
MT226610.1   ......................T..T.......................................C.........        |          |         ●         |          |         |        |         |         |      🇨🇳 
MT233523.1   ......................T........T.................................C.........        |          |         |         |          |         |        |   ●     |         |      🇪🇸 Valencia
MT106052.1   ......................T..........................................C.A.......        |          |         |         |      ●   |         |        |         |         |      🇺🇸 California
MT263386.1   ......................T..........................................C.A.......        |          |         |         |          |         |        |         |         | ●    🇺🇸 Washington
MT135041.1   ............CT........T..........................................C.........        |          |         |     ●   |          |         |        |         |         |      🇨🇳 Beijing
MT135042.1   ............CT........T..........................................C.........        |          |         |       ● |          |         |        |         |         |      🇨🇳 Beijing
MT135044.1   ............CT........T..........................................C.........        |          |         |       ● |          |         |        |         |         |      🇨🇳 Beijing
MT135043.1   ............CT........T..........................................C.........        |          |         |       ● |          |         |        |         |         |      🇨🇳 Beijing
MN994467.1   ......................T..........................T.....C.......C.C.........        |          |         |  ●      |          |         |        |         |         |      🇺🇸 California
MT044257.1   .A.......T............T..........................T.....C.......C.C.........        |          |         |       ● |          |         |        |         |         |      🇺🇸 Illinois
MT263410.1   .A.......T............T....................C.....T.....C.......C.C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT259252.1   .A.......T............T....................C.....T.....C.....T.C.C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT263384.1   .A.......T............T....................C.....T.....C.....T.C.C.........        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MN985325.1   ......................T...................T......................C.........        |          |        ●|         |          |         |        |         |         |      🇺🇸 Washington
MT233526.1   ......................T...................T......................C.........        |          |        ●|         |          |         |        |         |         |      🇺🇸 Washington
MT246667.1   ......................T...................T......................C.........        |          |        ●|         |          |         |        |         |         |      🇺🇸 Washington
MT020880.1   ......................T...................T......................C.........        |          |         |    ●    |          |         |        |         |         |      🇺🇸 Washington
MT020881.1   ......................T...................T......................C.........        |          |         |    ●    |          |         |        |         |         |      🇺🇸 Washington
MT163717.1   ......................T.................TGT......................C.........        |          |         |         |          |         |       ●|         |         |      🇺🇸 Washington
MT163718.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        ●         |         |      🇺🇸 Washington
MT163719.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |●        |         |      🇺🇸 Washington
MT262915.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246461.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246466.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT259266.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT259268.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246479.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262900.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262901.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262905.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262907.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262910.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262911.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262912.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262913.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262914.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262916.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262899.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246468.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT251972.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT251978.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT259274.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT246488.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT259275.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT246469.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT246474.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT259269.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT259262.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT251977.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT259271.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT259276.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT259282.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT259245.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT259280.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT259287.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |    ●    |      🇺🇸 Washington
MT259253.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT259236.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT259237.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT259247.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT259241.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT259257.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT259254.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |     ●   |      🇺🇸 Washington
MT263444.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         ●      🇺🇸 Washington
MT263403.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         ●      🇺🇸 Washington
MT263405.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |●     🇺🇸 Washington
MT263412.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         | ●    🇺🇸 Washington
MT263396.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         | ●    🇺🇸 Washington
MT263381.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263382.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263423.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263462.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263383.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263425.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263449.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263456.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263399.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263430.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263440.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263452.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263414.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263463.1   ......................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263434.1   .....T................T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT152824.1   ................T.....T.................TGT......................C.........        |          |         |         |          |         |   ●    |         |         |      🇺🇸 Washington
MT163720.1   ................T.....T.................TGT......................C.........        |          |         |         |          |         |        |●        |         |      🇺🇸 Washington
MT246455.1   ................T.....T.................TGT......................C.........        |          |         |         |          |         |        |         | ●       |      🇺🇸 Washington
MT263419.1   .....................AT.................TGT......................C.........        |          |         |         |          |         |        |         |         ●      🇺🇸 Washington
MT263464.1   .....................AT.................TGT......................C.........        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263400.1   .....................AT.................TGT......................C.........        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT246457.1   ......................T.....T...........TGT......................C.........        |          |         |         |          |         |        |         | ●       |      🇺🇸 Washington
MT251980.1   ......................T.....T...........TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246459.1   ......................T................TTGT......................C.........        |          |         |         |          |         |        |         | ●       |      🇺🇸 Washington
MT246476.1   ......................T................TTGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT188341.1   ......................T.................TGT...T..................C.........        |          |         |         |          |         |        |    ●    |         |      🇺🇸 Minnesota
MT188339.1   ......................T.................TGT...T..................C.........        |          |         |         |          |         |        |        ●|         |      🇺🇸 Minnesota
MT246477.1   .................T....T.................TGT......................C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT263424.1   .................T....T.................TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT246486.1   .................T....T.................TGT...............T......C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT263398.1   .................T....T.................TGT...............T......C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT246478.1   ......................T.................TGT................C.....C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT246489.1   ......................T.................TGT................C.....C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT251975.1   ......................T.................TGT................C.....C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT263469.1   ......................T.................TGT................C.....C.........        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT246452.1   ......................T.................TGT.................G....C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246462.1   ......................T.................TGT.................G....C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT263457.1   ......................T.................TGT.................G....C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263448.1   ......................T............T....TGT.................G....C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263458.1   ..................G...T.........T.......TGT......................C......T..        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263435.1   ..................G...T.........T.......TGT......................C......T..        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT263416.1   ......................T..T..............TGT......................C.........        |          |         |         |          |         |        |         |         |●     🇺🇸 Washington
MT263395.1   ......................T..T..............TGT......................C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT246475.1   ......................T..T.........T....TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT246471.1   ......................T..T..............TGT................C.....C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT246472.1   ......................T...C.............TGT......................C.........        |          |         |         |          |         |        |         | ●       |      🇺🇸 Washington
MT262896.1   ......................T...C.............TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262897.1   ......................T...C.............TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262898.1   ......................T...C.............TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262902.1   ......................T...C.............TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262903.1   ......................T...C.............TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262904.1   ......................T...C.............TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262906.1   ......................T...C.............TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262908.1   ......................T...C.............TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT262909.1   ......................T...C.............TGT......................C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT263447.1   ......................T...........G.....TGT.............T........C.........        |          |         |         |          |         |        |         |   ●     |      🇺🇸 Washington
MT263388.1   ......................T...........G.....TGT.............T........C.........        |          |         |         |          |         |        |         |         |  ●   🇺🇸 Washington
MT263422.1   ......................T...........G.....TGT.............T........C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MT246464.1   ......................T.................TGT..............T.C.....C.........        |          |         |         |          |         |        |         |  ●      |      🇺🇸 Washington
MT263450.1   ......................T.................TGT..............T.C.....C.........        |          |         |         |          |         |        |         |         |   ●  🇺🇸 Washington
MN938384.1   ......................T..........................................C.....T...        |          ●         |         |          |         |        |         |         |      🇨🇳 Shenzhen
MN975262.1   ......................T..........................................C.....T...        |          |●        |         |          |         |        |         |         |      🇨🇳 Shenzhen
MT106054.1   ......................T..........................................C.....T...        |          |         |         |          |●        |        |         |         |      🇺🇸 Texas
MN997409.1   ......................T..T.......................................C.....T...        |          |         | ●       |          |         |        |         |         |      🇺🇸 Arizona
LC522973.1   .......T..............T..........................................C.....T...        |          |         |        ●|          |         |        |         |         |      🇯🇵 Tokyo
LC522974.1   .......T..............T..........................................C.....T...        |          |         |         |●         |         |        |         |         |      🇯🇵 Tokyo
LC522975.1   .......T..............T..........................................C.....T...        |          |         |         |●         |         |        |         |         |      🇯🇵 Tokyo
MG772933.1   .....A...A..C....T....T.......ATTTGT...........G.T.A.............C.....T...        |          |         |         |          |         |        |         |         |      🦇
MN996532.1   ........T.............T...........C...T...T......T.A....T........C.....T...        |          |         |         |          |         |        |         |         |      🦇
```

## Summary of maximum-likelihood phylogenetic analyses
| No. | Data type | Directory | Partition                                        | Final LogLikelihood | AIC score     | AICc score    | BIC socre     | # Free parameters |
| --- | --------- | ----------| ------------------------------------------------ | ------------------- | ------------- | ------------- | ------------- | ----------------- |
| 1   | DNA       | univ/uni/ | No partition                                     | -61671.254628       | 124494.509256 | 124517.776688 | 129263.811519 | 576               |
| 2   | DNA       | univ/3rd/ | Separate 3rd codon position and others           | -61071.181025       | 123294.362050 | 123317.629482 | 128063.664312 | 576               |
| 3   | DNA       | univ/sep/ | Separate each codon position                     | -60379.797746       | 121935.595492 | 121959.851831 | 126804.258219 | 588               |
| 4   | DNA       | part/uni/ | Separate each ORF                                | Failed              | Failed        | Failed        | Failed        | Failed            |
| 5   | DNA       | part/3rd/ | Separate each ORF, 3rd codon position and others | -58874.031098       | 119094.062197 | 119125.926339 | 124666.528209 | 673               |
| 6   | DNA       | part/sep/ | Separate each ORF, each codon position           | -58603.317305       | 118626.634609 | 118662.142101 | 124505.462051 | 710               |

## Release notes
| Release Date | Contents                                                                                     |
| ------------ | -------------------------------------------------------------------------------------------- |
| 28-Feb-2020  | initial release                                                                              |
| 12-Mar-2020  | update genome sequence data, improve parallelization efficiency and usability of the scripts |
| 18-Mar-2020  | update genome sequence data                                                                  |
| 20-Mar-2020  | update genome sequence data, remove USA-CruiseA data from the analyses                       |
| 23-Mar-2020  | update genome sequence data                                                                  |
| 31-Mar-2020  | update genome sequence data                                                                  |
| 05-Apr-2020  | update genome sequence data                                                                  |
| 15-Apr-2020  | update genome sequence data, change MSA software, disable AA-based phylogenetic analyses     |

## License
All in-house scripts in `script/` direcory are released under the MIT license.
See also `script/LICENSE`.
