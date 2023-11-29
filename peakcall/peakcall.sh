#!/bin/bash

################## H3K27me3 ################## S1 S9 S17 S2 S10 S18 S3 S11 S19 S4 S12 S20
# untreated
macs2 callpeak -t S1.bam -c S24.bam --outdir S1_H3K27me3_peak -n S1_H3K27me3_macs &
macs2 callpeak -t S9.bam -c S24.bam --outdir S9_H3K27me3_peak -n S19_H3K27me3_macs &
macs2 callpeak -t S17.bam -c S24.bam --outdir S17_H3K27me3_peak -n S17_H3K27me3_macs &

# hg+tnf
macs2 callpeak -t S2.bam -c S25.bam --outdir S2_H3K27me3_peak -n S2_H3K27me3_macs &
macs2 callpeak -t S10.bam -c S25.bam --outdir S10_H3K27me3_peak -n S10_H3K27me3_macs &
macs2 callpeak -t S18.bam -c S25.bam --outdir S18_H3K27me3_peak -n S18_H3K27me3_macs &

# gsk
macs2 callpeak -t S3.bam -c S26.bam --outdir S3_H3K27me3_peak -n S3_H3K27me3_macs &
macs2 callpeak -t S11.bam -c S26.bam --outdir S11_H3K27me3_peak -n S11_H3K27me3_macs &
macs2 callpeak -t S19.bam -c S26.bam --outdir S19_H3K27me3_peak -n S19_H3K27me3_macs &

# t5524
macs2 callpeak -t S4.bam -c S28.bam --outdir S4_H3K27me3_peak -n S4_H3K27me3_macs &
macs2 callpeak -t S12.bam -c S28.bam --outdir S12_H3K27me3_peak -n S12_H3K27me3_macs &
macs2 callpeak -t S20.bam -c S28.bam --outdir S20_H3K27me3_peak -n S20_H3K27me3_macs &

wait

################## FOS ################## S5 S13 S21 S6 S14 S22 S7 S15 S23 S8 S16 S24
# untreated
macs2 callpeak -t S5.bam -c S24.bam --outdir S5_FOS_peak -n S5_FOS_macs &
macs2 callpeak -t S13.bam -c S24.bam --outdir S13_FOS_peak -n S13_FOS_macs &
macs2 callpeak -t S21.bam -c S24.bam --outdir S21_FOS_peak -n S21_FOS_macs &

# hg+tnf
macs2 callpeak -t S6.bam -c S25.bam --outdir S6_FOS_peak -n S6_FOS_macs &
macs2 callpeak -t S14.bam -c S25.bam --outdir S14_FOS_peak -n S14_FOS_macs &
macs2 callpeak -t S22.bam -c S25.bam --outdir S22_FOS_peak -n S22_FOS_macs &

# gsk
macs2 callpeak -t S7.bam -c S26.bam --outdir S7_FOS_peak -n S7_FOS_macs &
macs2 callpeak -t S15.bam -c S26.bam --outdir S15_FOS_peak -n S15_FOS_macs &

# t5524
macs2 callpeak -t S8.bam -c S28.bam --outdir S8_FOS_peak -n S8_FOS_macs &
macs2 callpeak -t S16.bam -c S28.bam --outdir S16_FOS_peak -n S16_FOS_macs &
macs2 callpeak -t S23.bam -c S28.bam --outdir S24_FOS_peak -n S24_FOS_macs &

wait

################## INPUTS ##################
# check whether inputs give any peaks
# this could be a good way to eliminate problematic genomic regions

# 24 vs 25
macs2 callpeak -t S25.bam -c S24.bam --outdir S24vsS25_INPUT_peak -n S24vsS25_INPUT_macs &

# 24 vs 26
macs2 callpeak -t S26.bam -c S24.bam --outdir S24vsS26_INPUT_peak -n S24vsS26_INPUT_macs &

# 24 vs 28
macs2 callpeak -t S28.bam -c S24.bam --outdir S24vsS28_INPUT_peak -n S24vsS28_INPUT_macs &

# 25 vs 26
macs2 callpeak -t S26.bam -c S25.bam --outdir S25vsS26_INPUT_peak -n S25vsS26_INPUT_macs &

