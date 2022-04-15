cwlVersion: v1.0
class: Workflow


requirements:
  - class: SubworkflowFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement


inputs:

  indices_folder:
    type: Directory
    doc: |
      Cell Ranger ARC reference genome indices folder

  gex_fastq_file_r1:
    type: File
    doc: |
      GEX FASTQ file R1 (optionally compressed)

  gex_fastq_file_r2:
    type: File
    doc: |
      GEX FASTQ file R2 (optionally compressed)

  atac_fastq_file_r1:
    type: File
    doc: |
      ATAC FASTQ file R1 (optionally compressed)

  atac_fastq_file_r2:
    type: File
    doc: |
      ATAC FASTQ file R2 (optionally compressed)

  atac_fastq_file_r3:
    type: File
    doc: |
      ATAC FASTQ file R3 (optionally compressed)

  exclude_introns:
    type: boolean?
    default: false
    doc: |
      Disable counting of intronic reads. In this mode, only reads that are exonic
      and compatible with annotated splice junctions in the reference are counted.
      Note: using this mode will reduce the UMI counts in the feature-barcode matrix

  threads:
    type: int?
    default: 4
    doc: |
      Number of threads for those steps that support multithreading

  memory_limit:
    type: int?
    default: 20
    doc: |
      Maximum memory used (GB).
      The same as was used for generating indices.
      The same will be applied to virtual memory


outputs:

  web_summary_report:
    type: File
    outputSource: count_gene_expr_and_chr_acc/web_summary_report
    doc: |
      Run summary metrics and charts in HTML format

  metrics_summary_report:
    type: File
    outputSource: count_gene_expr_and_chr_acc/metrics_summary_report
    doc: |
      Run summary metrics in CSV format

  barcode_metrics_report:
    type: File
    outputSource: count_gene_expr_and_chr_acc/barcode_metrics_report
    doc: |
      ATAC and GEX read count summaries generated for every
      barcode observed in the experiment. The columns contain
      the paired ATAC and Gene Expression barcode sequences,
      ATAC and Gene Expression QC metrics for that barcode,
      as well as whether this barcode was identified as a
      cell-associated partition by the pipeline.
      More details:
      https://support.10xgenomics.com/single-cell-multiome-atac-gex/software/pipelines/latest/output/per_barcode_metrics

  gex_possorted_genome_bam_bai:
    type: File
    outputSource: count_gene_expr_and_chr_acc/gex_possorted_genome_bam_bai
    doc: |
      GEX position-sorted reads aligned to the genome and transcriptome
      annotated with barcode information in BAM format

  atac_possorted_genome_bam_bai:
    type: File
    outputSource: count_gene_expr_and_chr_acc/atac_possorted_genome_bam_bai
    doc: |
      ATAC position-sorted reads aligned to the genome annotated with barcode
      information in BAM format

  filtered_feature_bc_matrix_folder:
    type: File
    outputSource: compress_filtered_feature_bc_matrix_folder/compressed_folder
    doc: |
      Compressed folder with filtered feature barcode matrix stored as a CSC
      sparse matrix in MEX format. The rows consist of all the gene and peak
      features concatenated together (identical to raw feature barcode matrix)
      and the columns are restricted to those barcodes that are identified
      as cells.

  filtered_feature_bc_matrix_h5:
    type: File
    outputSource: count_gene_expr_and_chr_acc/filtered_feature_bc_matrix_h5
    doc: |
      Filtered feature barcode matrix stored as a CSC sparse matrix in hdf5 format.
      The rows consist of all the gene and peak features concatenated together
      (identical to raw feature barcode matrix) and the columns are restricted to
      those barcodes that are identified as cells.

  raw_feature_bc_matrices_folder:
    type: File
    outputSource: compress_raw_feature_bc_matrices_folder/compressed_folder
    doc: |
      Compressed folder with raw feature barcode matrix stored as a CSC sparse
      matrix in MEX format. The rows consist of all the gene and peak features
      concatenated together and the columns consist of all observed barcodes
      with non-zero signal for either ATAC or gene expression.

  raw_feature_bc_matrices_h5:
    type: File
    outputSource: count_gene_expr_and_chr_acc/raw_feature_bc_matrices_h5
    doc: |
      Raw feature barcode matrix stored as a CSC sparse matrix in hdf5 format.
      The rows consist of all the gene and peak features concatenated together
      and the columns consist of all observed barcodes with non-zero signal for
      either ATAC or gene expression.

  secondary_analysis_report_folder:
    type: File
    outputSource: compress_secondary_analysis_report_folder/compressed_folder
    doc: |
      Compressed folder with various secondary analyses that utilize the ATAC data,
      the GEX data, and their linkage: dimensionality reduction and clustering results
      for the ATAC and GEX data, differential expression, and differential accessibility
      for all clustering results above and linkage between ATAC and GEX data.

  gex_molecule_info_h5:
    type: File
    outputSource: count_gene_expr_and_chr_acc/gex_molecule_info_h5
    doc: |
      Count and barcode information for every GEX molecule observed in the experiment
      in hdf5 format

  loupe_browser_track:
    type: File
    outputSource: count_gene_expr_and_chr_acc/loupe_browser_track
    doc: |
      Loupe Browser visualization file with all the analysis outputs

  atac_fragments_file:
    type: File
    outputSource: count_gene_expr_and_chr_acc/atac_fragments_file
    doc: |
      Count and barcode information for every ATAC fragment observed in
      the experiment in TSV format
  
  atac_peaks_bed_file:
    type: File
    outputSource: count_gene_expr_and_chr_acc/atac_peaks_bed_file
    doc: |
      Locations of open-chromatin regions identified in this sample.
      These regions are referred to as "peaks"

  atac_cut_sites_bigwig_file:
    type: File
    outputSource: count_gene_expr_and_chr_acc/atac_cut_sites_bigwig_file
    doc: |
      Genome track of observed transposition sites in the experiment
      smoothed at a resolution of 400 bases in BIGWIG format

  atac_peak_annotation_file:
    type: File
    outputSource: count_gene_expr_and_chr_acc/atac_peak_annotation_file
    doc: |
      Annotations of peaks based on genomic proximity alone.
      Note that these are not functional annotations and they
      do not make use of linkage with GEX data.

  compressed_html_data_folder:
    type: File
    outputSource: compress_html_data_folder/compressed_folder
    doc: |
      Compressed folder with Cellbrowser formatted results

  count_gene_expr_and_chr_acc_stdout_log:
    type: File
    outputSource: count_gene_expr_and_chr_acc/stdout_log
    doc: |
      stdout log generated by cellranger-arc count

  count_gene_expr_and_chr_acc_stderr_log:
    type: File
    outputSource: count_gene_expr_and_chr_acc/stderr_log
    doc: |
      stderr log generated by cellranger-arc count


