#!/usr/bin/env nextflow
process BEDTOOLS_REMOVE {
    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode:'copy'
    
    input:
    path blacklist
    path peaks
    
    output:
    path 'repr_peaks_filtered.bed'
    
    script:
    """
    bedtools subtract -a ${peaks} -b ${blacklist} -A > repr_peaks_filtered.bed
    """
    
    stub:
    """
    touch repr_peaks_filtered.bed
    """
}