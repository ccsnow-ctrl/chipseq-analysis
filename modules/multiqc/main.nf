#!/usr/bin/env nextflow

process MULTIQC {

    label 'process_low'
    container 'ghcr.io/bf528/multiqc:latest'
    publishDir './results/', mode: 'copy'
    
    input:
    path(files)

    output:
    path "multiqc_report.html"

    script:
    """
    
    multiqc -f .


    """
    stub:
    """
    touch multiqc_report.html
    """
}