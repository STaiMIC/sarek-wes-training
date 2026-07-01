#!/usr/bin/env nextflow
/*
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    LESSON 1: Understanding the WES Samplesheet (2–3 min)
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Quick lesson teaching:
    - CSV samplesheet format for Sarek
    - How Nextflow parses metadata
    - Channel operations on tabular data

    Run:
        nextflow run course/01_samplesheet.nf

    Expected output: 4 samples printed instantly (~3 seconds)
*/

nextflow.enable.dsl = 2

params.input = "${projectDir}/data/samplesheet.csv"

workflow {
    println("""
        ╔════════════════════════════════════════════════════════════════╗
        ║  LESSON 1: WES Samplesheet Structure (2–3 min)                ║
        ║                                                                ║
        ║  How does Nextflow read multi-sample WES data?                ║
        ║  → Answer: From a simple CSV file!                            ║
        ╚════════════════════════════════════════════════════════════════╝
    """)

    println("\n Reading samplesheet: ${params.input}\n")

    // Load and parse the CSV
    ch_samples = channel
        .fromPath(params.input, checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            def meta = [
                patient: row.patient,
                sex    : row.sex,
                status : row.status ?: '0',
                sample : row.sample,
                lane   : row.lane
            ]
            [
                meta,
                file(row.fastq_1, checkIfExists: false),
                file(row.fastq_2, checkIfExists: false)
            ]
        }

    // Display samples
    ch_samples.view { meta, r1, r2 ->
        "✓ [${meta.patient} | sex=${meta.sex} | status=${meta.status} | sample=${meta.sample} | ${r1.name}]"
    }

    // Summary
    ch_samples
        .collect()
        .view { samples ->
            "\n Total samples: ${samples.size()}\n"
        }

    println("""
         Key columns in samplesheet.csv (in order):
        • patient:  Groups samples from same individual
        • sex:      Biological sex (XX/XY) — required by Sarek
        • status:   0=normal/germline, 1=tumor
        • sample:   Unique sample identifier
        • lane:     Sequencing lane (e.g. L001)
        • fastq_1:  Forward reads (R1)
        • fastq_2:  Reverse reads (R2)

        💡 status=1 flags tumor samples so Strelka can run
           somatic (tumor vs. normal) variant calling automatically!
    """)
}