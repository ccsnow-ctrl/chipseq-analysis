#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'
    publishDir params.outdir, mode:'copy'
    
    input:
    path index_files  // Receives all the .bt2 files
    tuple val(sample_id), path(reads)
    
    output:
    tuple val(sample_id), path("${sample_id}.bam")
    
    script:
    """
    bowtie2 -x hg38 -U ${reads} | samtools view -bS - > ${sample_id}.bam
    """
    
    stub:
    """
    touch ${sample_id}.bam
    """
}