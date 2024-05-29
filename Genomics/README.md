
# Comparing genomes

We want to do some whole-genome comparisons of genomes. The NCBI has made a really cool tool for this:
[Comparative Genome Viewer](https://www.ncbi.nlm.nih.gov/cgv)

*Unfortunately*, this tool is limited to very-high-quality assemblies in the NCBI. These are the gold standards...


# Lets explore tuberculosis! 🤓

Mycobacteria are the predominant cause of tuberculosis. These are small, aerobic, nonmotile bacteria. Some related bacteria even cause other serious diseases for humans.



| genbank seq | genbank assembly | organism                                   | abbreviation |
|-------------|------------------|--------------------------------------------|--------------|
| AE016958    | GCA_000007865.1  | Mycobacterium avium                        | Mavium       |
| CP010333    | GCA_001544815.1  | Mycobacterium tuberculosis variant microti | Mmicro       |
| CP013741    | GCA_001483905.1  | Mycobacterium tuberculosis variant bovis   | Mbovis       |
| FR878060    | GCA_000253355.1  | Mycobacterium africanum                    | Mafric       |
| AL450380    | GCA_000195855.1  | Mycobacterium leprae                       | Mlepra       |




# To install:

* datasets (from NCBI)
* minimap2 (using apt or homebrew)
* jbrowse2
* blastn (using apt or homebrew)


# 1) Download the data

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


# 2) Lets try this the (really) simple way (blast and R)

blastn (with the megablast algorithm) can do genome-wide comparisons between genomes. Most simply, this would be 1 by 1.


`blastn -query ./sequences/Mafric.fna -subject ./sequences/Mavium.fna -outfmt 6 -out Mafric_Mavium.txt -task megablast`


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


# 3) Let's get more complicated

Using minimap2, we can do a whole genome alignment. This is pretty simple if you can get minimap2 to run.

They give us a guide here: [minimap2 github](https://github.com/lh3/minimap2)


Next, we will demonstrate this in jbrowse - an very versatile tool for omics viewing.

Finally, lets load in the genes - can we see any interesting cases?
* find an example of inversion
* deletion
* duplication








