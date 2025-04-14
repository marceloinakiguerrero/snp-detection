#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process bam_sort {

    input:
    tuple val(sample_id), file(aligned_bam)

    output:
    tuple val (sample_id), path("${sample_id}_bam/${sample_id}.sorted.bam"), emit: sorted_bam

    script:
    """
     samtools sort ${sample_id}_bam/${sample_id}.bam -o ${sample_id}_bam/${sample_id}.sorted.bam \
    """
}