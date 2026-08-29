// params 
    params.ref = "$projectDir/data/ref/GCF_900205735.1_N16961_v2_genomic.fna"
    params.reads = "$projectDir/data/reads/srr40299199/SRR40299199_{1,2}.fastq"
    params.outDir = "$projectDir/results/"

//imports
    include { ALIGN_READS } from './modules/align.nf'
    include { VARIANT_CALLING } from './modules/variants.nf'
    include { SCREEN_AMR } from './modules/amr.nf'
    include { TRIM_READS } from './modules/trim.nf'
    include {GENERATE_CONSENSUS} from './modules/consensus.nf'

workflow {

    ref_ch = Channel.fromPath(params.ref, checkIfExists: true)
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)

    // ALIGN_READS(reads_ch, ref_ch)
    TRIM_READS(reads_ch)

    ALIGN_READS(TRIM_READS.out.trimmed, ref_ch)

    VARIANT_CALLING(ALIGN_READS.out.bam_bei, ref_ch)

    GENERATE_CONSENSUS(VARIANT_CALLING.out.vcf_bei, ref_ch)

    SCREEN_AMR(GENERATE_CONSENSUS.out.consensus_fasta) 

}