#!/usr/bin/env nextflow

process POS2BED {
    label 'process_low'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'
    
    input:
    tuple val(sample_id), path(peaks_file)
    
    output:
    tuple val(sample_id), path("${sample_id}.bed")
    
    script:
    """
    pos2bed.pl ${peaks_file} > ${sample_id}.bed
    """
    
    stub:
    """
    touch ${sample_id}.bed
    """
}