process SCREEN_AMR {
    tag "${sample_id}"
    container 'vibrio-amr:1.0'
    publishDir "${params.outDir}/amr", mode: 'copy'

    input:
    tuple val(sample_id), path(consensus)

    output:
    tuple val(sample_id), path("${sample_id}.amr.tsv"), emit: amr_tsv

    script:
    """
    amrfinder -n ${consensus} --plus -o ${sample_id}.amr.tsv
    """
}
