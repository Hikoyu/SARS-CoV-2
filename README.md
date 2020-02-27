# SARS-CoV-2 genome sequence data analyses

## System requirement
|     |                                          |
| --- | ---------------------------------------- |
| CPU | x86-64 (e.g. Intel Core i3/i5/i7 series) |
| RAM | 8 GB or above                            |
| OS  | 64-bit Linux or macOS                    |

## Software dependencies
| Package name | Version | Site URL                                             |
| ------------ | ------- | ---------------------------------------------------- |
| Perl         | 5.x     | https://www.perl.org (Preinstalled in OS)            |
| Samtools     | 1.10    | http://www.htslib.org/download                       |
| BEDTools     | 2.29.2  | https://github.com/arq5x/bedtools2                   |
| NCBI-BLAST+  | 2.2.29  | http://ftp.ncbi.nlm.nih.gov/blast/executables/blast+ |
| FATE         | 2.7.1   | https://github.com/Hikoyu/FATE                       |
| DIALIGN-TX   | 1.0.2   | https://dialign-tx.gobics.de/download                |
| ModelTest-NG | 0.1.6   | https://github.com/ddarriba/modeltest                |
| RAxML-NG     | 0.9.0   | https://github.com/amkozlov/raxml-ng                 |

## Preparation before analysis
Above softwares must be installed and in your PATH.
Some softwares need to be compiled. (e.g. Samtools)

## Re-analysis
Clone this repository and remove old data before re-analysis.
Then, simply execute 'script/all-in-one_analysis.sh' in the top of the repository.

```
$ git clone https://github.com/Hikoyu/SARS-CoV-2
$ cd SARS-CoV-2
$ rm ref/MN908947_cds.f?a ref/SARS-CoV-2_200222.fna.* fate/*.* dialign/*.* phylogeny/DNA/*.* phylogeny/DNA/*/*/*/*.* phylogeny/AA/*.* phylogeny/AA/*/*.*
$ ./script/all-in-one_analysis.sh
```
Now, you can get the multiple sequence alignments of open reading frames, the lists of variable/parsimony-informative sites, and the maximum-likelihood phylogenies.
If you want to re-analyze only estimating phylogeny, remove old phylogenetic analysis data and execute 'script/phylogenetic_analysis.sh' in the top of the repository.

```
$ git clone https://github.com/Hikoyu/SARS-CoV-2
$ cd SARS-CoV-2
$ rm phylogeny/DNA/*.* phylogeny/DNA/*/*/*/*.* phylogeny/AA/*.* phylogeny/AA/*/*.*
$ ./script/phylogenetic_analysis.sh
```
Now, you can get the maximum-likelihood phylogenies.

