rule starsolo:
    input:
        r1=lambda wc: samples[wc.sample]["r1"],
        r2=lambda wc: samples[wc.sample]["r2"],
        config="results/{sample}/structure.json"
    output:
        directory("results/{sample}/starsolo")
    params:
        genome=lambda wc: config["genomeDir"]
    threads: 8
    shell:
        """
        PARAMS=$(python scripts/generate_params.py {input.config})

        mkdir -p {output}

        STAR \
        --runThreadN {threads} \
        --genomeDir {params.genome} \
        --readFilesIn {input.r1} {input.r2} \
        --readFilesCommand zcat \
        --soloType CB_UMI_Simple \
        $PARAMS \
        --soloFeatures Gene \
        --outFileNamePrefix {output}/ \
        --outSAMtype BAM SortedByCoordinate
        """