
## Comparing genomes

We want to do some whole-genome comparisons of genomes. The NCBI has made a really cool tool for this:
[Comparative Genome Viewer](https://www.ncbi.nlm.nih.gov/cgv)

*Unfortunately*, this tool is limited to very-high-quality assemblies in the NCBI. These are the gold standards...


## Lets explore tuberculosis! 🤓

Mycobacteria are the predominant cause of tuberculosis. These are small, aerobic, nonmotile bacteria. Some related bacteria even cause other serious diseases for humans.



| genbank seq | genbank assembly | organism                                   | abbreviation |
|-------------|------------------|--------------------------------------------|--------------|
| AE016958    | GCA_000007865.1  | Mycobacterium avium                        | Mavium       |
| CP010333    | GCA_001544815.1  | Mycobacterium tuberculosis variant microti | Mmicro       |
| CP013741    | GCA_001483905.1  | Mycobacterium tuberculosis variant bovis   | Mbovis       |
| FR878060    | GCA_000253355.1  | Mycobacterium africanum                    | Mafric       |
| AL450380    | GCA_000195855.1  | Mycobacterium leprae                       | Mlepra       |




## To install:

* datasets (from NCBI: <https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/>)
* minimap2 (using apt or homebrew)
* jbrowse2 (<https://jbrowse.org/jb2/>)
* blastn (using apt or homebrew)

## 1) Download the data

We are going to use datasets to pull all of the assembly information. This will include many key files:
* genomic sequence (.fna, .fa, .fasta)
* protein sequences (.faa)
* annotation data (.gff)


We will download them based on the genome/assembly entry from genebank. This uses the (relatively new) tool: datasets. This tool chains several commands together. If you don't know the commands, it will give you options when you start from the base command.

```
datasets

datasets is a command-line tool that is used to query and download biological sequence data
across all domains of life from NCBI databases.

Refer to NCBI's [download and install](https://www.ncbi.nlm.nih.gov/datasets/docs/download-and-install/) documentation for information about getting started with the command-line tools.

Usage
  datasets [command]

Data Retrieval Commands
  summary              print a summary of a gene or genome dataset
  download             download a gene, genome or coronavirus dataset as a zip file
  rehydrate            rehydrate a downloaded, dehydrated dataset

Miscellaneous Commands
  completion           generate autocompletion scripts
  version              print the version of this client and exit
  help                 Help about any command

Flags
      --api-key string   NCBI Datasets API Key
  -h, --help             help for datasets
      --no-progressbar   hide progress bar

Use datasets help <command> for detailed help about a command.
```

Following this, we will look for accessions from our genomes.
This command will download a single genome with its accessory files. It will be stored in a zip.

```
datasets download genome accession GCA_000007865.1
```

To download them all, we can run them all in the same command.

```
datasets download genome accession GCA_000007865.1 GCA_001544815.1 GCA_001483905.1 GCA_000253355.1 GCA_000195855.1
```

In the unzipped folder, we can find entries for each one.


I think it most easy to rename our sequences at this point.

```
./sequences/
-> Mafric.fna
-> Mavium.fna
-> Mbovis.fna
-> Mlepra.fna
-> Mmicro.fna
...
```


## 2) Lets try this the (really) simple way (blast and R)

blastn (with the megablast algorithm) can do genome-wide comparisons between genomes. Most simply, this would be 1 by 1.


`blastn -query ./sequences/Mafric.fna -subject ./sequences/Mavium.fna -outfmt 6 -out Mafric_Mavium.txt -task megablast`

**what does the resulting file look like?**



Lets knock this out with a bash script:

```
mkdir blast_outputs

for A in Mafric Mavium Mbovis Mlepra Mmicro
do
	for B in Mafric Mavium Mbovis Mlepra Mmicro
	do
		echo $A"_"$B
		blastn -query ./sequences/$A'.fna' -subject ./sequences/$B'.fna' -outfmt 6 -out "blast_outputs/"$A"_"$B.txt -task megablast
	done
done
```

Looks cool, but is coarse. We can't zoom in. Can't get any sense of the detailed regions. Blast doesn't work perfectly, as we get over-plotting for similar genomes.


## 3) Let's get more complicated

Using minimap2, we can do a whole genome alignment. This is pretty simple if you can get minimap2 to run.

They give us a guide here: [minimap2 github](https://github.com/lh3/minimap2)


Lets try this with just two genomes first. Let's quickly check the help to get a sense of what mode to use.

```
minimap2 -h
Usage: minimap2 [options] <target.fa>|<target.idx> [query.fa] [...]
Options:
  Indexing:
    -H           use homopolymer-compressed k-mer (preferrable for PacBio)
    -k INT       k-mer size (no larger than 28) [15]
    -w INT       minimizer window size [10]
    -I NUM       split index for every ~NUM input bases [8G]
    -d FILE      dump index to FILE []
  Mapping:
    -f FLOAT     filter out top FLOAT fraction of repetitive minimizers [0.0002]
    -g NUM       stop chain enlongation if there are no minimizers in INT-bp [5000]
    -G NUM       max intron length (effective with -xsplice; changing -r) [200k]
    -F NUM       max fragment length (effective with -xsr or in the fragment mode) [800]
    -r NUM[,NUM] chaining/alignment bandwidth and long-join bandwidth [500,20000]
    -n INT       minimal number of minimizers on a chain [3]
    -m INT       minimal chaining score (matching bases minus log gap penalty) [40]
    -X           skip self and dual mappings (for the all-vs-all mode)
    -p FLOAT     min secondary-to-primary score ratio [0.8]
    -N INT       retain at most INT secondary alignments [5]
  Alignment:
    -A INT       matching score [2]
    -B INT       mismatch penalty (larger value for lower divergence) [4]
    -O INT[,INT] gap open penalty [4,24]
    -E INT[,INT] gap extension penalty; a k-long gap costs min{O1+k*E1,O2+k*E2} [2,1]
    -z INT[,INT] Z-drop score and inversion Z-drop score [400,200]
    -s INT       minimal peak DP alignment score [80]
    -u CHAR      how to find GT-AG. f:transcript strand, b:both strands, n:don't match GT-AG [n]
    -J INT       splice mode. 0: original minimap2 model; 1: miniprot model [1]
  Input/Output:
    -a           output in the SAM format (PAF by default)
    -o FILE      output alignments to FILE [stdout]
    -L           write CIGAR with >65535 ops at the CG tag
    -R STR       SAM read group line in a format like '@RG\tID:foo\tSM:bar' []
    -c           output CIGAR in PAF
    --cs[=STR]   output the cs tag; STR is 'short' (if absent) or 'long' [none]
    --ds         output the ds tag, which is an extension to cs
    --MD         output the MD tag
    --eqx        write =/X CIGAR operators
    -Y           use soft clipping for supplementary alignments
    -t INT       number of threads [3]
    -K NUM       minibatch size for mapping [500M]
    --version    show version number
  Preset:
    -x STR       preset (always applied before other options; see minimap2.1 for details) []
                 - lr:hq - accurate long reads (error rate <1%) against a reference genome
                 - splice/splice:hq - spliced alignment for long reads/accurate long reads
                 - asm5/asm10/asm20 - asm-to-ref mapping, for ~0.1/1/5% sequence divergence
                 - sr - short reads against a reference
                 - map-pb/map-hifi/map-ont/map-iclr - CLR/HiFi/Nanopore/ICLR vs reference mapping
                 - ava-pb/ava-ont - PacBio CLR/Nanopore read overlap

See `man ./minimap2.1' for detailed description of these and other advanced command-line options.
```

Notice the last item `preset`. That's really important for choosing how minimap works. *Minimap* is very flexible and can serve multiple purposes - what preset do we use??

**Run minimap2 to generate a .paf file**

## 4) Looking at it in a browser


Now that we have a `.paf`, lets load it up in jbrowse2. Some general outline of steps:

1) Load up a dot-plot view.
2) Assign your genome sequences (order is important).
3) Include the `.paf` 


Then, we can look at it.
* does it look better than in R?
* worse? how?


4) Try to zoom in on a section
5) open it in the synteny viewer.

Now, we want to see some genes

6) Load some more tracks - a genome annotation track for both.
7) Look for some examples of inversions, deletions, duplications!




## 5) Orthofinder

This is the all star tool. So far we have been doing genome-wide comparisons. Orthofinder will let us do gene-level analyses... for all genes... like, all of them.

Orthofinder is a bit tough to install. We will try to work with it on the cluster.


First, we need to get our proteome sequences on the cluster (`.faa`). To upload we can use `scp` (secure copy):
```
# scp from_dir to_dir

# if the dir is on a server:
# user@server:dir

scp ./sequences/*.faa njohnson@darwin:/home2/njohnson/+Teaching/2024-Bioinf1/genomics/proteomes
```


Now we can load orthofinder and its required modules:
```
module avail # to list all modules

module load orthofinder

cd /home2/njohnson/+Teaching/2024-Bioinf1/genomics

srun orthofinder -f proteomes/
```

Is this efficiently using the cluster?

```
# accessing the cluster again and checking node usage:
ssh njohnson@darwin

gnodes

+- slim - 28 cores & 62GB -----------------+------------------------------------------+------------------------------------------+------------------------------------------+
| n001   60G  ..........................._ | n005   62G  ............................ | n009   62G  ............................ | n013   62G  ............................ |
| n002   62G  ............................ | n006   62G  ............................ | n010   62G  ............................ | n014   62G  ............................ |
| n003   62G  ............................ | n007   62G  ............................ | n011   62G  ............................ | n015   62G  ............................ |
| n004   62G  ............................ | n008   62G  ............................ | n012   62G  ............................ | n016   62G  ............................ |
+------------------------------------------+------------------------------------------+------------------------------------------+------------------------------------------+

+- test - 32 cores & 62GB -----------------------+
| darwin   62G                DOWN               |
+------------------------------------------------+

```


We need to give the right number of cores to slurm!

```
srun -c 28 orthofinder -f proteomes/


+- slim - 28 cores & 62GB -----------------+------------------------------------------+------------------------------------------+------------------------------------------+
| n001    0G  __________________________OO | n005   62G  ............................ | n009   62G  ............................ | n013   62G  ............................ |
| n002   62G  ............................ | n006   62G  ............................ | n010   62G  ............................ | n014   62G  ............................ |
| n003   62G  ............................ | n007   62G  ............................ | n011   62G  ............................ | n015   62G  ............................ |
| n004   62G  ............................ | n008   62G  ............................ | n012   62G  ............................ | n016   62G  ............................ |
+------------------------------------------+------------------------------------------+------------------------------------------+------------------------------------------+

+- test - 32 cores & 62GB -----------------------+
| darwin   62G                DOWN               |
+------------------------------------------------+
```

Now, lets download the result and have a look at it

```
scp -r njohnson@darwin:/home2/njohnson/+Teaching/2024-Bioinf1/genomics/proteomes/OrthoFinder ./
```
 
Looking through the results:
1) lets look at the statistics summary `Statistics_PerSpecies.tsv`
2) what does the species tree look like? Does this "jive" with what we found?
3) lets look at the orthogroups with genes - how well do they look resolved?
4) what about some of the events mentioned above?




