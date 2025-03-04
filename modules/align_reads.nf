process align_reads {
    container: community.wave.seqera.io/library/bowtie2:2.5.4--d51920539234bea7
    
    tag "$sample_id"
    
    input:
    tuple val(sample_id), path(reads)
    path index

    output:
    path "${sample_id}.sam"

    script:
    """
    bowtie2 -x $index -U $reads -S ${sample_id}.sam
    """
}