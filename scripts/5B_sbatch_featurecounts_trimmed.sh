#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=trimmed_featureCounts
#SBATCH --time=02:00:00
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --output=/work/geisingerlab/Mark/rnaSeq/2024-04-03_pbpGlpsB_clean-redo/test_bowtie/logs/%x-%j.log
#SBATCH --error=/work/geisingerlab/Mark/rnaSeq/2024-04-03_pbpGlpsB_clean-redo/test_bowtie/logs/%x-%j.err
#SBATCH --mail-type=END
#SBATCH --mail-user=soo.m@northeastern.edu

echo "Loading environment and tools"
module load subread/2.0.6

source ./config.cfg
TRIMMED_COUNTS_FILE=counts_srnas_trimmed.txt
MAPPED_TRIMMED_DIR=$BASE_DIR/data/trimmed_mapped
echo "featureCounts file name: $TRIMMED_COUNTS_FILE found in $COUNTS_OUTDIR"
echo "genome GTF reference file: $GENOME_GTF"
echo ".bam input files were found in: $MAPPED_TRIMMED_DIR"

mkdir -p $COUNTS_OUTDIR

# Run featureCounts on all BAM files from STAR
# -t flag specifies features in column 3 of GTF to count; default is exon.
featureCounts \
-a $GENOME_GTF \
-o $COUNTS_OUTDIR/$TRIMMED_COUNTS_FILE \
-p \
-t sRNA \
$MAPPED_TRIMMED_DIR/*.bam
