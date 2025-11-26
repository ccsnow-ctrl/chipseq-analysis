#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_low'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'
    
    input:
    path peaks
    path genome
   // path genome
    
    output:
    path 'motifs'
    
    script:
    """
    findMotifsGenome.pl ${peaks} ${genome} motifs -size 200
    """
    
    stub:
    """
    mkdir motifs
    """
}