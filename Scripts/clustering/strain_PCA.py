import pandas as pd
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt

# ----------------------------
# LOAD MATRIX
# ----------------------------
df = pd.read_csv("snp_matrix.tsv", sep="\t")

samples = ["DH10B", "HE50", "HE100", "HE150"]

# ----------------------------
# TRANSPOSE MATRIX
# samples = rows
# ----------------------------
X = df[samples].T

# ----------------------------
# REMOVE CONSTANT MUTATIONS
# ----------------------------
X = X.loc[:, X.nunique() > 1]

# ----------------------------
# SCALE DATA
# ----------------------------
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# ----------------------------
# PCA
# ----------------------------
pca = PCA(n_components=2)
coords = pca.fit_transform(X_scaled)

# ----------------------------
# SAVE PCA TABLE
# ----------------------------
pca_df = pd.DataFrame(
    coords,
    columns=["PC1", "PC2"]
)

pca_df["Sample"] = samples

print(pca_df)

# ----------------------------
# PLOT
# ----------------------------
plt.figure(figsize=(7,6))

plt.scatter(
    pca_df["PC1"],
    pca_df["PC2"],
    s=120
)

# Add sample labels
for i, sample in enumerate(samples):
    plt.text(
        pca_df["PC1"][i],
        pca_df["PC2"][i],
        sample
    )

# Axis labels
plt.xlabel(
    f"PC1 ({pca.explained_variance_ratio_[0]*100:.2f})% variance"
)

plt.ylabel(
    f"PC2 ({pca.explained_variance_ratio_[1]*100:.2f})% variance"
)

plt.title("PCA of E. coli Evolution")

plt.tight_layout()

plt.savefig("ecoli_PCA_python.png", dpi=300)

print("\nExplained variance:")
print(pca.explained_variance_ratio_)