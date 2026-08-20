// params 
params {
    ref = "$projectDir/data/ref/GCF_900205735.1_N16961_v2_genomic.fna"
    reads = "$projectDir/data/reads/*.fastq"
    outDir = "$projectDir/results"
}

process ALIGN_READS {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)
    path ref

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam"), path("${sample_id}.sorted.bam.bai"), emit: bam_bei

    script:
    """
    // index the refrence genome
    bwa-mem2 index $ref

    bwa-mem2 mem -t ${task.cpus} $ref ${reads[0]} ${reads[1]} | \
        samtools sort -O bam -o ${sample_id}.sorted.bam

    samtools index ${sample_id}.sorted.bam

    """

}

workflow {

    ref_ch = Channel.fromPath(params.ref, checkIfExists: true)
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)

    ALIGN_READS(reads_ch, ref_ch)
}