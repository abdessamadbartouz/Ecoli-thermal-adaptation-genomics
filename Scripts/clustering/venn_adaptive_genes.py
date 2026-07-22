import pandas as pd
import matplotlib.pyplot as plt
from venn import venn

# ----------------------------
# LOAD ADAPTIVE TABLE
# ----------------------------
adaptive = pd.read_csv(
    "adaptive_mutation_table_coding.tsv",
    sep="\t"
)

# ----------------------------
# LOAD GLOBAL MATRIX
# ----------------------------
matrix = pd.read_csv(
    "snp_matrix.tsv",
    sep="\t"
)

# ----------------------------
# MERGE
# ----------------------------
df = pd.merge(
    adaptive,
    matrix,
    on="Mutation",
    how="left"
)

# ----------------------------
# REMOVE EMPTY GENES
# ----------------------------
df = df[df["Gene"].notna()]
df = df[df["Gene"] != ""]

# ----------------------------
# BUILD GENE SETS
# ----------------------------
samples = ["DH10B", "HE50", "HE100", "HE150"]

gene_sets = {}

for sample in samples:

    genes = set(
        df[df[sample] == 1]["Gene"]
    )

    gene_sets[sample] = genes

# ----------------------------
# PLOT VENN
# ----------------------------
plt.figure(figsize=(10,10))

venn(gene_sets)

plt.title(
    "Adaptive Gene Overlap Across Heat-Evolved Strains"
)

plt.tight_layout()

plt.savefig(
    "adaptive_gene_venn.png",
    dpi=300
)

plt.show()

print("\n✔ Venn diagram generated")