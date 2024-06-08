# 2024-06-07_bowtie_sRNAs-from-palethorpe

1. Get reads as before
2. Create bowtie2 genome from chromosome only - sRNAs aligned only to chromo.
3. Generate sample sheet
4. Run Bowtie2 aligner using options: `bowtie2 --local -x $BT2_OUT_BASE -q -1 $r1 -2 $r2 -S $MAPPED_DIR/$name.sam`
5. Samtools to convert .sam files to sorted .bam files
6. Featurecounts in subread package
7. DESeq2 in R
