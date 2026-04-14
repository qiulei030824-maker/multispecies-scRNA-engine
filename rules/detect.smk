rule detect_structure:
    input:
        r1=lambda wildcards: samples[wildcards.sample]["r1"]
    output:
        "results/{sample}/structure.json"
    shell:
        """
        python scripts/detect_scRNA_structure.py {input.r1} {output}
        """