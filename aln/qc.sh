#!/bin/bash

cat checksums.md5 | parallel --pipe -N1 md5sum -c

ls *fq.gz | parallel -j8 fastqc {}

multiqc .
