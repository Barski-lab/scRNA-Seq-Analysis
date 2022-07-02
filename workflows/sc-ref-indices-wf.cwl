cwlVersion: v1.0
class: Workflow


requirements:
  - class: SubworkflowFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement


inputs:

  genome_fasta_file:
    type: File
    doc: |
      Reference genome FASTA file that includes all chromosomes

  annotation_gtf_file:
    type: File
    doc: |
      Reference genome GTF annotation file that includes refGene
      and mitochondrial DNA annotations

  threads:
    type: int?
    default: 4
    doc: |
      Number of threads for those steps that support multithreading

  memory_limit:
    type: int?
    default: 20
    doc: |
      Maximum memory used (GB). The same will be applied to virtual memory


outputs:

  indices_folder:
    type: Directory
    outputSource: cellranger_mkref/indices_folder
    doc: |
      Cell Ranger reference genome indices folder

  arc_indices_folder:
    type: Directory
    outputSource: cellranger_arc_mkref/indices_folder
    doc: |
      Cell Ranger ARC reference genome indices folder

  stdout_log:
    type: File
    outputSource: cellranger_mkref/stdout_log
    doc: |
      stdout log generated by cellranger mkref

  stderr_log:
    type: File
    outputSource: cellranger_mkref/stderr_log
    doc: |
      stderr log generated by cellranger mkref

  arc_stdout_log:
    type: File
    outputSource: cellranger_arc_mkref/stdout_log
    doc: |
      stdout log generated by cellranger-arc mkref

  arc_stderr_log:
    type: File
    outputSource: cellranger_arc_mkref/stderr_log
    doc: |
      stderr log generated by cellranger-arc mkref


steps:

  cellranger_mkref:
    doc: |
      Builds Cell Ranger compatible reference folder from the
      custom genome FASTA and gene GTF annotation files
    run: ../tools/cellranger-mkref.cwl
    in:
      genome_fasta_file: genome_fasta_file
      annotation_gtf_file: annotation_gtf_file
      threads: threads
      memory_limit: memory_limit
      output_folder_name:
        default: "cellranger_ref"
    out:
    - indices_folder
    - stdout_log
    - stderr_log

  sort_annotation_gtf:
    doc: |
      Cell Ranger ARC fails to run with UCSC Refgene annotation
      if records are not grouped by gene_id - due to duplicates
      in gene_ids, so we need to sort them first.
    run:
      cwlVersion: v1.0
      class: CommandLineTool
      hints:
      - class: DockerRequirement
        dockerPull: python:3.8.6
      inputs:
        script:
          type: string?
          default: |
            #!/usr/bin/env python3
            import re
            import fileinput
            class Gtf(object):
              def __init__(self, gtf_line):
                self.gtf_list = gtf_line.split("\t")
                self.attribute = self.gtf_list[8]
                tmp = map(lambda x: re.split("\s+", x.replace('"', "")), re.split("\s*;\s*", self.attribute.strip().strip(";")))
                self.attribute = dict([x for x in tmp if len(x)==2])
              def __str__(self):
                return "\t".join(self.gtf_list)
            records = []
            for gtf_line in fileinput.input():
              records.append(Gtf(gtf_line))
            records.sort(key=lambda x: (x.attribute["gene_id"]))
            for l in records:
              print(l, end="")
          inputBinding:
            position: 5
        annotation_gtf_file:
          type: File
          inputBinding:
            position: 6
      outputs:
        sorted_annotation_gtf_file:
          type: stdout
      baseCommand: ["python3", "-c"]
      stdout: "sorted.gtf"
    in:
      annotation_gtf_file: annotation_gtf_file
    out:
    - sorted_annotation_gtf_file

  cellranger_arc_mkref:
    doc: |
      Builds Cell Ranger ARC compatible reference folder from the
      custom genome FASTA and gene GTF annotation files
    run: ../tools/cellranger-arc-mkref.cwl
    in:
      genome_fasta_file: genome_fasta_file
      annotation_gtf_file: sort_annotation_gtf/sorted_annotation_gtf_file
      exclude_chr:
        default: ["chrM"]                        # as recommended in Cell Ranger ARC manual
      output_folder_name:
        default: "cellranger_arc_ref"
      threads: threads
      memory_limit: memory_limit
    out:
    - indices_folder
    - stdout_log
    - stderr_log


$namespaces:
  s: http://schema.org/

$schemas:
- https://github.com/schemaorg/schemaorg/raw/main/data/releases/11.01/schemaorg-current-http.rdf

label: "Single-cell Reference Indices"
s:name: "Single-cell Reference Indices"
s:alternateName: |
  Builds Cell Ranger and Cell Ranger ARC compatible reference folders from
  the custom genome FASTA and gene GTF annotation files

s:downloadUrl: https://raw.githubusercontent.com/Barski-lab/sc-seq-analysis/main/workflows/sc-ref-indices-wf.cwl
s:codeRepository: https://github.com/Barski-lab/sc-seq-analysis
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
  Single-cell Reference Indices

  Builds a Cell Ranger and Cell Ranger ARC compatible reference
  folders from the custom genome FASTA and gene GTF annotation
  files