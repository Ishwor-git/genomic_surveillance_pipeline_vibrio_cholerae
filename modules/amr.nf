process SCREEN_AMR {
    tag "$sample_id"
    publishDir "${params.outDir}/amr", mode: 'copy'

    input:
    tuple val(sample_id), path(assembly)

    output:
    tuple val(sample_id), path("${sample_id}.amr.tsv"), emit: amr_tsv

    script:
    """
    amrfinder -n $assembly --plus -o ${sample_id}.amr.tsv
    """
}