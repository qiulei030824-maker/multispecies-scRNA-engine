# Multi-species scRNA-seq Pipeline Tutorial

## 📚 Complete Step-by-Step Guide

### 🎯 Introduction
This pipeline automates single-cell RNA-seq analysis for multiple species using Snakemake and STARsolo. It features:
- **Automatic library structure detection**
- **Intelligent parameter generation**
- **Multi-species compatibility**
- **Batch processing support**

### 🛠️ Prerequisites

#### 1. Software Requirements
- **Conda/Miniconda** (for environment management)
- **Git** (for cloning the repository)
- **STAR** (version 2.7.11a or higher)
- **Snakemake** (version 7.0 or higher)

#### 2. Hardware Requirements
- **CPU**: Minimum 8 cores (recommended 16+)
- **RAM**: Minimum 32GB (recommended 64GB+)
- **Storage**: 100GB+ free space

### 🚀 Quick Installation

#### Option 1: Using Setup Script (Recommended)
```bash
# Clone the repository
git clone https://github.com/qiulei030824-maker/multispecies-scRNA-engine.git
cd multispecies-scRNA-engine

# Make setup script executable
chmod +x setup.sh

# Run setup
./setup.sh
```

#### Option 2: Manual Setup
```bash
# Clone the repository
git clone https://github.com/qiulei030824-maker/multispecies-scRNA-engine.git
cd multispecies-scRNA-engine

# Create conda environment
conda env create -f environment.yaml

# Activate environment
conda activate scRNA-seq-analysis
```

### 📁 Data Preparation

#### 1. Prepare Genome Index
```bash
# Build STAR index for your species
STAR \
  --runThreadN 8 \
  --runMode genomeGenerate \
  --genomeDir /path/to/STAR_index \
  --genomeFastaFiles /path/to/genome.fa \
  --sjdbGTFfile /path/to/annotations.gtf \
  --sjdbOverhang 100
```

#### 2. Prepare Sample Data
Create a directory structure like this:
```
raw_data/
├── sample1_R1.fastq.gz
├── sample1_R2.fastq.gz
├── sample2_R1.fastq.gz
└── sample2_R2.fastq.gz
```

### ⚙️ Configuration

#### 1. Edit config.yaml
```yaml
# config/config.yaml
genomeDir: /path/to/your/STAR_index  # Update this path
threads: 8                           # Adjust based on your system
outdir: ./results                    # Output directory
```

#### 2. Edit samples.tsv
```bash
# config/samples.tsv
# Format: sample_name   R1_file_path   R2_file_path
sample1   /path/to/sample1_R1.fastq.gz   /path/to/sample1_R2.fastq.gz
sample2   /path/to/sample2_R1.fastq.gz   /path/to/sample2_R2.fastq.gz
```

### 🏃 Running the Pipeline

#### Basic Run
```bash
# Run with 8 cores
snakemake -j 8
```

#### Advanced Options
```bash
# Run with detailed logging
snakemake -j 8 --rerun-incomplete --latency-wait 60 --printshellcmds --reason

# Dry run (test without executing)
snakemake -j 8 -n

# Generate workflow diagram
snakemake --dag | dot -Tpng > workflow.png
```

### 🔍 Understanding the Workflow

#### Step 1: Library Structure Detection
The pipeline automatically analyzes your FASTQ files to determine:
- Barcode positions (usually 1-16)
- UMI positions (usually 17-26)
- Read structure characteristics
- Whether `--soloBarcodeReadLength 0` is needed

#### Step 2: Parameter Generation
Based on the detection results, the pipeline generates optimal STARsolo parameters:
```bash
# Example generated parameters
--soloCBstart 1 --soloCBlen 16 --soloUMIstart 17 --soloUMIlen 10 --soloBarcodeReadLength 0
```

#### Step 3: STARsolo Alignment
STARsolo performs:
- Read alignment to genome
- Cell barcode and UMI extraction
- Gene counting
- Output generation in BAM and matrix formats

### 📊 Output Files

#### Per Sample Directory
```
results/sample1/
├── structure.json                    # Library structure analysis
└── starsolo/
    ├── Aligned.sortedByCoord.out.bam # Sorted BAM file
    ├── Log.out                       # STAR log file
    ├── Log.progress.out              # Progress log
    └── Solo.out/
        ├── Gene/                     # Gene expression matrix
        │   ├── raw/                  # Raw counts
        │   ├── filtered/             # Filtered counts
        │   └── Summary.csv           # Summary statistics
        └── Barcodes.stats            # Barcode statistics
```

