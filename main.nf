#!/usr/bin/env nextflow

//-Set DSL Version--------------------------------------------------------//
nextflow.enable.dsl=2
//-----------------------------------------------------------------------//

//-Modules---------------------------------------------------------------//
include { index_fasta } from './modules/index_fasta.nf'
//-----------------------------------------------------------------------//

//-Parameters------------------------------------------------------------//

//Input paths
params.fasta_dir = "$launchDir/fasta_files"
params.reads_dir = "$launchDir/reads_files"

//Output Paths
params.intermediates_dir = "$launchDir/intermediate_files"
params.results_dir = "$launchDir/results"

//----------------------------------------------------------------------//



//-Workflow--------------------------------------------------------------//

workflow {
    // Get fasta files
    fasta_files = Channel
        .fromPath("${params.fasta_dir}/*.fa")
        .ifEmpty { error "No .fa format fasta files found in fasta_files" }
        .tap { files ->
            println "Found input files:"
            files.each { println "- ${it}"}
        }
        .map { it }
    // Index fasta files
    index_fasta(fasta_files)
}

//-----------------------------------------------------------------------//

