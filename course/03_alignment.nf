#!/usr/bin/env nextflow
/*
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    LESSON 3: Read Alignment with BWA-MEM (2 min)
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Teaches:
    - What alignment does and why it matters
    - What a BAM file is
    - What MarkDuplicates removes and why

    Run:
        nextflow run course/03_alignment.nf
*/

nextflow.enable.dsl = 2

workflow {
    println("""
        ╔════════════════════════════════════════════════════════════════╗
        ║  LESSON 3: Alignment with BWA-MEM + MarkDuplicates             ║
        ╚════════════════════════════════════════════════════════════════╝

          ALIGNMENT = MAPPING READS BACK TO THE REFERENCE GENOME

        The journey of one read:
        ┌──────────────────────────────────────────────────────────────┐
        │  FASTQ read:  ATCGGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGC     │
        │                          ↓ BWA-MEM                           │
        │  Reference:   chr21:10,539,400–10,539,440    match found     │
        │                          ↓                                   │
        │  BAM output:  chr21  10539400  60  ATCGGCT...  (aligned)     │
        └──────────────────────────────────────────────────────────────┘

        What a BAM file contains (one line per read):
        • Chromosome + position where the read mapped
        • Mapping quality (MAPQ) — confidence of the alignment
        • CIGAR string — how the read aligns (matches, gaps, clips)
        • The original sequence + base quality scores

        WES target coverage:
        • We expect ~100x depth at exon regions
        • Low coverage (<20x) = unreliable variant calls
        • Check this in MultiQC → Mosdepth section

        MarkDuplicates — why it matters:
        ┌──────────────────────────────────────────────────────────────┐
        │  PCR amplification creates IDENTICAL copies of the same      │
        │  original molecule — these are NOT real biological reads.    │
        │  MarkDuplicates flags them so variant callers ignore them.   │
        │  Without this step → false high allele frequencies!          │
        └──────────────────────────────────────────────────────────────┘

          After bash main.sh runs, check:
           results/preprocessing/ → your aligned BAM files live here
           results/multiqc/multiqc_report.html → alignment + dup rate
    """)
}
