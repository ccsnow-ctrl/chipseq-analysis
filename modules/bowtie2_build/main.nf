#!/usr/bin/env nextflow
process BOWTIE2_BUILD {
    label 'process_medium'
    container 'ghcr.io/bf528/bowtie2:latest'
    publishDir params.outdir, mode:'copy'

    input:
    path genome

    output:
    path "bowtie2_index/*"

    script:
    """
    mkdir bowtie2_index
    bowtie2-build ${genome} bowtie2_index/hg38
    """
}
