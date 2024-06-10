#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=trimmed_samtools_to_sorted_bam
#SBATCH --time=04:00:00
#SBATCH --array=1-6%7
#SBATCH --ntasks=6
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --output=/work/geisingerlab/Mark/rnaSeq/2024-06-07_bowtie_sRNAs-from-palethorpe/logs/%x-%j.log
#SBATCH --error=/work/geisingerlab/Mark/rnaSeq/2024-06-07_bowtie_sRNAs-from-palethorpe/logs/%x-%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

# Note, learned a nice trick for arrays, but I think you have to define the path explicitly:
# This SBATCH header would start array jobs for each file *.txt
# --array=0-$(ls *.txt | wc -l) script.sh

echo "Loading tools"
module load samtools/1.19.2

source ./config.cfg
MAPPED_TRIMMED_DIR=$BASE_DIR/data/trimmed_mapped
echo "Looking for .sam files and outputting sorted bams in $MAPPED_TRIMMED_DIR"

# Get array of sam files
# shellcheck disable=SC2207
sams_array=($(ls -d ${MAPPED_TRIMMED_DIR}/*.sam))

# Get specific file for this array task
current_file=${sams_array[$SLURM_ARRAY_TASK_ID-1]}

current_name=$(basename "$current_file")
current_name_no_ext="${current_name%.*}"

echo "converting .sam to .bam"
samtools view -bS "${current_file}" > ${MAPPED_TRIMMED_DIR}/${current_name_no_ext}.bam
echo "sorting bam file"
samtools sort ${MAPPED_TRIMMED_DIR}/${current_name_no_ext}.bam -o "${MAPPED_TRIMMED_DIR}/${current_name_no_ext}"_sorted.bam
echo "analyzing alignment statistics"
samtools stats "${MAPPED_TRIMMED_DIR}/${current_name_no_ext}"_sorted.bam > "${MAPPED_TRIMMED_DIR}/${current_name_no_ext}"_sorted.bam.stats

echo "cleaning up: moving .sam and unsorted .bam files to $MAPPED_TRIMMED_DIR/intermediate_files"
mkdir -p $MAPPED_TRIMMED_DIR/intermediate_files
echo "moving ${current_file}"
mv ${current_file} intermediate_files/
echo "moving ${current_file}${current_name_no_ext}.bam"
mv "${current_name_no_ext}".bam intermediate_files/
