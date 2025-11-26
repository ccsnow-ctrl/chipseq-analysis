#!/usr/bin/env nextflow

process BAMCOVERAGE {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(sorted_bam), path(sorted_bai)

    output:
    tuple val(sample_id), path("${sample_id}.bw")

    script:
    """
    bamCoverage \
        -b $sorted_bam \
        -o ${sample_id}.bw \
        --outFileFormat bigwig
    """
    
    stub:
    """
    touch ${sample_id}.bw
    """
}
