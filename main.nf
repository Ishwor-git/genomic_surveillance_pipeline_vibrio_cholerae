// params 
    params.ref = "$projectDir/data/ref/GCF_900205735.1_N16961_v2_genomic.fna"
    params.reads = "$projectDir/data/reads/SRR40299199_{1,2}.fastq"
    params.outDir = "$projectDir/results/"

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

workflow {

    ref_ch = Channel.fromPath(params.ref, checkIfExists: true)
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)

    ALIGN_READS(reads_ch, ref_ch)
}