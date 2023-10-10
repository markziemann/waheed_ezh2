#!/bin/bash

# curate the promoter regions

# get the promoter coordinates from the GTF file with gtftools
gtftools.py -t tss_regions.bed -w 1000-300 gencode.v44.primary_assembly.annotation.gtf

# now collapse the overlapping features
for GID in $(cut -f6 tss_regions.bed | sort -u ) ; do
  GENESYMBOL=$(grep -w $GID tss_regions.bed |head -1 | cut -f7)
  grep -w $GID tss_regions.bed | bedtools sort | bedtools merge \
  | sed "s/^/${GID}_${GENESYMBOL}\t/" | sed 's/$/\t./'
done > tss_regions.saf

# now the saf file can be used for featurecounts
