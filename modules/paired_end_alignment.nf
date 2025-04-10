#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process paired_end_alignment {
    input:
    tuple val(sample_id), path(reads)
    path index_dir

    output:
    path "${sample_id}.sam"

    script:
    def fasta_name = index_dir.getName().replaceAll('_index$', '')

    """
    bowtie2 -x ${index_dir}/${fasta_name} \\
            -1 ${reads[0]} \\
            -2 ${reads[1]} \\
            -S ${sample_id}.sam
    """
}