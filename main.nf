// params 
    params.ref = "$projectDir/data/ref/GCF_900205735.1_N16961_v2_genomic.fna"
    params.reads = "$projectDir/data/reads/SRR40299199_{1,2}.fastq"
    params.outDir = "$projectDir/results/"

//imports
    include { ALIGN_READS } from './modules/align.nf'

workflow {

    ref_ch = Channel.fromPath(params.ref, checkIfExists: true)
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)

    ALIGN_READS(reads_ch, ref_ch)
}