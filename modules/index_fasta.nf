#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process index_fasta {

    input:
    path fasta

    output:
    path "${fasta.simpleName}_index", emit: index_dir

    script:
    def file_name = fasta.getName()
    def base_name = file_name.replaceAll(/\.fa(sta)?$/, "")

    """
    mkdir -p ${base_name}_index
    bowtie2-build ${file_name} ${base_name}_index/${base_name}
    """
}