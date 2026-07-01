#!/usr/bin/env nextflow
/*
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    LESSON 2: Quality Control with FASTP (2 min)
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Teaches:
    - Why QC is the first step in any NGS pipeline
    - What FASTP checks and removes
    - How to interpret QC metrics

    Run:
        nextflow run course/02_fastp_qc.nf
*/

nextflow.enable.dsl = 2

workflow {
    println("""
        ╔════════════════════════════════════════════════════════════════╗
        ║  LESSON 2: Quality Control with FASTP                          ║
        ╚════════════════════════════════════════════════════════════════╝

         RAW READS COME IN DIRTY. FASTP CLEANS THEM.

        What FASTP checks per read:
        ┌─────────────────────────────────────────────────────┐
        │    Adapter sequences    → trimmed off               │
        │    Low quality bases   → removed from ends          │
        │    Short reads (<15bp) → discarded entirely         │
        │    Per-base quality    → Q-score plotted            │
        │    Duplicate rate      → flagged for awareness      │
        └─────────────────────────────────────────────────────┘

        What a Q-score means:
        • Q10 = 90%   base call accuracy  (1 error in 10)
        • Q20 = 99%   base call accuracy  (1 error in 100)
        • Q30 = 99.9% base call accuracy  (1 error in 1000)  target

        In our pipeline (main.sh):
        → trim_fastq = false because nf-core test reads are already clean
        → In real WES data you would ALWAYS trim first

          After bash main.sh runs, check:
           results/multiqc/multiqc_report.html → FASTP section
           Look for: % reads passing filter (should be >95%)
    """)
}
