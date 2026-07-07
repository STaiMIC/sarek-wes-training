#!/bin/bash
#
# main.sh
# ~~~~~~~
# Single entry script for the complete Sarek WES training pipeline.
# Students run ONE command: bash main.sh
#
# Expected runtime: ~15-20 minutes on a 2-core/8GB GitHub Codespace

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Sarek WES Training - Practical Exercise                    ║"
echo "║  Complete pipeline: FASTQ → Aligned BAM → Variant VCF       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

###############################################################################
# Check software
###############################################################################

if ! command -v nextflow >/dev/null 2>&1; then
    echo "❌ ERROR: Nextflow not found."
    echo "Install with:"
    echo "curl -fsSL https://get.nextflow.io | bash"
    exit 1
fi

echo "✓ Nextflow found: $(nextflow -version 2>&1 | head -1)"
echo "✓ Java found: $(java -version 2>&1 | head -1)"
echo "✓ Docker found: $(docker --version 2>&1)"

###############################################################################
# Check Docker
###############################################################################

if ! docker ps >/dev/null 2>&1; then
    echo ""
    echo "❌ ERROR: Docker daemon is not running."
    echo "Please start Docker Desktop and try again."
    exit 1
fi

echo "✓ Docker daemon is running"

###############################################################################
# Check Sarek repository
###############################################################################

if [ ! -d "$HOME/sarek-39" ]; then
    echo ""
    echo "❌ ERROR: Sarek pipeline not found."
    echo "Expected location:"
    echo "  $HOME/sarek-39"
    exit 1
fi

echo "✓ Sarek pipeline found"
echo ""

###############################################################################
# Pipeline overview
###############################################################################

echo "Running Sarek WES pipeline..."
echo ""
echo "Stages that will run:"
echo "  1. FASTP            → Quality control on raw FASTQ reads"
echo "  2. BWA-MEM          → Align reads to reference genome"
echo "  3. MarkDuplicates   → Remove PCR duplicates from BAM"
echo "  4. Strelka          → Variant calling (germline + somatic)"
echo "  5. MultiQC          → Aggregate all QC metrics into one report"
echo ""
echo "Note:"
echo "  Annotation (VEP) is demonstrated using"
echo "  examples/annotated_example.vcf"
echo "  because downloading the VEP cache is too large"
echo "  for a live training session."
echo ""

###############################################################################
# Run nf-core/sarek
###############################################################################

nextflow run "$HOME/sarek-39" \
    -profile docker \
    --input "$REPO_ROOT/data/samplesheet.csv" \
    --outdir "$REPO_ROOT/results" \
    --genome testdata.nf-core.sarek \
    --igenomes_base "https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/" \
    --tools strelka \
    --skip_tools baserecalibrator \
    --wes \
    --disable_wave \
    -resume

###############################################################################
# Finished
###############################################################################

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ Pipeline complete!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Results:"
echo "  • Preprocessing:"
echo "      results/preprocessing/"
echo ""
echo "  • Variant calls:"
echo "      results/variant_calling/strelka/"
echo ""
echo "  • QC report:"
echo "      results/multiqc/multiqc_report.html"
echo ""
echo "  • Pipeline information:"
echo "      results/pipeline_info/"
echo ""

echo "Next steps:"
echo ""
echo "1. Open the MultiQC report:"
echo "   results/multiqc/multiqc_report.html"
echo ""
echo "2. Inspect the germline VCFs:"
echo "   zcat results/variant_calling/strelka/NA12878_1/*.vcf.gz | head -50"
echo "   zcat results/variant_calling/strelka/NA12878_2/*.vcf.gz | head -50"
echo ""
echo "3. Inspect the somatic VCF:"
echo "   zcat results/variant_calling/strelka/tumor_sample_vs_normal_sample/*.vcf.gz | head -50"
echo ""
echo "4. Compare with the annotated example:"
echo "   cat examples/annotated_example.vcf | head -80"
echo ""
echo "5. Read:"
echo "   course/REFERENCE.md"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""