steps:

  extract_gex_fastq_r1:
    run: ../tools/extract-fastq.cwl
    in:
      compressed_file: gex_fastq_file_r1
    out:
    - fastq_file

  extract_gex_fastq_r2:
    run: ../tools/extract-fastq.cwl
    in:
      compressed_file: gex_fastq_file_r2
    out:
    - fastq_file

  extract_atac_fastq_r1:
    run: ../tools/extract-fastq.cwl
    in:
      compressed_file: atac_fastq_file_r1
    out:
    - fastq_file

  extract_atac_fastq_r2:
    run: ../tools/extract-fastq.cwl
    in:
      compressed_file: atac_fastq_file_r2
    out:
    - fastq_file

  extract_atac_fastq_r3:
    run: ../tools/extract-fastq.cwl
    in:
      compressed_file: atac_fastq_file_r3
    out:
    - fastq_file

  count_gene_expr_and_chr_acc:
    run: ../tools/cellranger-arc-count.cwl
    in:
      gex_fastq_file_r1: extract_gex_fastq_r1/fastq_file
      gex_fastq_file_r2: extract_gex_fastq_r2/fastq_file
      atac_fastq_file_r1: extract_atac_fastq_r1/fastq_file
      atac_fastq_file_r2: extract_atac_fastq_r2/fastq_file
      atac_fastq_file_r3: extract_atac_fastq_r3/fastq_file
      indices_folder: indices_folder
      exclude_introns: exclude_introns
      threads: threads
      memory_limit: memory_limit
      virt_memory_limit: memory_limit
    out:
    - web_summary_report
    - metrics_summary_report
    - barcode_metrics_report
    - gex_possorted_genome_bam_bai
    - atac_possorted_genome_bam_bai
    - filtered_feature_bc_matrix_folder
    - filtered_feature_bc_matrix_h5
    - raw_feature_bc_matrices_folder
    - raw_feature_bc_matrices_h5
    - secondary_analysis_report_folder
    - gex_molecule_info_h5
    - loupe_browser_track
    - atac_fragments_file
    - atac_peaks_bed_file
    - atac_cut_sites_bigwig_file
    - atac_peak_annotation_file
    - stdout_log
    - stderr_log

  cellbrowser_build:
    run: ../tools/cellbrowser-build-cellranger-arc.cwl
    in:
      secondary_analysis_report_folder: count_gene_expr_and_chr_acc/secondary_analysis_report_folder
      filtered_feature_bc_matrix_folder: count_gene_expr_and_chr_acc/filtered_feature_bc_matrix_folder
    out:
    - html_data

  compress_filtered_feature_bc_matrix_folder:
    run: ../tools/tar-compress.cwl
    in:
      folder_to_compress: count_gene_expr_and_chr_acc/filtered_feature_bc_matrix_folder
    out:
    - compressed_folder

  compress_raw_feature_bc_matrices_folder:
    run: ../tools/tar-compress.cwl
    in:
      folder_to_compress: count_gene_expr_and_chr_acc/raw_feature_bc_matrices_folder
    out:
    - compressed_folder

  compress_secondary_analysis_report_folder:
    run: ../tools/tar-compress.cwl
    in:
      folder_to_compress: count_gene_expr_and_chr_acc/secondary_analysis_report_folder
    out:
    - compressed_folder

  compress_html_data_folder:
    run: ../tools/tar-compress.cwl
    in:
      folder_to_compress: cellbrowser_build/html_data
    out:
    - compressed_folder


