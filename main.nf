#!/usr/bin/env nextflow

//-Set DSL Version-------------------------------------------------------//
nextflow.enable.dsl=2
//-----------------------------------------------------------------------//

//-Modules---------------------------------------------------------------//
include { index_fasta } from './modules/index_fasta.nf'
include { align_reads } from './modules/align_reads.nf'
include { sam_to_bam } from './modules/sam_to_bam.nf'
include { bam_sort } from './modules/bam_sort.nf'
include { variant_call } from './modules/variant_call.nf'
//-----------------------------------------------------------------------//

//-Workflow--------------------------------------------------------------//

workflow {


//-----------------------------------------------------------------//
// Channel: Set Experimental Data Channel
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
        .set { experimental_data_channel }
//-----------------------------------------------------------------//


//-----------------------------------------------------------------//
// Channel: Set Fasta channel
experimental_data_channel
        .map { sample_id,
            path_reference_genome,
            path_reads_file_R1,
            path_reads_file_R2 ->
                tuple(sample_id,
                path_reference_genome) }
        .set { fasta_channel }  
// Process: Index fasta files
    index_fasta(fasta_channel)
    .set {indexed_fasta}
//-----------------------------------------------------------------//


//-----------------------------------------------------------------//
// Channel: Set index_channel
experimental_data_channel
        .map { sample_id,
            path_reference_genome,
            path_reads_file_R1,
            path_reads_file_R2 ->
                tuple(sample_id,
                path_reads_file_R1,
                path_reads_file_R2) }
        .combine(indexed_fasta)
        .set {index_channel}
// Process: Align reads
align_reads(index_channel)
    .set { aligned_sam }
//-----------------------------------------------------------------//


//-----------------------------------------------------------------//
//Process: Convert sam to bam
sam_to_bam (aligned_sam.sam_file)
    .set { aligned_bam }
//-----------------------------------------------------------------//


//-----------------------------------------------------------------//
    // Convert bam to sorted bam
bam_sort (aligned_bam.bam_file)
    .set { sorted_bam }
//-----------------------------------------------------------------//


//-----------------------------------------------------------------//
    // Combine sample_id to sorted bam tuple
fasta_channel
    .combine(sorted_bam)
    .view()
    .set { variant_call_channel }
    // Call variants
variant_call (variant_call_channel)
    .set { variant_call }
//-----------------------------------------------------------------//
}
