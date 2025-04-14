#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process bam_sort {

    input:
    tuple val(sample_id), file(aligned_bam)

    output:
    path("${sample_id}_bam/${sample_id}.sorted.bam"), emit: sorted_bam

    script:
    """
     samtools sort ${sample_id}_bam/${sample_id}.bam -o ${sample_id}_bam/${sample_id}.sorted.bam \
    """
}