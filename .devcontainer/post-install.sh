#!/bin/bash
# post-install.sh
# Runs automatically when GitHub Codespace starts.
# Installs Nextflow, clones Sarek 3.9.0, downloads test FASTQs.

set -e

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Sarek WES Training — Codespace Setup (auto, ~3 min)        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Step 1 — Install Nextflow via conda
echo "Installing Nextflow..."
conda install -y -c bioconda nextflow > /dev/null 2>&1
echo "Nextflow: $(nextflow -version 2>&1 | head -1)"

# Step 2 — Clone Sarek 3.9.0
echo ""
echo "Cloning nf-core/sarek 3.9.0 (this takes ~30 seconds)..."
if [ ! -d "$HOME/sarek-39" ]; then
    git clone --depth 1 --branch 3.9.0 \
        https://github.com/nf-core/sarek.git \
        $HOME/sarek-39 > /dev/null 2>&1
    echo "✅ Sarek 3.9.0 ready at ~/sarek-39"
else
    echo "✅ Sarek 3.9.0 already present"
fi

# Step 3 — Download test FASTQ files
echo ""
echo "Downloading test FASTQ files (~15MB)..."
mkdir -p /workspaces/sarek-wes-training/data/fastq

BASE="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/homo_sapiens/illumina/fastq"

wget -q -O /workspaces/sarek-wes-training/data/fastq/test_1.fastq.gz \
    $BASE/test_1.fastq.gz && echo "  ✅ test_1.fastq.gz"
wget -q -O /workspaces/sarek-wes-training/data/fastq/test_2.fastq.gz \
    $BASE/test_2.fastq.gz && echo "  ✅ test_2.fastq.gz"
wget -q -O /workspaces/sarek-wes-training/data/fastq/test2_1.fastq.gz \
    $BASE/test2_1.fastq.gz && echo "  ✅ test2_1.fastq.gz"
wget -q -O /workspaces/sarek-wes-training/data/fastq/test2_2.fastq.gz \
    $BASE/test2_2.fastq.gz && echo "  ✅ test2_2.fastq.gz"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  ✅ Setup complete! You are ready to run:                   ║"
echo "║                                                              ║"
echo "║  Step 1 — Understand the samplesheet (instant):            ║"
echo "║     nextflow run course/01_samplesheet.nf                  ║"
echo "║                                                              ║"
echo "║  Step 2 — Run full WES pipeline (~20 min):                 ║"
echo "║     bash main.sh                                            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""