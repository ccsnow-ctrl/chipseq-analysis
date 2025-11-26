#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(bigwig)  // Your signal data
    path genes                           // Your hg38_genes.bed file

    output:
    tuple val(sample_id), path("${sample_id}_matrix.gz")

    script:
    """
    computeMatrix scale-regions -S ${bigwig} -R ${genes} -b 2000 -a 2000 -o ${sample_id}_matrix.gz   
    """
    stub:
    
    """
    touch ${sample_id}_matrix.gz
    """
}
