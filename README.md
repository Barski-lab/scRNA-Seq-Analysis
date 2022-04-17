[![Build Status](https://app.travis-ci.com/Barski-lab/scRNA-Seq-Analysis.svg?branch=main)](https://app.travis-ci.com/Barski-lab/scRNA-Seq-Analysis)
[![Python 3.8](https://img.shields.io/badge/python-3.8-green.svg)](https://www.python.org/downloads/release/python-38/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5315021.svg)](https://doi.org/10.5281/zenodo.5315021)

# CWL toolkit for single-cell data analysis

**Notes:**
- For details on how to use the published workflows version ***[v1.0.1](https://github.com/Barski-lab/scRNA-Seq-Analysis/tree/v1.0.1)*** in ***[SciDAP](https://scidap.com/)*** refer to the ***[Tutorials](https://barski-lab.github.io/sc-seq-analysis/)*** page.
- For up to date workflow description see Wiki page.

**Publications:**

- *Aizhan Surumbayeva, Michael Kotliar, Linara Gabitova-Cornell, Andrey Kartashov, Suraj Peri, Nathan Salomonis, Artem Barski, Igor Astsaturov, Preparation of mouse pancreatic tumor for single-cell RNA sequencing and analysis of the data, STAR Protocols, Volume 2, Issue 4, 2021, 100989, ISSN 2666-1667,
https://doi.org/10.1016/j.xpro.2021.100989*

--------

This repository contains R scripts and CWL tools for single-cell RNA-Seq and Multiome data analyses. The CWL tools can be chained together into the workflows as shown on the figure below.

![](./docs/images/readme/figure_1.png)

**Complete list of the available CWL tools**
| Name                                 | Description  |
|:-------------------------------------|:-------------|
| [cellranger-mkref.cwl](./tools/cellranger-mkref.cwl)                                | Builds Cell Ranger compatible reference folder from the custom genome FASTA and gene GTF annotation files |
| [cellranger-count.cwl](./tools/cellranger-count.cwl)                                | Quantifies gene expression from a single-cell RNA-Seq library |
| [cellranger-aggr.cwl](./tools/cellranger-aggr.cwl)                                  | Aggregates outputs from multiple runs of Cell Ranger Count Gene Expression |
| [cellbrowser-build-cellranger.cwl](./tools/cellbrowser-build-cellranger.cwl)        | Exports clustering results from Cell Ranger Count Gene Expression and Cell Ranger Aggregate experiments into compatible with UCSC Cell Browser format |
| [cellranger-arc-mkref.cwl](./tools/cellranger-arc-mkref.cwl)                        | Builds Cell Ranger ARC compatible reference folder from the custom genome FASTA and gene GTF annotation files |
| [cellranger-arc-count.cwl](./tools/cellranger-arc-count.cwl)                        | Quantifies chromatin accessibility and gene expression from a single-cell Multiome ATAC/RNA-Seq library |
| [cellranger-arc-aggr.cwl](./tools/cellranger-arc-aggr.cwl)                          | Aggregates outputs from multiple runs of Cell Ranger ARC Count Chromatin Accessibility and Gene Expression |
| [cellbrowser-build-cellranger-arc.cwl](./tool/cellbrowser-build-cellranger-arc.cwl) | Exports clustering results from Cell Ranger ARC Count Chromatin Accessibility and Gene Expression or Cell Ranger ARC Aggregate experiments into compatible with UCSC Cell Browser format |
| [sc-rna-filter.cwl](./tools/sc-rna-filter.cwl)                                      | Filters single-cell RNA-Seq datasets based on the common QC metrics |
| [sc-rna-reduce.cwl](./tools/sc-rna-reduce.cwl)                                      | Integrates multiple single-cell RNA-Seq datasets, reduces dimensionality using PCA |
| [sc-rna-cluster.cwl](./tools/sc-rna-cluster.cwl)                                    | Clusters single-cell RNA-Seq datasets, identifies gene markers |
| [sc-multiome-filter.cwl](./tools/sc-multiome-filter.cwl)                            | Filters single-cell multiome ATAC and RNA-Seq datasets based on the common QC metrics |
| [sc-atac-reduce.cwl](./tools/sc-atac-reduce.cwl)                                    | Integrates multiple single-cell ATAC-Seq datasets, reduces dimensionality using LSI |
| [sc-atac-cluster.cwl](./tools/sc-atac-cluster.cwl)                                  | Clusters single-cell ATAC-Seq datasets, identifies differentially accessible peaks |
| [sc-wnn-cluster.cwl](./tools/sc-wnn-cluster.cwl)                                    | Clusters multiome ATAC and RNA-Seq datasets, identifies gene markers and differentially accessible peaks |
| [tar-extract.cwl](./tools/tar-extract.cwl)                                          | Extracts the content of TAR file into a folder |
| [tar-compress.cwl](./tools/tar-compress.cwl)                                        | Creates compressed TAR file from a folder |