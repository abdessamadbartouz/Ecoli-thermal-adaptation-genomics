# ===================================
# PHYLOGENETIC TREE
# ===================================

# -----------------------------------
# LOAD DATA
# -----------------------------------
df <- read.table(
  "snp_matrix.tsv",
  header = TRUE,
  sep = "\t",
  check.names = FALSE
)

rownames(df) <- df$Mutation
df$Mutation <- NULL

# -----------------------------------
# TRANSPOSE
# # samples = rows
# -----------------------------------
mat <- t(df)

# -----------------------------------
# HAMMING DISTANCE
# -----------------------------------
dist_matrix <- dist(mat, method = "binary")

# -----------------------------------
# HIERARCHICAL CLUSTERING
# -----------------------------------
hc <- hclust(dist_matrix, method = "average")

# -----------------------------------
# PLOT
# -----------------------------------
png("ecoli_tree_R.png", width=800, height=600)

plot(
  hc,
  main = "Phylo-genetic-like Tree of E. coli Evolution",
  xlab = "",
  sub = ""
)

dev.off()