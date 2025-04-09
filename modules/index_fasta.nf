#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process index_fasta {

    tag "$fasta.getBaseName()"

    input:
    path fasta

    output:
    path "${params.intermediates_dir}/${fasta.getBaseName()}_index/"

    script:
    def file_name = fasta.getName()
    def base_name = fasta.getBaseName()

    """
    mkdir -p ${params.intermediates_dir}/${base_name}_index
    bowtie2-build ${file_name} ${params.intermediates_dir}/${base_name}_index/${base_name}
    """
}