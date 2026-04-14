#!/bin/bash

# Setup script for multi-species scRNA-seq analysis pipeline

echo "Setting up multi-species scRNA-seq analysis pipeline..."

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo "Error: Conda is not installed. Please install Miniconda or Anaconda first."
    echo "Visit: https://docs.conda.io/en/latest/miniconda.html"
    exit 1
fi

# Create conda environment
echo "Creating conda environment from environment.yaml..."
conda env create -f environment.yaml

# Activate environment
echo "Environment created. Activating with:"
echo "conda activate scRNA-seq-analysis"

# Create necessary directories
echo "Creating directory structure..."
mkdir -p config rules scripts results logs

echo ""
echo "Setup complete! Next steps:"
echo "1. Activate the environment: conda activate scRNA-seq-analysis"
echo "2. Edit config/config.yaml with your genome directory path"
echo "3. Edit config/samples.tsv with your sample information"
echo "4. Run the pipeline: snakemake -j 8"
echo ""
echo "For detailed instructions, see README.md"