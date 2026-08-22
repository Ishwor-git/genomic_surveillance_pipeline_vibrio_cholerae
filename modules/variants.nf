process VARIANT_CALLING {
    tag "$sample_id"
    publishDir "${params.outDir}/vcf", mode: 'copy'

    input:
    tuple val(sample_id), path(bam), path(bai)
    path ref

    output:
    tuple val(sample_id), path("${sample_id}.raw.vcf.gz"),path("${sample_id}.raw.vcf.gz.csi"), emit: vcf_bei

    script:
    """
    # 1. Generate genotype likelihoods and call variants into a binary BCF
    bcftools mpileup -f $ref $bam | \
        bcftools call -mv -Oz -o ${sample_id}.raw.vcf.gz

    # 4. Index the raw VCF file
    bcftools index ${sample_id}.raw.vcf.gz
    """
}