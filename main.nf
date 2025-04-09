#!/usr/bin/env nextflow

//-Set DSL Version-------------------------------------------------------//
nextflow.enable.dsl=2
//-----------------------------------------------------------------------//

//-Modules---------------------------------------------------------------//
include { index_fasta } from './modules/index_fasta.nf'
//-----------------------------------------------------------------------//

//-Workflow--------------------------------------------------------------//

workflow {
    // Get fasta files
    Channel
        .fromPath("${params.fasta_dir}/*.fa")
        .ifEmpty { error "No .fa format fasta files found in fasta_files" }
        .view { file -> "Found input file: ${file}" }
        .set { fasta_files }
    // Index fasta files
    index_fasta(fasta_files)
}

//-----------------------------------------------------------------------//