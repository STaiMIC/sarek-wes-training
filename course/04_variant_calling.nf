#!/usr/bin/env nextflow
/*
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    LESSON 4: Variant Calling with Strelka (2 min)
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Teaches:
    - What a variant is
    - How Strelka finds germline vs somatic variants
    - How to read a VCF file
    - What VEP annotation adds on top

    Run:
        nextflow run course/04_variant_calling.nf
*/

nextflow.enable.dsl = 2

workflow {
    println("""
        ╔════════════════════════════════════════════════════════════════╗
        ║  LESSON 4: Variant Calling with Strelka                        ║
        ╚════════════════════════════════════════════════════════════════╝

          VARIANT CALLING = FINDING WHERE YOUR SAMPLE DIFFERS FROM REFERENCE

        Types of variants Strelka finds:
        ┌──────────────────────────────────────────────────────────────┐
        │  SNV  (Single Nucleotide Variant)  A → T at one position     │
        │  INDEL (Insertion/Deletion)        ATG → A (2bp deleted)     │
        └──────────────────────────────────────────────────────────────┘

        Germline vs Somatic — our samplesheet design:
        ┌──────────────────────────────────────────────────────────────┐
        │  patient1  status=0  NA12878_1  → GERMLINE calling           │
        │  patient1  status=0  NA12878_2  → replicate check            │
        │  patient2  status=1  tumor      → SOMATIC calling  ┐         │
        │  patient2  status=0  normal     → background       ┘ paired  │
        └──────────────────────────────────────────────────────────────┘

        How to read a VCF line:
        CHROM    POS       ID  REF  ALT  QUAL  FILTER  INFO
        chr21    10539445  .   C    T    100   PASS    DP=120;AF=0.48

        • CHROM/POS  = where on the genome
        • REF        = what the reference says
        • ALT        = what YOUR sample has instead
        • QUAL       = confidence score (higher = better)
        • FILTER     = PASS means it passed all quality filters
        • DP         = depth (how many reads covered this site)
        • AF         = allele frequency (0.48 = ~50% of reads show ALT)

        AF interpretation:
        • AF ~0.5  = heterozygous germline variant (one copy changed)
        • AF ~1.0  = homozygous germline variant (both copies changed)
        • AF ~0.1–0.3 = possible somatic mutation (subclonal)

        What VEP adds ON TOP of this raw VCF:
        → Gene name (e.g. ERG, PSMG1)
        → Consequence (missense, frameshift, stop_gained)
        → IMPACT (HIGH / MODERATE / LOW / MODIFIER)
        → See examples/annotated_example.vcf for a real example!

           After bash main.sh runs:
           zcat results/variant_calling/strelka/patient1/germline.vcf.gz | head -50
           Then compare with examples/annotated_example.vcf
    """)
}
