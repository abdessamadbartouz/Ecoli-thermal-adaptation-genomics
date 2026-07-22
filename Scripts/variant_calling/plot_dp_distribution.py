#!/usr/bin/env python3

import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

#=================================================================================================
#This script generates DP distribution plots for each sample to decide on the filtering threshold
#=================================================================================================

# List of TSV files
tsv_files = [
    "DH10B.tsv",
    "HE_100.tsv",
    "HE_150.tsv",
    "HE_50.tsv"
]

for file in tsv_files:

    # Read TSV
    df = pd.read_csv(file, sep="\t")

    # Remove missing DP values
    df = df.dropna(subset=["DP"])

    # Create figure
    plt.figure(figsize=(8, 5))

    # Histogram
    plt.hist(df["DP"], bins=30)

    # Labels
    sample_name = Path(file).stem

    plt.xlabel("Depth (DP)")
    plt.ylabel("Variant Count")
    plt.title(f"DP Distribution - {sample_name}")

    # Save plot
    output_name = f"{sample_name}_DP_distribution.png"
    plt.savefig(output_name, dpi=300, bbox_inches="tight")

    # Close figure
    plt.close()

    print(f"Generated {output_name}")