$namespaces:
  s: http://schema.org/

$schemas:
- https://github.com/schemaorg/schemaorg/raw/main/data/releases/11.01/schemaorg-current-http.rdf

s:name: "Single-cell Multiome ATAC and RNA-Seq Alignment"
label: "Single-cell Multiome ATAC and RNA-Seq Alignment"
s:alternateName: |
  Runs Cell Ranger ARC Count to quantifies chromatin accessibility and gene expression
  from a single-cell Multiome ATAC and RNA-Seq library

s:downloadUrl: https://raw.githubusercontent.com/Barski-lab/scRNA-Seq-Analysis/main/workflows/sc-multiome-align-wf.cwl
s:codeRepository: https://github.com/Barski-lab/scRNA-Seq-Analysis
s:license: http://www.apache.org/licenses/LICENSE-2.0

s:isPartOf:
  class: s:CreativeWork
  s:name: Common Workflow Language
  s:url: http://commonwl.org/

s:creator:
- class: s:Organization
  s:legalName: "Cincinnati Children's Hospital Medical Center"
  s:location:
  - class: s:PostalAddress
    s:addressCountry: "USA"
    s:addressLocality: "Cincinnati"
    s:addressRegion: "OH"
    s:postalCode: "45229"
    s:streetAddress: "3333 Burnet Ave"
    s:telephone: "+1(513)636-4200"
  s:logo: "https://www.cincinnatichildrens.org/-/media/cincinnati%20childrens/global%20shared/childrens-logo-new.png"
  s:department:
  - class: s:Organization
    s:legalName: "Allergy and Immunology"
    s:department:
    - class: s:Organization
      s:legalName: "Barski Research Lab"
      s:member:
      - class: s:Person
        s:name: Michael Kotliar
        s:email: mailto:misha.kotliar@gmail.com
        s:sameAs:
        - id: http://orcid.org/0000-0002-6486-3898


doc: |
  Single-cell Multiome ATAC and RNA-Seq Alignment
  ====================================================================

  Runs Cell Ranger ARC Count to quantifies chromatin accessibility and
  gene expression from a single-cell Multiome ATAC and RNA-Seq library