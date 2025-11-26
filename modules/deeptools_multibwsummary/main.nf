#!/usr/bin/env nextflow

process MULTIBWSUMMARY {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path bw_files

    output:
    path "matrix.npz"

    script:
    """
    multiBigwigSummary bins \
        -b ${bw_files.join(' ')} \
        --binSize 1000 \
        -o matrix.npz
    """

    stub:
    """
    touch matrix.npz
    """
}
