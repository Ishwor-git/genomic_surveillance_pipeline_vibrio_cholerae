process TRIM_READS {
    tag "${sample_id} "
    publishDir "${params.outDir}/trimmed", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path(["${sample_id}_1.trim.fastq", "${sample_id}_2.trim.fastq"]), emit: trimmed
    path "${sample_id}.fastp.html", emit: html
    path "${sample_id}.fastp.json", emit: json

    script:
    """
        fastp \
            -i ${reads[0]} \
            -I ${reads[1]} \
            -o ${sample_id}_1.trim.fastq \
            -O ${sample_id}_2.trim.fastq \
            --html ${sample_id}.fastp.html \
            --json ${sample_id}.fastp.json
        """
}

