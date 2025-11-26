#!/usr/bin/env nextflow

/*
 * Clean, error-proof version file.
 * Uses only simple commands and no subshells.
 */

process FASTQC_VERSION {
    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest'
    publishDir params.outdir, mode: 'copy'

    output:
    path "fastqc.versions.txt"

    script:
    """
    fastqc --version > fastqc.versions.txt
    """
}

process TRIMMOMATIC_VERSION {
    label 'process_low'
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir params.outdir, mode: 'copy'

    output:
    path "trimmomatic.versions.txt"

    script:
    """
    trimmomatic -version > trimmomatic.versions.txt 2>&1
    """
}

process BOWTIE2_VERSION {
    label 'process_low'
    container 'ghcr.io/bf528/bowtie2:latest'
    publishDir params.outdir, mode: 'copy'

    output:
    path "bowtie2.versions.txt"

    script:
    """
    bowtie2 --version > bowtie2.versions.txt 2>&1
    """
}

process SAMTOOLS_VERSION {
    label 'process_low'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode: 'copy'

    output:
    path "samtools.versions.txt"

    script:
    """
    samtools --version > samtools.versions.txt 2>&1
    """
}

process DEEPTOOLS_VERSION {
    label 'process_low'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    output:
    path "deeptools.versions.txt"

    script:
    """
    bamCoverage --version > deeptools.versions.txt 2>&1
    computeMatrix --version >> deeptools.versions.txt 2>&1
    plotProfile --version >> deeptools.versions.txt 2>&1
    plotCorrelation --version >> deeptools.versions.txt 2>&1
    multiBigwigSummary --version >> deeptools.versions.txt 2>&1
    """
}

process MULTIQC_VERSION {
    label 'process_low'
    container 'ghcr.io/bf528/multiqc:latest'
    publishDir params.outdir, mode: 'copy'

    output:
    path "multiqc.versions.txt"

    script:
    """
    multiqc --version > multiqc.versions.txt 2>&1
    """
}

process HOMER_VERSION {
    label 'process_low'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'

    output:
    path "homer.versions.txt"

    script:
    """
    echo "annotatePeaks.pl:" > homer.versions.txt
    annotatePeaks.pl 2>&1 | head -n 3 >> homer.versions.txt
    echo "" >> homer.versions.txt

    echo "findPeaks:" >> homer.versions.txt
    findPeaks 2>&1 | head -n 3 >> homer.versions.txt
    echo "" >> homer.versions.txt

    echo "makeTagDirectory:" >> homer.versions.txt
    makeTagDirectory 2>&1 | head -n 3 >> homer.versions.txt
    echo "" >> homer.versions.txt

    echo "findMotifsGenome.pl:" >> homer.versions.txt
    findMotifsGenome.pl 2>&1 | head -n 3 >> homer.versions.txt
    """
}

process BEDTOOLS_VERSION {
    label 'process_low'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode:'copy'

    output:
    path "bedtools.versions.txt"

    script:
    """
    bedtools --version > bedtools.versions.txt 2>&1
    """
}
