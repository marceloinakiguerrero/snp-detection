#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process align_reads {
    input:
    tuple val(sample_id), file(path_reads_file_R1), file(path_reads_file_R2), file(indexed_fasta)

    output:
    tuple val(sample_id), path("${sample_id}_sam/${sample_id}.sam"), emit: sam_file

    script:

    """
    echo "Read 1: ${path_reads_file_R1}"
    echo "Read 2: ${path_reads_file_R2}"
    echo "Indexed fasta: ${indexed_fasta}"
    mkdir -p ${sample_id}_sam
    bowtie2 -x ${indexed_fasta}/${sample_id} \
            -1 ${path_reads_file_R1} \
            -2 ${path_reads_file_R2} \
            -S ${sample_id}.sam
    mv ${sample_id}.sam ${sample_id}_sam/
    """
}