#### Key Output Files
1. **Gene Expression Matrix**: `Solo.out/Gene/filtered/`
2. **BAM Files**: For visualization in IGV
3. **Quality Metrics**: In `Solo.out/Gene/Summary.csv`

### 🧪 Testing the Pipeline

#### Test with Example Data
```bash
# Create a test configuration
echo "genomeDir: /path/to/test_genome
threads: 4
outdir: ./test_results" > config/test_config.yaml

# Create test samples
echo -e "test_sample\t/path/to/test_R1.fastq.gz\t/path/to/test_R2.fastq.gz" > config/test_samples.tsv

# Run test
snakemake -j 4 --configfile config/test_config.yaml --config samples=config/test_samples.tsv
```

### 🔧 Troubleshooting

#### Common Issues and Solutions

##### Issue 1: "File not found" errors
**Solution**: Check file paths in `config/samples.tsv`
```bash
# Verify file existence
ls -la /path/to/your/fastq/files
```

##### Issue 2: STAR index problems
**Solution**: Rebuild STAR index with correct parameters
```bash
# Check index compatibility
STAR --genomeDir /path/to/index --genomeLoad LoadAndExit
```

##### Issue 3: Memory errors
**Solution**: Reduce thread count or increase memory
```bash
# Run with fewer threads
snakemake -j 4

# Or increase Java heap space
export _JAVA_OPTIONS="-Xmx64g"
```

##### Issue 4: Pipeline stops unexpectedly
**Solution**: Use rerun-incomplete flag
```bash
snakemake -j 8 --rerun-incomplete
```

### 📈 Performance Optimization

#### For Large Datasets
```bash
# Increase resources
snakemake -j 16 --resources mem_mb=64000

# Use cluster execution
snakemake -j 100 --cluster "sbatch -t 24:00:00 -c 8 --mem=32g"
```

#### For Multiple Species
```bash
# Create separate config files per species
# human_config.yaml, mouse_config.yaml, etc.

# Run species-specific analyses
snakemake -j 8 --configfile config/human_config.yaml
snakemake -j 8 --configfile config/mouse_config.yaml
```

### 🔄 Advanced Usage

#### Customizing Detection Parameters
Edit `scripts/detect_scRNA_structure.py` to adjust:
- Number of reads analyzed (default: 2000)
- Barcode/UMI length detection
- Poly-T detection threshold

#### Adding New Rules
Create new `.smk` files in `rules/` directory:
```python
# rules/custom.smk
rule custom_analysis:
    input: "results/{sample}/starsolo"
    output: "results/{sample}/custom_output.txt"
    shell: "your_command {input} > {output}"
```

#### Integrating with Other Tools
```python
# Example: Add Seurat analysis
rule seurat_analysis:
    input: "results/{sample}/starsolo/Solo.out/Gene/filtered"
    output: "results/{sample}/seurat.rds"
    script: "scripts/run_seurat.R"
```

### 📚 Additional Resources

#### Documentation
- [STARsolo Manual](https://github.com/alexdobin/STAR/blob/master/docs/STARsolo.md)
- [Snakemake Documentation](https://snakemake.readthedocs.io/)
- [10x Genomics Documentation](https://support.10xgenomics.com/)

#### Example Datasets
- [10x Genomics Datasets](https://support.10xgenomics.com/single-cell-gene-expression/datasets)
- [SRA Single-cell Studies](https://www.ncbi.nlm.nih.gov/sra)

#### Community Support
- [GitHub Issues](https://github.com/qiulei030824-maker/multispecies-scRNA-engine/issues)
- [Biostars](https://www.biostars.org/)
- [SeqAnswers](https://seqanswers.com/)

### 🎉 Congratulations!
You have successfully set up and run the multi-species scRNA-seq analysis pipeline. The pipeline will continue to evolve with new features and improvements.

### 📝 Citation
If you use this pipeline in your research, please cite:
```
Multi-species scRNA-seq Automated Analysis Pipeline. 
GitHub: https://github.com/qiulei030824-maker/multispecies-scRNA-engine
```

### 🤝 Contributing
Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request
4. Add tests for new features

### 📞 Contact
For questions or support:
- Open an issue on GitHub
- Check the troubleshooting section above
- Refer to the documentation links