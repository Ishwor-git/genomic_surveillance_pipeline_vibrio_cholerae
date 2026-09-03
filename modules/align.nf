process ALIGN_READS {
    tag "${sample_id}"
    publishDir "${params.outDir}/bam", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)
    tuple path(ref), path(ref_index_files)

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam"), path("${sample_id}.sorted.bam.bai"), emit: bam_bei

    script:
    """
    bwa-mem2 mem -t ${task.cpus} ${ref} ${reads[0]} ${reads[1]} | \
        samtools sort -O bam -o ${sample_id}.sorted.bam

    samtools index ${sample_id}.sorted.bam
    """
}
