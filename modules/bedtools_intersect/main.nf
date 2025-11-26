#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple path (bed1), path (bed2)

    output:
    path 'repr_peaks.bed'


    script:
    """
    bedtools intersect -a ${bed1} -b ${bed2}  > repr_peaks.bed 
    """
   // bedtools intersect -a ${bed1} -b ${bed2}  -f .5 - r > repr_peaks.bed --> Joeys
    stub:
    """
    touch repr_peaks.bed
    """
}