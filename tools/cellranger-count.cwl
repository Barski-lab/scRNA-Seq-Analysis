cwlVersion: v1.0
class: CommandLineTool


requirements:
- class: InlineJavascriptRequirement
- class: InitialWorkDirRequirement
  listing: |
    ${
      var listing = [
        {
          "entry": inputs.fastq_file_r1,
          "entryname": "sample_S1_L001_R1_001.fastq",
          "writable": true
        },
        {
          "entry": inputs.fastq_file_r2,
          "entryname": "sample_S1_L001_R2_001.fastq",
          "writable": true
        }
      ];
      if (inputs.fastq_file_i1){
        listing.push(
          {
            "entry": inputs.fastq_file_i1,
            "entryname": "sample_S1_L001_I1_001.fastq",
            "writable": true
          }
        );
      };
      return listing;
    }


hints:
- class: DockerRequirement
  dockerPull: cumulusprod/cellranger:4.0.0


inputs:
  
  fastq_file_r1:
    type: File
    doc: |
      FASTQ read 1 file (will be staged into workdir as sample_S1_L001_R1_001.fastq)

  fastq_file_r2:
    type: File
    doc: |
      FASTQ read 2 file (will be staged into workdir as sample_S1_L001_R2_001.fastq)

  fastq_file_i1:
    type: File?
    doc: |
      FASTQ index file (if provided, will be staged into workdir as sample_S1_L001_I1_001.fastq)

  indices_folder:
    type: Directory
    inputBinding:
      position: 5
      prefix: "--transcriptome"
    doc: |
      Path of folder containing 10x-compatible transcriptome reference.
      Should be generated by "cellranger mkref" command

  expect_cells:
    type: int?
    inputBinding:
      position: 6
      prefix: "--expect-cells"
    doc: |
      Expected number of recovered cells.
      Default: 3,000 cells

  force_cells:
    type: int?
    inputBinding:
      position: 7
      prefix: "--force-cells"
    doc: |
      Force pipeline to use this number of cells, bypassing the cell detection algorithm.
      Use this if the number of cells estimated by Cell Ranger is not consistent with the
      barcode rank plot.

  include_introns:
    type: boolean?
    inputBinding:
      position: 8
      prefix: "--include-introns"
    doc: |
      Add this flag to count reads mapping to intronic regions.
      This may improve sensitivity for samples with a significant
      amount of pre-mRNA molecules, such as nuclei.

  threads:
    type: int?
    inputBinding:
      position: 9
      prefix: "--localcores"
    doc: |
      Set max cores the pipeline may request at one time.
      Default: all available

  memory_limit:
    type: int?
    inputBinding:
      position: 10
      prefix: "--localmem"
    doc: |
      Set max GB the pipeline may request at one time
      Default: all available

  virt_memory_limit:
    type: int?
    inputBinding:
      position: 11
      prefix: "--localvmem"
    doc: |
      Set max virtual address space in GB for the pipeline
      Default: all available


outputs:

  web_summary_report:
    type: File
    outputBinding:
      glob: "sample/outs/web_summary.html"
    doc: |
      Run summary metrics and charts in HTML format

  metrics_summary_report:
    type: File
    outputBinding:
      glob: "sample/outs/metrics_summary.csv"
    doc: |
      Run summary metrics in CSV format

  possorted_genome_bam_bai:
    type: File
    outputBinding:
      glob: "sample/outs/possorted_genome_bam.bam"
    secondaryFiles:
    - .bai
    doc: |
      Indexed reads aligned to the genome and transcriptome annotated
      with barcode information
  
  filtered_feature_bc_matrix_folder:
    type: Directory
    outputBinding:
      glob: "sample/outs/filtered_feature_bc_matrix"
    doc: |
      Folder with filtered feature-barcode matrices containing only
      cellular barcodes in MEX format

  filtered_feature_bc_matrix_h5:
    type: File
    outputBinding:
      glob: "sample/outs/filtered_feature_bc_matrix.h5"
    doc: |
      Filtered feature-barcode matrices containing only cellular barcodes
      in HDF5 format
  
  raw_feature_bc_matrices_folder:
    type: Directory
    outputBinding:
      glob: "sample/outs/raw_feature_bc_matrix"
    doc: |
      Folder with unfiltered feature-barcode matrices containing all
      barcodes in MEX format

  raw_feature_bc_matrices_h5:
    type: File
    outputBinding:
      glob: "sample/outs/raw_feature_bc_matrix.h5"
    doc: |
      Unfiltered feature-barcode matrices containing all barcodes in HDF5 format

  secondary_analysis_report_folder:
    type: Directory
    outputBinding:
      glob: "sample/outs/analysis"
    doc: |
      Folder with secondary analysis results including dimensionality reduction,
      cell clustering, and differential expression

  molecule_info_h5:
    type: File
    outputBinding:
      glob: "sample/outs/molecule_info.h5"
    doc: |
      Molecule-level information used by cellranger aggr to aggregate samples into
      larger datasets

  loupe_browser_track:
    type: File
    outputBinding:
      glob: "sample/outs/cloupe.cloupe"
    doc: |
      Loupe Browser visualization and analysis file

  stdout_log:
    type: stdout

  stderr_log:
    type: stderr


baseCommand: ["cellranger", "count", "--disable-ui", "--fastqs", ".", "--id", "sample"]


stdout: cellranger_count_stdout.log
stderr: cellranger_count_stderr.log


$namespaces:
  s: http://schema.org/

$schemas:
- https://github.com/schemaorg/schemaorg/raw/main/data/releases/11.01/schemaorg-current-http.rdf

label: "Cell Ranger Count Gene Expression"
s:name: "Cell Ranger Count Gene Expression"
s:alternateName: "Quantifies gene expression from a single-cell RNA-Seq library"

s:downloadUrl: https://raw.githubusercontent.com/Barski-lab/scRNA-Seq-Analysis/main/tools/cellranger-count.cwl
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
  Cell Ranger Count Gene Expression
  ==============================================================
  
  Quantifies gene expression from a single-cell RNA-Seq library.

  Input parameters for Feature Barcode, Targeted Gene
  Expression and CRISPR-specific analyses are not implemented,
  therefore the correspondent outputs are also excluded.

  Parameters set by default:
  --disable-ui - no need in any UI when running in Docker
    container
  --id - can be hardcoded as we rename input files anyway
  --fastqs - points to the current directory, because input
    FASTQ files are staged there

  Why do we need to rename input files?
  Refer to the "My FASTQs are not named like any of the above
  examples" section of
  https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/fastq-input