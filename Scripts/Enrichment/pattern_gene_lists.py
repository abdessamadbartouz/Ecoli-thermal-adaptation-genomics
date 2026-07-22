#!/usr/bin/env python3

import pandas as pd
import os

# -----------------------------
# Load annotated matrix
# -----------------------------
df = pd.read_csv(
    "snp_matrix_annotated.tsv",
    sep="\t"
)

# -----------------------------
# Detect sample columns
# -----------------------------
sample_cols = [
    c for c in df.columns
    if c not in ["Mutation", "Gene"]
]

# -----------------------------
# Build pattern column
# -----------------------------
df["Pattern"] = df[sample_cols].astype(str).agg("".join, axis=1)

# -----------------------------
# Output directory
# -----------------------------
outdir = "pattern_gene_lists"
os.makedirs(outdir, exist_ok=True)

# -----------------------------
# Create one file per pattern
# -----------------------------
for pattern, group in df.groupby("Pattern"):

    outfile = os.path.join(
        outdir,
        f"{pattern}.txt"
    )

    with open(outfile, "w") as f:

        for gene in group["Gene"]:
            f.write(str(gene) + "\n")

print(f"Created {df['Pattern'].nunique()} pattern files")