#!/bin/bash
# 2B_make_sample_sheet_trimmed.sh
# Makes a sample_sheet.txt containing sample ID and R1 and R2 filepaths
# Assumes each sample file is in the format: SRR16949318_1.fastq
# Script uses a split on "_" to grab the sample ID, e.g. SRR16949318.  Must modify this if sample file names are different!
# Example output line:  WT_1 /path/to/WT-1_1.fastq /path/to/WT-1_2.fastq

source ./config.cfg
PAIRED_OUTDIR=/work/geisingerlab/Mark/rnaSeq/stationary_phase_palethorpe_forNER_2024-03-04/data/trimmed/paired/
UNPAIRED_OUTDIR=/work/geisingerlab/Mark/rnaSeq/stationary_phase_palethorpe_forNER_2024-03-04/data/trimmed/unpaired/

# Create .list files with paired R1 and R2 fastqs.  Sort will put them in same orders, assuming files are paired
find ${PAIRED_OUTDIR} -maxdepth 1 -name "*.fastq" | grep -e "_1\." | sort > R1.list
find ${PAIRED_OUTDIR} -maxdepth 1 -name "*.fastq" | grep -e "_2\." | sort > R2.list

# create .list for unpaired files
find ${UNPAIRED_OUTDIR} -maxdepth 1 -name "*.fastq" | sort > unpaired.list

if [ -f "${PAIRED_TRIMMED_SAMPLESHEET}" ] ; then
  rm "${PAIRED_TRIMMED_SAMPLESHEET}"
fi

if [ -f "${UNPAIRED_TRIMMED_SAMPLESHEET}" ] ; then
  rm "${UNPAIRED_TRIMMED_SAMPLESHEET}"
fi

# make sample sheet from R1 and R2 files.  Format on each line looks like (space separated):
# WT_1 /path/to/WT_1_R1.fastq /path/to/WT_1_R2.fastq
# from sample sheet, we can access individual items from each line with e.g. `awk '{print $3}' sample_sheet.txt`

paste R1.list R2.list | while read R1 R2 ;
do
    outdir_root=$(basename ${R2} | cut -f1 -d"_")
    sample_line="${outdir_root} ${R1} ${R2}"
    echo "${sample_line}" >> $PAIRED_TRIMMED_SAMPLESHEET
done

rm R1.list R2.list

paste unpaired.list | while read file ;
do
    outdir_root=$(basename ${unpaired.list} | cut -f1,2,3 -d"_")
    sample_line="${outdir_root} ${file}"
    echo "${sample_line}" >> $UNPAIRED_TRIMMED_SAMPLESHEET
done

unpaired.list