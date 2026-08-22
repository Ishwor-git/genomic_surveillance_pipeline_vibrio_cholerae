process ALIGN_READS {
    tag "$sample_id"
    publishDir "${params.outDir}/bam", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)
    path ref

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam"), path("${sample_id}.sorted.bam.bai"), emit: bam_bei

    script:
    """
    #uncompress the gz if there
    if [[ $ref == *.gz ]]; then
        gunzip -c $ref > ${sample_id}.fasta
        ref=${sample_id}.fasta
    fi

    # index the refrence genome
    bwa-mem2 index $ref

    #allaign reads to the reference genome and sort the output
    bwa-mem2 mem -t ${task.cpus} $ref ${reads[0]} ${reads[1]} | \
        samtools sort -O bam -o ${sample_id}.sorted.bam

    # index the sorted bam file
    samtools index ${sample_id}.sorted.bam

    """

}