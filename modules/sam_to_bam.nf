#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process sam_to_bam {

    input:
    tuple val(sample_id), file(aligned_sam)

    output:
    tuple val(sample_id), path("${sample_id}_bam/"), emit: bam_file

    script:
    """
    mkdir -p ${sample_id}_bam
    samtools view -bS ${aligned_sam} > ${sample_id}.bam
    mv ${sample_id}.bam ${sample_id}_bam/
    """
}