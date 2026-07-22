############################################################
# 1. SET WORKING DIRECTORY
############################################################

# setwd("C:\Users\lenovo\Downloads\ShinyGO")

############################################################
# 2. LOAD LIBRARIES
############################################################

library(tidyverse)
library(readxl)
library(ggplot2)
library(stringr)
library(viridis)

############################################################
# 3. READ FILES
############################################################

bp <- read_excel("Biological Process.xlsx")
cc <- read_excel("Cellular Component.xlsx")
mf <- read_excel("Molecular Function.xlsx")
kegg <- read_excel("KEGG.xlsx")

############################################################
# 4. CLEAN FUNCTION
############################################################

prepare_shinygo <- function(df){
  
  names(df) <- tolower(names(df))
  names(df) <- gsub(" ", "_", names(df))   # convert spaces to underscores
  
  df %>%
    mutate(
      pattern = gene_list,
      term    = pathway,
      fdr     = as.numeric(enrichment_fdr),
      count   = as.numeric(ngenes),
      fold    = as.numeric(fold_enrichment),
      logfdr  = -log10(fdr),
      term    = str_wrap(term, width = 40)
    ) %>%
    filter(!is.na(term)) %>%
    filter(!is.na(fdr)) %>%
    filter(fdr > 0 & fdr < 0.2)
}
############################################################
# 5. CLEAN DATA
############################################################

bp_clean   <- prepare_shinygo(bp)
cc_clean   <- prepare_shinygo(cc)
mf_clean   <- prepare_shinygo(mf)
kegg_clean <- prepare_shinygo(kegg)

############################################################
# 6. SIMPLE PLOT FUNCTION (NO FACETS, NO OVERLAP)
############################################################

plot_shinygo <- function(df, title){
  
  df_top <- df %>%
    group_by(pattern) %>%
    slice_max(order_by = logfdr, n = 8) %>%
    ungroup()
  
  ggplot(df_top, aes(
    x = reorder(term, fold),
    y = fold,
    size = count,
    color = logfdr
  )) +
    
    geom_point(alpha = 0.85) +
    coord_flip() +
    
    scale_color_viridis_c(option = "plasma") +
    
    theme_bw(base_size = 12) +
    
    labs(
      title = title,
      x = "Enriched Term",
      y = "Fold Enrichment",
      size = "Gene Count",
      color = "-log10(FDR)"
    ) +
    
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5),
      axis.text.y = element_text(size = 7)
    )
}

############################################################
# 7. CREATE 4 SEPARATE PLOTS
############################################################

p_bp   <- plot_shinygo(bp_clean, "GO Biological Process")
p_cc   <- plot_shinygo(cc_clean, "GO Cellular Component")
p_mf   <- plot_shinygo(mf_clean, "GO Molecular Function")
p_kegg <- plot_shinygo(kegg_clean, "KEGG Pathways")

############################################################
# 8. SAVE EACH PLOT (CANVA READY)
############################################################

ggsave("BP_plot.png", p_bp, width = 10, height = 7, dpi = 600)
ggsave("CC_plot.png", p_cc, width = 10, height = 7, dpi = 600)
ggsave("MF_plot.png", p_mf, width = 10, height = 7, dpi = 600)
ggsave("KEGG_plot.png", p_kegg, width = 10, height = 7, dpi = 600)

############################################################
# DONE
############################################################