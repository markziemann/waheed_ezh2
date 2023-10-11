# Waheed EZH2 project
Some ChIP-seq data analysis

# Aim
To profile the genomic location of FOS and H3K27me3 in control, HG/TNF samples and test the effect of two
drugs GSK-126 and T-5224 which might affect EZH2 activity.

# Methods summary
ChIP seq was performed in triplicate with the outlined sample groups.
An input control was included for each sample group.

## Reference data (ref directory)

Gencode v44 GRCh38 primary assembly was used as a reference genome sequence and annotation.
Genome was indexed using bwa (0.7.17-r1188).
GTFtools v0.9.0 was used to extract TSS positions from the GTF (-1000 to +300 from TSS).
These TSS coordinates were mostly overlapping, so they were collapsed using bedtools merge (bedtools v2.30.0).
The `tss_curate.sh` script has the exact command used.
The reference files from Gencode are named here:

* gencode.v44.primary_assembly.annotation.gtf

* GRCh38.primary_assembly.genome.fa

## Mapping (aln directory)

Fastq files were copied to the `aln` directory, where they underwent QC analysis with fastQC v0.11.9
and multiQC v1.12 using the `qc.sh` script.
Next the `map.sh` script was used to coordinate the following steps:

1. Quality trimming with skewer (v.0.2.2) using minimum base quality of 20.

2. Mapping of reads to the genome with bwa mem (0.7.17-r1188).

3. Samtools conversion of SAM alignment to BAM (Samtools version 1.13) which included steps for fixing mate
information, sorting, marking duplicate reads and indexing the bam file.

4. Samtools flagstat was used to get some QC information.

5. Read counting using featurecounts v2.0.3. The tss coordinates were used.

The output file `tss_regions.tsv` can be used for differential analysis.

MultiQC v1.12 was then executed again to include the alignment QC information.

## Peak calling (peakcall directory)

In addition to the promoter based analysis, we are also interested in looking across the genome at potential
locations where EZH2 activity may be affected.
Therefore the `peakcall.sh` script was written to coordinate the discovery of peaks that exist in ChIP samples
compared to corresponding input samples.
We have tree replicates for most sample groups and the peakcalling process was conducted independently for
each sample using macs2 2.2.7.1.
The peak sets for FOS were collapsed using bedtools merge and converted to SAF format using a bash script.
H3K27me3 peak sets were also collapsed (separately).
Then featureCounts v2.0.3 was used to count the reads mapping to these locations for each sample.
In the end we have `FOS.tsv` and `H3K27me3.tsv` count matrices for downstream analysis.

## Future work

Still remaining to do is a more in depth quality control analysis, in particular to prove that the ChIP has
enriched known areas of FOS binding and H3K27me3 modification.
To do this we need peak sets for known FOS sites and figure out whether reads are highly mapped there.

PCA analysis.

Statistical analysis.
