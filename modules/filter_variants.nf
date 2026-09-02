process FILTER_VARIANTS {
    tag "${sample_id}"
    publishDir "${params.outDir}/vcf_filtered", mode: 'copy'

    input:
    tuple val(sample_id), path(vcf), path(vcf_index)
    tuple path(ref), path(ref_index_files), path(ref_dict)

    output:
    tuple val(sample_id), path("${sample_id}.filtered.vcf.gz"), path("${sample_id}.filtered.vcf.gz.csi"), emit: filtered_vcf

    script:
    """
    bcftools norm -f ${ref} ${vcf} -Oz -o ${sample_id}.norm.vcf.gz
    bcftools index ${sample_id}.norm.vcf.gz

    bcftools filter -e 'QUAL<30 || INFO/DP<10 || INFO/AF<0.8' ${sample_id}.norm.vcf.gz -Oz -o ${sample_id}.filtered.vcf.gz
    bcftools index ${sample_id}.filtered.vcf.gz
    """
}
