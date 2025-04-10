#!/usr/bin/env nextflow

//-Set DSL Version-------------------------------------------------------//
nextflow.enable.dsl=2
//-----------------------------------------------------------------------//

//-Modules---------------------------------------------------------------//
include { index_fasta } from './modules/index_fasta.nf'
include { align_reads } from './modules/align_reads.nf'
//-----------------------------------------------------------------------//

//-Workflow--------------------------------------------------------------//

workflow {
    // Get experimental data
    Channel
        .fromPath("experimental_design.csv")
        .splitCsv(header: true, sep: ",")
        .map { row ->
            tuple(
                row.sample_id,
                row.path_reference_genome,
                row.path_reads_file_R1,
                row.path_reads_file_R2
            )
        }
        .map { sample_id,
            path_reference_genome,
            path_reads_file_R1,
            path_reads_file_R2 ->
                tuple(sample_id,
                file(path_reference_genome),
                file(path_reads_file_R1),
                file(path_reads_file_R2)) }
        .set { experimental_data }
    
    //
experimental_data
        .map { sample_id,
            path_reference_genome,
            path_reads_file_R1,
            path_reads_file_R2 ->
                tuple(sample_id,
                path_reference_genome) }
        .set { fasta_files }
    
    // Index fasta files
    index_fasta(fasta_files)
    .set {indexed_fasta}

    // Combine all indexed fasta and experimental_data tuple
experimental_data
        .map { sample_id,
            path_reference_genome,
            path_reads_file_R1,
            path_reads_file_R2 ->
                tuple(sample_id,
                path_reads_file_R1,
                path_reads_file_R2) }
        .combine(indexed_fasta)
        .view()
        .set {experimental_data_indexed}

    // Subset experimental_indexed 
    // Align reads
align_reads(experimental_data_indexed).view()

}

//-----------------------------------------------------------------------//