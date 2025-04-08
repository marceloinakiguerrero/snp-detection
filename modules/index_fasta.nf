#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process index_fasta {

    tag "$fasta.getBaseName()"

    input:
    path fasta

    output:
    path "${fasta.getBaseName()}/"

    script:
    def file_name = fasta.getName()
    def base_name = fasta.getBaseName()

    """
    mkdir -p ${base_name}_index
    bowtie2-build ${file_name} ${base_name}_index/${base_name}
    mv ${base_name}/*.bt2 ${base_name}_index/
    """
}