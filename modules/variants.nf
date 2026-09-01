process VARIANT_CALLING {
    tag "${sample_id}"
    publishDir "${params.outDir}/vcf", mode: 'copy'

    input:
    tuple val(sample_id), path(bam), path(bai)
    tuple path(ref), path(ref_index_files), path(ref_dict)

    output:
    tuple val(sample_id), path("${sample_id}.raw.vcf.gz"), path("${sample_id}.raw.vcf.gz.csi"), emit: vcf_bei

    script:
    """
    bcftools mpileup -f ${ref} ${bam} | \
        bcftools call -mv -Oz -o ${sample_id}.raw.vcf.gz

    bcftools index ${sample_id}.raw.vcf.gz
    """
}