# 25 vs 28
macs2 callpeak -t S28.bam -c S25.bam --outdir S25vsS28_INPUT_peak -n S25vsS28_INPUT_macs &

# 26 vs 28
macs2 callpeak -t S28.bam -c S26.bam --outdir S26vsS28_INPUT_peak -n S26vsS28_INPUT_macs &

wait

# merge bed
cat $(find . | grep H3K | grep narrowPeak) | cut -f-3 | wc -l
cat $(find . | grep H3K | grep narrowPeak) | cut -f-3 | bedtools sort | bedtools merge | wc -l

cat $(find . | grep FOS | grep narrowPeak) | cut -f-3 | wc -l
cat $(find . | grep FOS | grep narrowPeak) | cut -f-3 | bedtools sort | bedtools merge | wc -l

cat $(find . | grep H3K | grep narrowPeak) | cut -f-3 | bedtools sort | bedtools merge > H3K27me3.bed
cat $(find . | grep FOS | grep narrowPeak) | cut -f-3 | bedtools sort | bedtools merge > FOS.bed

# curate the SAF FILE
nl -n rz  FOS.bed \
  | sed 's/^/FOS_/' \
  | awk '{OFS="\t"} {print $2,$3,$4,$1}' \
  | bedtools closest -d -a - -b ../ref/tss_regions.bed \
  | awk '!arr[$4]++' \
  | cut -f-4,10- \
  | awk '{OFS="\t"} {print $4"|"$6"|"$5"|"$7,$1,$2,$3}' > FOS.saf






# multicov is crap because the columns have no headers
#bedtools multicov -q 20 -bams S1.bam S9.bam S17.bam S2.bam S10.bam S18.bam S3.bam S11.bam S19.bam \
# S4.bam S12.bam S20.bam S24.bam S25.bam S26.bam S28.bam -bed H3K27me3.bed > H3K27me3.tsv
#bedtools multicov -q 20 -bams S5.bam S13.bam S21.bam S6.bam S14.bam S22.bam S7.bam S15.bam S23.bam \
#  S8.bam S16.bam S23.bam -bed FOS.bed > FOS.tsv


################## FEATURECOUNTS ##################
## H3K27me3
# curate the SAF FILE
nl -n rz  H3K27me3.bed \
  | sed 's/^/H3K27me3_/' \
  | awk '{OFS="\t"} {print $2,$3,$4,$1}' \
  | bedtools closest -d -a - -b ../ref/tss_regions.bed \
  | awk '!arr[$4]++' \
  | cut -f-4,10- \
  | awk '{OFS="\t"} {print $4"|"$6"|"$5"|"$7,$1,$2,$3,"."}' > H3K27me3.saf

featureCounts --countReadPairs -p -Q 20 -T 32 -F SAF -a H3K27me3.saf -o H3K27me3.tsv \
  S5.bam S13.bam S21.bam S6.bam S14.bam S22.bam S7.bam \
  S15.bam S23.bam S8.bam S16.bam S23.bam

sed 1d H3K27me3.tsv | tr -d ' ' | sed 's/\t/|/' | sed 's/\t/|/' | sed 's/\t/|/' \
  | sed 's/\t/|/' | sed 's/\t/|/' > tmp && mv tmp H3K27me3.tsv

## FOS
# curate the SAF FILE
nl -n rz  FOS.bed \
  | sed 's/^/FOS_/' \
  | awk '{OFS="\t"} {print $2,$3,$4,$1}' \
  | bedtools closest -d -a - -b ../ref/tss_regions.bed \
  | awk '!arr[$4]++' \
  | cut -f-4,10- \
  | awk '{OFS="\t"} {print $4"|"$6"|"$5"|"$7,$1,$2,$3,"."}' > FOS.saf

featureCounts --countReadPairs -p -Q 20 -T 32 -F SAF -a FOS.saf -o FOS.tsv \
  S5.bam S13.bam S21.bam S6.bam S14.bam S22.bam S7.bam \
  S15.bam S23.bam S8.bam S16.bam S23.bam

sed 1d FOS.tsv | tr -d ' ' | sed 's/\t/|/' | sed 's/\t/|/' | sed 's/\t/|/' \
  | sed 's/\t/|/' | sed 's/\t/|/' > tmp && mv tmp FOS.tsv
