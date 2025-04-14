#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process variant_call {

    input:
    tuple val(sample_id), file(path_reference_genome), file(sorted_bam)

    output:
    path "${sample_id}_variant_call"

    script:
    """
    mkdir ${sample_id}_variant_call \
    freebayes -f ${path_reference_genome} ${sorted_bam}.bam > ${sample_id}.vcf \
    mv ${sample_id}.vcf ${sample_id}_variant_call/
    """
}