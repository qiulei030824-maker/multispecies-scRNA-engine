# Multi-species scRNA-seq Automated Analysis Pipeline

## 🎯 One-sentence Description
**Automatic scRNA-seq library structure detection + Intelligent parameter generation + One-click STARsolo analysis**

## ⚡ 5-Minute Quick Start

### Step 1: Prepare Environment
```bash
# Activate your Python environment (adjust path as needed)
source /path/to/your/env/bin/activate
cd /path/to/multispecies_scRNA_engine
```

### Step 2: Check Configuration
```bash
# View configuration file
cat config/config.yaml

# View sample list
head -5 config/samples.tsv
```

### Step 3: Run with One Command
```bash
snakemake -j 8 --rerun-incomplete --latency-wait 60 --printshellcmds --reason
```

## 📊 Supported Data Types
- ✅ 10x Genomics single-cell data
- ✅ 10x-like custom libraries
- ✅ polyT extended read data
- ✅ Multi-species mixed data

## 🔧 Core Features

### 1. Automatic Structure Detection
```bash
# Manual test for your data
python scripts/detect_scRNA_structure.py your_data_r1.fastq.gz test.json
```

### 2. Intelligent Parameter Generation
- Automatic barcode position detection (1-16)
- Automatic UMI position detection (17-26)
- Automatic setting of `--soloBarcodeReadLength 0` (critical parameter)

### 3. Batch Parallel Processing
- Support for 31+ samples simultaneously
- Automatic error recovery
- Detailed progress reporting

## 📁 Output Structure
```
results/
├── CRR1417065/
│   ├── structure.json          # Library structure analysis
│   └── starsolo/
│       ├── Aligned.sortedByCoord.out.bam      # Alignment file
│       └── Solo.out/Gene/      # Gene expression matrix
└── CRR1417066/
    └── ...
```

## 🚨 Important Notes

### Critical Parameter `--soloBarcodeReadLength 0`
This parameter is the **soul** of pipeline success, specifically for:
- Non-standard 10x data
- polyT extended reads
- Custom barcode designs

### Data Requirements
1. **Paired-end FASTQ files**: `*_r1.fastq.gz` and `*_r2.fastq.gz`
2. **STAR index**: Pre-built genome index
3. **Sufficient disk space**: ~10-20GB per sample

## 🔍 Monitoring Pipeline Status

### Check Progress
```bash
# View running tasks
snakemake --list

# View pipeline DAG
snakemake --dag | dot -Tpng > pipeline_dag.png
```

### Check Logs
```bash
# View overall logs
tail -f .snakemake/log/*.snakemake.log

# View specific sample logs
cat results/CRR1417065/starsolo/Log.out | tail -20
```

## 🆘 Troubleshooting

### Q1: What if the pipeline fails?
```bash
# 1. Check error logs
cat logs/*.log

# 2. Rerun failed tasks
snakemake -j 8 --rerun-incomplete

# 3. Delete problematic sample and rerun
rm -rf results/CRR1417065
snakemake results/CRR1417065/starsolo
```

### Q2: How to add new samples?
```bash
# Edit sample table
vim config/samples.tsv
# Add new line: sample_name   /path/to/r1.fq.gz   /path/to/r2.fq.gz

# Rerun pipeline
snakemake -j 8
```

### Q3: How to change genome?
```bash
# Edit configuration file
vim config/config.yaml
# Modify genomeDir: /path/to/new/genome_index

# Clean and rerun
snakemake --delete-all-output
snakemake -j 8
```

## 📚 Detailed Documentation
Complete tutorial available at: [TUTORIAL.md](TUTORIAL.md)

## 📞 Getting Help
If you encounter issues:
1. Check common problems in `TUTORIAL.md`
2. Check log files: `logs/` and `.snakemake/log/`
3. Verify input file formats are correct

## 🎉 Start Using Now!
Just prepare your data and run one command:
```bash
snakemake -j 8 --rerun-incomplete --latency-wait 60 --printshellcmds --reason
```

**Let the computer handle tedious analysis work while you focus on biological discoveries!**

---

## 📁 Project Structure
```
multispecies_scRNA_engine/
├── README.md                    # This file
├── Snakefile                    # Main Snakemake workflow
├── config/
│   ├── config.yaml              # Configuration file
│   └── samples.tsv              # Sample list
├── rules/
│   ├── detect.smk               # Library detection rules
│   └── starsolo.smk             # STARsolo analysis rules
└── scripts/
    ├── detect_scRNA_structure.py # Library structure detection
    └── generate_params.py       # Parameter generation script
```

## 🧬 Multi-species Support
This pipeline is designed to work with multiple species by:
1. Automatic detection of library structure regardless of species
2. Flexible configuration for different genome indices
3. Intelligent parameter adaptation based on data characteristics

## 🔄 Workflow Overview
1. **Input**: FASTQ files (R1 and R2)
2. **Detection**: Analyze R1 reads to determine library structure
3. **Parameter Generation**: Create optimal STARsolo parameters
4. **Alignment**: Run STARsolo with generated parameters
5. **Output**: BAM files and gene expression matrices

## 📊 Performance
- **Speed**: Processes 31 samples in parallel
- **Memory**: Optimized for 36 threads configuration
- **Accuracy**: Automatic parameter tuning for best results

## 🤝 Contributing
Feel free to submit issues and pull requests to improve this pipeline!