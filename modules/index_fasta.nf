#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process index_fasta {

    input:
    tuple val(sample_id), file(path_reference_genome)

    output:
    path "${sample_id}_fasta_index"

    script:
    """
    mkdir -p ${sample_id}_fasta_index
    bowtie2-build ${path_reference_genome} ${sample_id}_fasta_index/${sample_id}
    """
}