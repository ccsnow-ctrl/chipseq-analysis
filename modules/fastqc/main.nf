#!/usr/bin/env nextflow

process FASTQC {

    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest'
    publishDir params.outdir, mode: 'copy'
    // REP_1, fastqcfile
    // could i call "reads" anythig?
    input:
    tuple val(sample_id) , path(reads)
    // keep the ame for each but merge into report (html) anz zip file for our multiqx
    output:
    tuple val(sample_id), path("*_fastqc.html"), emit: html
    tuple val(sample_id), path("*_fastqc.zip"), emit: zip

    script:
    """
    fastqc -t $task.cpus $reads
    """

    stub:
    """
    touch stub_${sample_id}_fastqc.zip
    touch stub_${sample_id}_fastqc.html
    """
}