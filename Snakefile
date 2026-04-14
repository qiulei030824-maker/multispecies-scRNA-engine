import pandas as pd

configfile: "config/config.yaml"

samples_df = pd.read_csv("config/samples.tsv", sep="\t", header=None)
samples_df.columns = ["sample", "r1", "r2"]
samples = samples_df.set_index("sample").to_dict("index")

SAMPLES = list(samples.keys())

include: "rules/detect.smk"
include: "rules/starsolo.smk"

rule all:
    input:
        expand("results/{sample}/starsolo", sample=SAMPLES)