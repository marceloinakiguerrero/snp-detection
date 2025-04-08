#!/usr/bin/env nextflow

//-Set DSL Version--------------------------------------------------------//
nextflow.enable.dsl=2
//-----------------------------------------------------------------------//

//-Modules---------------------------------------------------------------//
include { index_fasta } from './modules/index_fasta.nf'
//-----------------------------------------------------------------------//


//-Workflow--------------------------------------------------------------//

workflow {
    // Get input files
    kinetic_data = Channel.fromPath(params.kinetic_data)
        .ifEmpty { error "No input files found in ${params.kinetic_data}" }
    // Fit the easylinear model
    fit_easylinear(kinetic_data)

}

//-----------------------------------------------------------------------//

