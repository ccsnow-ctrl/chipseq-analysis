#!/usr/bin/env nextflow

include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {MULTIQC} from './modules/multiqc'
include {MULTIBWSUMMARY} from './modules/deeptools_multibwsummary'
include {PLOTCORRELATION} from './modules/deeptools_plotcorrelation'
include {TAGDIR} from './modules/homer_maketagdir'
include {FINDPEAKS} from './modules/homer_findpeaks'
include {POS2BED} from './modules/homer_pos2bed'
include {BEDTOOLS_INTERSECT} from './modules/bedtools_intersect'
include {BEDTOOLS_REMOVE} from './modules/bedtools_remove'
include {ANNOTATE} from './modules/homer_annotatepeaks'
include {COMPUTEMATRIX} from './modules/deeptools_computematrix'
include {FIND_MOTIFS_GENOME} from './modules/homer_findmotifsgenome'
include {PLOTPROFILE} from './modules/deeptools_plotprofile'
include {
    FASTQC_VERSION;
    TRIMMOMATIC_VERSION;
    BOWTIE2_VERSION;
    SAMTOOLS_VERSION;
    DEEPTOOLS_VERSION;
    MULTIQC_VERSION;
    HOMER_VERSION;
    BEDTOOLS_VERSION
} from './modules/tool_versions'



workflow {

    //create channels for each file given 
    genome_ch = params.genome
    gtf_ch = params.gtf
    ucsc_ch = params.ucsc_genes
    blacklist_ch = params.blacklist
    adapters_ch = params.adapter_fa
    hg_ch = Channel.fromPath(params.hg38_genes)
    // channel1
    Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { reads_ch }

    
    FASTQC(reads_ch)

    reads_trim_ch = reads_ch.map{ sample_id, reads ->
    tuple(sample_id, reads, file(adapters_ch))
    }


    TRIM(reads_trim_ch)
    BOWTIE2_BUILD(genome_ch)
    BOWTIE2_ALIGN(BOWTIE2_BUILD.out,TRIM.out)
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out)
    SAMTOOLS_IDX(SAMTOOLS_SORT.out)
    BAMCOVERAGE(SAMTOOLS_IDX.out)
    SAMTOOLS_FLAGSTAT(BOWTIE2_ALIGN.out)

    bw_list = BAMCOVERAGE.out.map{ id, bw -> bw }.collect()
    MULTIBWSUMMARY(bw_list)
    PLOTCORRELATION(MULTIBWSUMMARY.out)
    multi_ch = FASTQC.out.html.map{ t -> t[1] }
        .mix(FASTQC.out.zip.map{ t -> t[1] })
        .mix(TRIM.out.trimmed.map{ t -> t[1] })
        .mix(SAMTOOLS_FLAGSTAT.out.map{ t -> t[1] })
        .collect()

    MULTIQC(multi_ch)

   TAGDIR.out
    | map { name, path -> tuple(name.split('_')[1], [(path.baseName.split('_')[0]): path]) }
    | groupTuple(by: 0)
    | map { rep, maps -> tuple(rep, maps[0] + maps[1])}
    | map { rep, samples -> tuple(rep, samples.IP, samples.INPUT)}
    | set { peakcalling_ch }
    FINDPEAKS(peaks_ch)
    
    // Use the named output channel
    peaktobed_ch = FINDPEAKS.out.peaks
    POS2BED(peak)
    POS2BED.out
        .map { rep, bed -> bed }// Extract just the BED files
        .collect()// Collect all BED files into a list
        .map { beds -> tuple(beds[0], beds[1]) }// Create tuple of (bed1, bed2)
        .set { pos_ch }

    BEDTOOLS_INTERSECT (pos_ch )
    BEDTOOLS_REMOVE (blacklist_ch, BEDTOOLS_INTERSECT.out)
    ANNOTATE (BEDTOOLS_REMOVE.out, genome_ch, gtf_ch)

// Filter for only IP samples
    ip_bw_ch = BAMCOVERAGE.out
        .filter { sample_id, bw -> sample_id.contains('IP') }

    genes_ch = Channel.value(file(params.hg38_genes))

    COMPUTEMATRIX(ip_bw_ch, genes_ch)
    PLOTPROFILE(COMPUTEMATRIX.out)
    FIND_MOTIFS_GENOME( BEDTOOLS_REMOVE.out, hg_ch)
        // Record tool versions (runs once per tool, writes into results/)
    FASTQC_VERSION()
    TRIMMOMATIC_VERSION()
    BOWTIE2_VERSION()
    SAMTOOLS_VERSION()
    DEEPTOOLS_VERSION()
    MULTIQC_VERSION()
    HOMER_VERSION()
    BEDTOOLS_VERSION()

}