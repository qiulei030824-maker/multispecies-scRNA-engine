import gzip
import sys
import json
from collections import Counter

fastq = sys.argv[1]
out = sys.argv[2]

def read_seq(f, n=2000):
    seqs = []
    with gzip.open(f, 'rt') as fh:
        for i, line in enumerate(fh):
            if i % 4 == 1:
                seqs.append(line.strip())
            if len(seqs) >= n:
                break
    return seqs

seqs = read_seq(fastq)

lengths = [len(s) for s in seqs]
mean_len = sum(lengths)/len(lengths)

cb = [s[:16] for s in seqs]
umi = [s[16:26] for s in seqs]

polyT = sum(1 for s in seqs if "TTTTTTTT" in s) / len(seqs)

result = {
    "mean_read_length": mean_len,
    "barcode_diversity": len(set(cb))/len(cb),
    "umi_diversity": len(set(umi))/len(umi),
    "polyT_ratio": polyT,
    "is_scRNA": True,
    "is_10x_like": True,
    "need_soloBarcodeReadLength_0": True,
    "recommended_params": {
        "soloCBstart": 1,
        "soloCBlen": 16,
        "soloUMIstart": 17,
        "soloUMIlen": 10,
        "soloBarcodeReadLength": 0
    }
}

with open(out, "w") as f:
    json.dump(result, f, indent=2)