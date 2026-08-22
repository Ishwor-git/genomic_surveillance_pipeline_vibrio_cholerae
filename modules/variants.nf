process VARIANT_CALLING {
    tag "$sample_id"
    publishDir "${params.outDir}/vcf", mode: 'copy'

    input:
    tuple val(sample_id), path(bam), path(bai)
    path ref

    output:
    tuple val(sample_id), path("${sample_id}.raw.vcf"), emit: vcf_bei

    script:
    """
    # 1. Generate genotype likelihoods and call variants into a binary BCF
    bcftools mpileup -f $ref $bam | \
        bcftools call -mv -Ob -o ${sample_id}.raw.bcf 

    # 2. Convert the binary BCF into a human-readable raw VCF file
    bcftools view ${sample_id}.raw.bcf > ${sample_id}.raw.vcf
    """
}