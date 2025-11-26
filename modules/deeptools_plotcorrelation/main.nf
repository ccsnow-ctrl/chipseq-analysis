#!/usr/bin/env nextflow

process PLOTCORRELATION {
    label 'process_low'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path npz_file

    output:
    path "correlation_matrix.tsv"
    path "plot.png"

    script:
    """
    plotCorrelation \
        -in ${npz_file} \
        -c spearman \
        -p heatmap \
        -o plot.png \
        --outFileCorMatrix correlation_matrix.tsv
    """

    stub:
    """
    touch plot.png
    touch correlation_matrix.tsv
    """
}
