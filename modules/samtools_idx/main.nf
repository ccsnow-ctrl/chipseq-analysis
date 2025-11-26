process SAMTOOLS_IDX {
    label 'process_low'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
        tuple val(sample_id), path(sorted_bam)

    output:
        tuple val(sample_id), path(sorted_bam), path("${sample_id}.sorted.bam.bai")

    script:
    """
    samtools index $sorted_bam
    """
    
    stub:
    """
    touch ${sample_id}.sorted.bam.bai
    """
}
