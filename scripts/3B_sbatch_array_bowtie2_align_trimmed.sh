#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=alignTrimmedRNA_bowtie
#SBATCH --time=08:00:00
#SBATCH --array=1-6%7
#SBATCH --ntasks=6
#SBATCH --mem=100G
#SBATCH --cpus-per-task=8
#SBATCH --output=/work/geisingerlab/Mark/rnaSeq/2024-06-07_bowtie_sRNAs-from-palethorpe/logs/%x-%j-%a.log
#SBATCH --error=/work/geisingerlab/Mark/rnaSeq/2024-06-07_bowtie_sRNAs-from-palethorpe/logs/%x-%j-%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

## Usage: sbatch 3B_sbatch_array_bowtie2_align_trimmed.sh
echo "Loading tools"
module load bowtie/2.5.2

# Load config file
source ./config.cfg

TRIMMED_SAMPLE_SHEET=/work/geisingerlab/Mark/rnaSeq/palethorpe_sRNAs_fixed_2024-05-30/data/trimmed/paired/sample_sheet.txt
MAPPED_TRIMMED_DIR=$BASE_DIR/data/trimmed_mapped

echo "Bowtie2 reference genome index basename: $BT2_OUT_BASE"
echo "sample sheet located at $TRIMMED_SAMPLE_SHEET"
echo "alignment output directory containing .bam files: $MAPPED_TRIMMED_DIR"

mkdir -p $MAPPED_TRIMMED_DIR

# sed and awk read through the sample sheet and grab each whitespace-separated value
name=$(sed -n "$SLURM_ARRAY_TASK_ID"p $TRIMMED_SAMPLE_SHEET |  awk '{print $1}')
r1=$(sed -n "$SLURM_ARRAY_TASK_ID"p $TRIMMED_SAMPLE_SHEET |  awk '{print $2}')
r2=$(sed -n "$SLURM_ARRAY_TASK_ID"p $TRIMMED_SAMPLE_SHEET |  awk '{print $3}')

echo "Running Bowtie2 on files $r1 and $r2"

# Bowtie2 in paired end mode
bowtie2 --local -p 8 -x $BT2_OUT_BASE -q -1 $r1 -2 $r2 -S $MAPPED_TRIMMED_DIR/$name.sam
