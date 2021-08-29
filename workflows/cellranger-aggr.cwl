cwlVersion: v1.0
class: Workflow


requirements:
- class: SubworkflowFeatureRequirement
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement
- class: MultipleInputFeatureRequirement


inputs:

  molecule_info_h5:
    type: File[]
    doc: "Molecule-level information from individual runs of cellranger count"

  gem_well_labels:
    type: string[]
    doc: "Array of GEM well identifiers to be used for labeling purposes only"

  normalization_mode:
    type:
    - "null"
    - type: enum
      symbols: ["none", "mapped"]
    default: "mapped"
    doc: "Library depth normalization mode"

  threads:
    type: int?
    default: 4
    doc: "Number of threads for those steps that support multithreading"

  memory_limit:
    type: int?
    default: 20
    doc: "Maximum memory used (GB). The same will be applied to virtual memory"


outputs:

  web_summary_report:
    type: File
    outputSource: aggregate_counts/web_summary_report
    doc: "Aggregated run summary metrics and charts in HTML format"

  metrics_summary_report_json:
    type: File
    outputSource: aggregate_counts/metrics_summary_report_json
    doc: "Aggregated run summary metrics in JSON format"

  secondary_analysis_report_folder:
    type: File
    outputSource: compress_secondary_analysis_report_folder/compressed_folder
    doc: "Compressed folder with aggregated secondary analysis results"

  filtered_feature_bc_matrix_folder:
    type: File
    outputSource: compress_filtered_feature_bc_matrix_folder/compressed_folder
    doc: "Compressed folder with aggregated filtered feature-barcode matrices in MEX format"

  filtered_feature_bc_matrix_h5:
    type: File
    outputSource: aggregate_counts/filtered_feature_bc_matrix_h5
    doc: "Aggregated filtered feature-barcode matrices in HDF5 format"
  
  raw_feature_bc_matrices_folder:
    type: File
    outputSource: compress_raw_feature_bc_matrices_folder/compressed_folder
    doc: "Compressed folder with aggregated unfiltered feature-barcode matrices in MEX format"

  raw_feature_bc_matrices_h5:
    type: File
    outputSource: aggregate_counts/raw_feature_bc_matrices_h5
    doc: "Aggregated unfiltered feature-barcode matrices in HDF5 format"

  loupe_browser_track:
    type: File
    outputSource: aggregate_counts/loupe_browser_track
    doc: "Loupe Browser visualization and analysis file for aggregated results"

  aggregation_metadata:
    type: File
    outputSource: aggregate_counts/aggregation_metadata
    doc: "Aggregation metadata in CSV format"

  aggregate_counts_stdout_log:
    type: File
    outputSource: aggregate_counts/stdout_log
    doc: "Stdout log generated by cellranger aggr"

  aggregate_counts_stderr_log:
    type: File
    outputSource: aggregate_counts/stderr_log
    doc: "Stderr log generated by cellranger aggr"

  compressed_html_data_folder:
    type: File
    outputSource: compress_html_data_folder/compressed_folder
    doc: "Compressed folder with CellBrowser formatted results"

  html_data_folder:
    type: Directory
    outputSource: cellbrowser_build/html_data
    doc: "Folder with not compressed CellBrowser formatted results"

  cellbrowser_report:
    type: File
    outputSource: cellbrowser_build/index_html_file
    doc: "CellBrowser formatted Cellranger report"


steps:

  aggregate_counts:
    run: ../tools/cellranger-aggr.cwl
    in:
      molecule_info_h5: molecule_info_h5
      gem_well_labels: gem_well_labels
      normalization_mode: normalization_mode
      threads: threads
      memory_limit: memory_limit
      virt_memory_limit: memory_limit
    out:
    - web_summary_report
    - metrics_summary_report_json
    - secondary_analysis_report_folder
    - filtered_feature_bc_matrix_folder
    - filtered_feature_bc_matrix_h5
    - raw_feature_bc_matrices_folder
    - raw_feature_bc_matrices_h5
    - aggregation_metadata
    - loupe_browser_track
    - stdout_log
    - stderr_log

  compress_filtered_feature_bc_matrix_folder:
    run: ../tools/tar-compress.cwl
    in:
      folder_to_compress: aggregate_counts/filtered_feature_bc_matrix_folder
    out:
    - compressed_folder

  compress_raw_feature_bc_matrices_folder:
    run: ../tools/tar-compress.cwl
    in:
      folder_to_compress: aggregate_counts/raw_feature_bc_matrices_folder
    out:
    - compressed_folder

  compress_secondary_analysis_report_folder:
    run: ../tools/tar-compress.cwl
    in:
      folder_to_compress: aggregate_counts/secondary_analysis_report_folder
    out:
    - compressed_folder

  cellbrowser_build:
    run: ../tools/cellbrowser-build-cellranger.cwl
    in:
      secondary_analysis_report_folder: aggregate_counts/secondary_analysis_report_folder
      filtered_feature_bc_matrix_folder: aggregate_counts/filtered_feature_bc_matrix_folder
      aggregation_metadata: aggregate_counts/aggregation_metadata
    out:
    - html_data
    - index_html_file

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

label: "Cell Ranger Aggregate"
s:name: "Cell Ranger Aggregate"
s:alternateName: "Aggregates data from multiple Cell Ranger Count Gene Expression experiments"

s:downloadUrl: https://raw.githubusercontent.com/Barski-lab/scRNA-Seq-Analysis/master/workflows/cellranger-aggr.cwl
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
  Cell Ranger Aggregate
  =====================

  Aggregates data from multiple Cell Ranger Count Gene Expression experiments