## Calculation time
Phylogenetic analyses take a lot of time.
They took over 24 hours in total on MacBook Air Mid 2012 (Intel Core i7-3667U, 8 GB RAM).
More CPU cores and/or newer streaming SIMD extensions may contribute to reduce the calculation time.
If you intend to just test, reduce the bootstraps replicates to 100 via '--bs-trees' option in RAxML-NG.

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
│   ├── SARS-CoV-2_200222.cds.E.aln.faa
│   ├── SARS-CoV-2_200222.cds.E.aln.fna
│   ├── SARS-CoV-2_200222.cds.E.fna
│   ├── SARS-CoV-2_200222.cds.M.aln.faa
│   ├── SARS-CoV-2_200222.cds.M.aln.fna
│   ├── SARS-CoV-2_200222.cds.M.fna
│   ├── SARS-CoV-2_200222.cds.N.aln.faa
│   ├── SARS-CoV-2_200222.cds.N.aln.fna
│   ├── SARS-CoV-2_200222.cds.N.fna
│   ├── SARS-CoV-2_200222.cds.ORF10.aln.faa
│   ├── SARS-CoV-2_200222.cds.ORF10.aln.fna
│   ├── SARS-CoV-2_200222.cds.ORF10.fna
│   ├── SARS-CoV-2_200222.cds.ORF3a.aln.faa
│   ├── SARS-CoV-2_200222.cds.ORF3a.aln.fna
│   ├── SARS-CoV-2_200222.cds.ORF3a.fna
│   ├── SARS-CoV-2_200222.cds.ORF6.aln.faa
│   ├── SARS-CoV-2_200222.cds.ORF6.aln.fna
│   ├── SARS-CoV-2_200222.cds.ORF6.fna
│   ├── SARS-CoV-2_200222.cds.ORF7a.aln.faa
│   ├── SARS-CoV-2_200222.cds.ORF7a.aln.fna
│   ├── SARS-CoV-2_200222.cds.ORF7a.fna
│   ├── SARS-CoV-2_200222.cds.ORF8.aln.faa
│   ├── SARS-CoV-2_200222.cds.ORF8.aln.fna
│   ├── SARS-CoV-2_200222.cds.ORF8.fna
│   ├── SARS-CoV-2_200222.cds.S.aln.faa
│   ├── SARS-CoV-2_200222.cds.S.aln.fna
│   ├── SARS-CoV-2_200222.cds.S.fna
│   ├── SARS-CoV-2_200222.cds.orf1ab_D.aln.faa
│   ├── SARS-CoV-2_200222.cds.orf1ab_D.aln.fna
│   ├── SARS-CoV-2_200222.cds.orf1ab_D.fna
│   ├── SARS-CoV-2_200222.cds.orf1ab_U.aln.faa
│   ├── SARS-CoV-2_200222.cds.orf1ab_U.aln.fna
│   ├── SARS-CoV-2_200222.cds.orf1ab_U.fna
│   ├── parsimony-informative_sites.txt
│   └── variable_sites.txt
├── fate => open reading frame annotation data
│   └── SARS-CoV-2_200222.cds.bed
├── msa_list.txt
├── parsimony-informative_site_position_list.txt
├── phylogeny
│   ├── AA => including phylogenetic analysis data based on AA sequences
│   │   ├── RAxML-NG => including phylogenetic analysis data using partitioned model for each ORF
│   │   │   ├── SARS-CoV-2_200222.cds.raxml.bestModel
│   │   │   ├── SARS-CoV-2_200222.cds.raxml.bestTree
│   │   │   ├── SARS-CoV-2_200222.cds.raxml.bootstraps
│   │   │   ├── SARS-CoV-2_200222.cds.raxml.log
│   │   │   ├── SARS-CoV-2_200222.cds.raxml.mlTrees
│   │   │   ├── SARS-CoV-2_200222.cds.raxml.rba
│   │   │   ├── SARS-CoV-2_200222.cds.raxml.reduced.partition
│   │   │   ├── SARS-CoV-2_200222.cds.raxml.reduced.phy
│   │   │   ├── SARS-CoV-2_200222.cds.raxml.startTree
│   │   │   └── SARS-CoV-2_200222.cds.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│   │   ├── SARS-CoV-2_200222.cds.aln.concat.faa
│   │   ├── SARS-CoV-2_200222.cds.part.txt
│   │   └── model_test => including model test data using partitioned model for each ORF
│   │       ├── SARS-CoV-2_200222.cds.ckp
│   │       ├── SARS-CoV-2_200222.cds.log
│   │       ├── SARS-CoV-2_200222.cds.out
│   │       ├── SARS-CoV-2_200222.cds.part.aic
│   │       ├── SARS-CoV-2_200222.cds.part.aicc
│   │       ├── SARS-CoV-2_200222.cds.part.bic
│   │       └── SARS-CoV-2_200222.cds.tree
│   └── DNA => including phylogenetic analysis data based on DNA sequences
│       ├── RAxML-NG
│       │   ├── part
│       │   │   ├── 3rd => including phylogenetic analysis data using partitioned model for each ORF and also 1st/2nd and 3rd codon position
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.bestModel
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.bestTree
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.bootstraps
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.log
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.mlTrees
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.rba
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.reduced.partition
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.reduced.phy
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.startTree
│       │   │   │   └── SARS-CoV-2_200222.cds.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│       │   │   ├── sep => including phylogenetic analysis data using partitioned model for each ORF and also each codon position
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.bestModel
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.bestTree
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.bootstraps
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.log
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.mlTrees
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.rba
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.reduced.partition
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.reduced.phy
│       │   │   │   ├── SARS-CoV-2_200222.cds.raxml.startTree
│       │   │   │   └── SARS-CoV-2_200222.cds.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│       │   │   └── uni => including phylogenetic analysis data using partitioned model for each ORF
│       │   │       ├── SARS-CoV-2_200222.cds.raxml.bestModel
│       │   │       ├── SARS-CoV-2_200222.cds.raxml.bestTree
│       │   │       ├── SARS-CoV-2_200222.cds.raxml.bootstraps
│       │   │       ├── SARS-CoV-2_200222.cds.raxml.log
│       │   │       ├── SARS-CoV-2_200222.cds.raxml.mlTrees
│       │   │       ├── SARS-CoV-2_200222.cds.raxml.rba
│       │   │       ├── SARS-CoV-2_200222.cds.raxml.reduced.partition
│       │   │       ├── SARS-CoV-2_200222.cds.raxml.reduced.phy
│       │   │       ├── SARS-CoV-2_200222.cds.raxml.startTree
│       │   │       └── SARS-CoV-2_200222.cds.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│       │   └── univ
│       │       ├── 3rd => including phylogenetic analysis data using partitioned model for 1st/2nd and 3rd codon position
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.bestModel
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.bestTree
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.bootstraps
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.log
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.mlTrees
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.rba
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.reduced.partition
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.reduced.phy
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.startTree
│       │       │   └── SARS-CoV-2_200222.cds.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│       │       ├── sep => including phylogenetic analysis data using partitioned model for each codon position
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.bestModel
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.bestTree
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.bootstraps
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.log
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.mlTrees
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.rba
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.reduced.partition
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.reduced.phy
│       │       │   ├── SARS-CoV-2_200222.cds.raxml.startTree
│       │       │   └── SARS-CoV-2_200222.cds.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│       │       └── uni => including phylogenetic analysis data without using partitioned model
│       │           ├── SARS-CoV-2_200222.cds.raxml.bestModel
│       │           ├── SARS-CoV-2_200222.cds.raxml.bestTree
│       │           ├── SARS-CoV-2_200222.cds.raxml.bootstraps
│       │           ├── SARS-CoV-2_200222.cds.raxml.log
│       │           ├── SARS-CoV-2_200222.cds.raxml.mlTrees
│       │           ├── SARS-CoV-2_200222.cds.raxml.rba
│       │           ├── SARS-CoV-2_200222.cds.raxml.reduced.phy
│       │           ├── SARS-CoV-2_200222.cds.raxml.startTree
│       │           └── SARS-CoV-2_200222.cds.raxml.support.nwk => maximum-likelihood phylogeny data with bootstrap values
│       ├── SARS-CoV-2_200222.cds.aln.concat.fna
│       ├── SARS-CoV-2_200222.cds.part_3rd.txt
│       ├── SARS-CoV-2_200222.cds.part_sep.txt
│       ├── SARS-CoV-2_200222.cds.part_uni.txt
│       ├── SARS-CoV-2_200222.cds.univ_3rd.txt
│       ├── SARS-CoV-2_200222.cds.univ_sep.txt
│       └── model_test
│           ├── part
│           │   ├── 3rd => including model test data using partitioned model for each ORF and also 1st/2nd and 3rd codon position
│           │   │   ├── SARS-CoV-2_200222.cds.ckp
│           │   │   ├── SARS-CoV-2_200222.cds.log
│           │   │   ├── SARS-CoV-2_200222.cds.out
│           │   │   ├── SARS-CoV-2_200222.cds.part.aic
│           │   │   ├── SARS-CoV-2_200222.cds.part.aicc
│           │   │   ├── SARS-CoV-2_200222.cds.part.bic
│           │   │   └── SARS-CoV-2_200222.cds.tree
│           │   ├── sep => including phylogenetic analysis data using partitioned model for each ORF and also each codon position
│           │   │   ├── SARS-CoV-2_200222.cds.ckp
│           │   │   ├── SARS-CoV-2_200222.cds.log
│           │   │   ├── SARS-CoV-2_200222.cds.out
│           │   │   ├── SARS-CoV-2_200222.cds.part.aic
│           │   │   ├── SARS-CoV-2_200222.cds.part.aicc
│           │   │   ├── SARS-CoV-2_200222.cds.part.bic
│           │   │   └── SARS-CoV-2_200222.cds.tree
│           │   └── uni => including model test data using partitioned model for each ORF
│           │       ├── SARS-CoV-2_200222.cds.ckp
│           │       ├── SARS-CoV-2_200222.cds.log
│           │       ├── SARS-CoV-2_200222.cds.out
│           │       ├── SARS-CoV-2_200222.cds.part.aic
│           │       ├── SARS-CoV-2_200222.cds.part.aicc
│           │       ├── SARS-CoV-2_200222.cds.part.bic
│           │       └── SARS-CoV-2_200222.cds.tree
│           └── univ
│               ├── 3rd => including model test data using partitioned model for 1st/2nd and 3rd codon position
│               │   ├── SARS-CoV-2_200222.cds.ckp
│               │   ├── SARS-CoV-2_200222.cds.log
│               │   ├── SARS-CoV-2_200222.cds.out
│               │   ├── SARS-CoV-2_200222.cds.part.aic
│               │   ├── SARS-CoV-2_200222.cds.part.aicc
│               │   ├── SARS-CoV-2_200222.cds.part.bic
│               │   └── SARS-CoV-2_200222.cds.tree
│               ├── sep => including model test data using partitioned model for each codon position
│               │   ├── SARS-CoV-2_200222.cds.ckp
│               │   ├── SARS-CoV-2_200222.cds.log
│               │   ├── SARS-CoV-2_200222.cds.out
│               │   ├── SARS-CoV-2_200222.cds.part.aic
│               │   ├── SARS-CoV-2_200222.cds.part.aicc
│               │   ├── SARS-CoV-2_200222.cds.part.bic
│               │   └── SARS-CoV-2_200222.cds.tree
│               └── uni => including model test data without using partitioned model
│                   ├── SARS-CoV-2_200222.cds.ckp
│                   ├── SARS-CoV-2_200222.cds.log
│                   ├── SARS-CoV-2_200222.cds.out
│                   └── SARS-CoV-2_200222.cds.tree
├── ref => including SARS-CoV-2 genome sequence data and reference open reading frame annotation data
│   ├── MN908947_cds.bed => open reading frame annotation data of 'REF_genome_MN908947_Wuhan-Hu-1'
│   ├── MN908947_cds.faa => open reading frame AA sequence data of 'REF_genome_MN908947_Wuhan-Hu-1'
│   ├── MN908947_cds.fna => open reading frame DNA sequence data of 'REF_genome_MN908947_Wuhan-Hu-1'
│   ├── SARS-CoV-2_200222.fna => SARS-CoV-2 genome sequence data
│   ├── SARS-CoV-2_200222.fna.fai
│   ├── SARS-CoV-2_200222.fna.nhr
│   ├── SARS-CoV-2_200222.fna.nin
│   └── SARS-CoV-2_200222.fna.nsq
├── sample_list.txt
└── script => including in-house script files
    ├── all-in-one_analysis.sh
    ├── phylogenetic_analysis.sh
    ├── translator.pl
    └── variable_sites_extractor.pl
```
