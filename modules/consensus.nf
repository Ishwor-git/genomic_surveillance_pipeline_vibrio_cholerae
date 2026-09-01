process GENERATE_CONSENSUS {
    tag "${sample_id}"
    publishDir "${params.outDir}/consensus", mode: 'copy'

    input:
    tuple val(sample_id), path(vcf), path(csi)
    tuple path(ref), path(ref_index_files), path(ref_dict)

    output:
    tuple val(sample_id), path("${sample_id}.consensus.fasta"), emit: consensus_fasta

    script:
    """
    bcftools consensus -f ${ref} ${vcf} > ${sample_id}.consensus.fasta
    """
}

