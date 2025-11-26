#!/usr/bin/env nextflow

process TRIM {

    label 'process_low'
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(reads), path(adapters)

    output:

    tuple val(sample_id), path("${sample_id}_trimmed.fastq.gz"), emit: trimmed


    script:
    """
    trimmomatic SE -phred33 \
      ${reads} \
      ${sample_id}_trimmed.fastq.gz \
      ILLUMINACLIP:${adapters}:2:30:10 \
      LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    """
}
