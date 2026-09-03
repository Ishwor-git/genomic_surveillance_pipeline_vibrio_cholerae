process PREPARE_REFERENCE {
    tag "reference"
    container 'vibrio-mapping:1.0'
    publishDir "${params.outDir}/reference", mode: 'copy'

    input:
    path ref

    output:
    tuple path(ref), path("${ref}.*"), emit: indexed_ref

    script:
    """
    bwa-mem2 index ${ref}
    samtools faidx ${ref}
    """
}
