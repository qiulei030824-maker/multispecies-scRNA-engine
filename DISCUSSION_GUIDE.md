# GitHub Discussion Guide

## 🗣️ How to Start a Discussion

Copy and paste the content below into a new GitHub Discussion in this repository:

---

## 📢 Multi-species scRNA-seq Pipeline Discussion

### 🎯 Welcome to the Discussion!
This is the official discussion thread for the **Multi-species scRNA-seq Automated Analysis Pipeline**. Use this space to:

- Ask questions about installation and usage
- Share your experiences with the pipeline
- Report issues or suggest improvements
- Discuss single-cell analysis best practices
- Share results and visualizations

### 🚀 Quick Start Summary

#### 1. Installation
```bash
git clone https://github.com/qiulei030824-maker/multispecies-scRNA-engine.git
cd multispecies-scRNA-engine
chmod +x setup.sh
./setup.sh
```

#### 2. Configuration
- Edit `config/config.yaml` with your genome directory
- Edit `config/samples.tsv` with your sample information

#### 3. Run Pipeline
```bash
conda activate scRNA-seq-analysis
snakemake -j 8 --rerun-incomplete --latency-wait 60 --printshellcmds --reason
```

### ❓ Frequently Asked Questions

#### Q: What makes this pipeline special?
**A**: This pipeline features **automatic library structure detection** and **intelligent parameter generation**, making it ideal for:
- Non-standard 10x data
- Multi-species experiments
- Custom library designs
- Poly-T extended reads

#### Q: What's the critical parameter?
**A**: `--soloBarcodeReadLength 0` - This parameter is automatically set when needed and is crucial for analyzing non-standard scRNA-seq libraries.

#### Q: How do I handle multiple species?
**A**: The pipeline automatically detects library structure regardless of species. Just provide the appropriate STAR index for each species.

### 🐛 Common Issues & Solutions

#### Issue: "File not found" errors
**Solution**: Double-check paths in `config/samples.tsv`. Use absolute paths for reliability.

#### Issue: Memory errors during STARsolo
**Solution**: Reduce thread count or increase available memory:
```bash
snakemake -j 4  # Use fewer threads
export _JAVA_OPTIONS="-Xmx64g"  # Increase Java heap space
```

#### Issue: Pipeline stops unexpectedly
**Solution**: Use the rerun-incomplete flag:
```bash
snakemake -j 8 --rerun-incomplete
```

### 📊 Expected Results

After successful run, you should see:
```
results/
├── sample1/
│   ├── structure.json
│   └── starsolo/
│       ├── Aligned.sortedByCoord.out.bam
│       └── Solo.out/Gene/filtered/
└── sample2/
    └── ...
```

### 🔬 Advanced Topics

#### Customizing for Your Experiment
- Modify `scripts/detect_scRNA_structure.py` for custom library designs
- Add new rules in `rules/` directory for additional analyses
- Integrate with downstream tools like Seurat or Scanpy

#### Performance Optimization
- Adjust `threads` in `config/config.yaml` based on your system
- Use cluster execution for large datasets
- Monitor memory usage with `htop` or similar tools

### 🤝 Community Guidelines

1. **Be respectful and constructive**
2. **Share your configurations** when asking for help
3. **Include error messages** and log snippets
4. **Test suggestions** before implementing in production
5. **Credit contributors** when their suggestions help you

### 📚 Resources

- **Full Documentation**: [README.md](README.md)
- **Detailed Tutorial**: [TUTORIAL.md](TUTORIAL.md)
- **Example Configs**: `config/` directory
- **Script Documentation**: `scripts/` directory

### 🎉 Share Your Success!
We encourage users to:
- Share publication links using this pipeline
- Post interesting visualizations
- Contribute improvements via pull requests
- Help other users with their questions

### 📞 Getting Help
If you don't find answers here:
1. Check the [TUTORIAL.md](TUTORIAL.md) for detailed instructions
2. Review closed issues for similar problems
3. Consider opening a new issue for bugs

---

## 💬 Discussion Categories

Please use appropriate categories when posting:

- **❓ Questions**: For help with installation and usage
- **💡 Ideas**: For feature requests and improvements
- **🎉 Show and Tell**: For sharing results and success stories
- **🐛 Bugs**: For reporting issues (consider opening an Issue instead)

## 📈 Pipeline Statistics

- **Version**: 1.0.0
- **Last Updated**: April 2026
- **Supported Species**: All (with appropriate STAR index)
- **Tested With**: 10x Genomics, custom libraries, poly-T extended reads

## 🔄 Update Notifications

Subscribe to this discussion to get notifications about:
- New pipeline versions
- Important bug fixes
- Feature announcements
- Community events

Happy analyzing! 🧬🔬