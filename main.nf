// params
params.ref = "$projectDir/data/ref/GCF_900205735.1_N16961_v2_genomic.fna"
params.metadata = "$projectDir/data/metadata.csv"
params.reads = "$projectDir/data/reads/*/*_{1,2}.fastq"
params.outDir = "$projectDir/results/"

params.amrfinder_db = "$projectDir/data/amrfinder_db"
params.mlst_db = null

// imports
include { PREPARE_REFERENCE } from './modules/prepare_ref.nf'
include { ALIGN_READS }       from './modules/align.nf'
include { VARIANT_CALLING }   from './modules/variants.nf'
include { SCREEN_AMR }        from './modules/amr.nf'
include { TRIM_READS }        from './modules/trim.nf'
include { GENERATE_CONSENSUS } from './modules/consensus.nf'

workflow {
    metadata_ch = Channel.fromPath(params.metadata, checkIfExists: true)
    reads_ch    = Channel.fromFilePairs(params.reads, checkIfExists: true)
    ref_ch      = Channel.fromPath(params.ref, checkIfExists: true)

    PREPARE_REFERENCE(ref_ch)

    TRIM_READS(reads_ch)

    ALIGN_READS(TRIM_READS.out.trimmed, PREPARE_REFERENCE.out.indexed_ref)

    VARIANT_CALLING(ALIGN_READS.out.bam_bei, PREPARE_REFERENCE.out.indexed_ref)

    GENERATE_CONSENSUS(VARIANT_CALLING.out.vcf_bei, PREPARE_REFERENCE.out.indexed_ref)

    SCREEN_AMR(GENERATE_CONSENSUS.out.consensus_fasta)
}