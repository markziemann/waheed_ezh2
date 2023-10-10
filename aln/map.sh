#!/bin/bash


map(){
# set reference genome
REF=../ref/GRCh38.primary_assembly.genome.fa

# a test dataset: test_1.fq.gz
FQ1=$1
FQ2=$(echo $FQ1 | sed 's/_1.fq/_2.fq/' )
BASE=$(echo $FQ1 | cut -d '_' -f1)

skewer -q 20 -t 16 $FQ1 $FQ2

FQ1T=$(echo $FQ1 | sed 's/.gz/-trimmed-pair1.fastq/')
FQ2T=$(echo $FQ1 | sed 's/.gz/-trimmed-pair2.fastq/')

CORES=$(echo $(nproc) | awk '{print$1/2}')

bwa mem -t $CORES $REF $FQ1T $FQ2T \
  | samtools fixmate -O bam,level=1 -m - - \
  | samtools sort -u -@10 \
  | samtools markdup -@8 -O BAM --reference $REF - $BASE.bam

rm $FQ1T $FQ2T

samtools index $BASE.bam
}

export -f map
#parallel -j3 map ::: *_1.fq.gz


## Count promoter features

featureCounts --countReadPairs -p -Q 20 -T 32 -F SAF -a tss_regions.saf -o tss_regions.tsv *bam

sed 1d tss_regions.tsv | tr -d ' ' | sed 's/\t/|/' | sed 's/\t/|/' | sed 's/\t/|/' \
  | sed 's/\t/|/' | sed 's/\t/|/' > tmp && mv tmp tss_regions.tsv
