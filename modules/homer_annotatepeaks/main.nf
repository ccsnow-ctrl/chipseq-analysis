#!/usr/bin/env nextflow
process ANNOTATE {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'
    
    input:
    path peaksfile
    path genome
    path gtf
    
    output:
    path 'annotated_peaks.txt'
    
    script:
    """
    annotatePeaks.pl ${peaksfile} ${genome} -gtf ${gtf} > annotated_peaks.txt
    """
    
    stub:
    """
    touch annotated_peaks.txt
    """
}