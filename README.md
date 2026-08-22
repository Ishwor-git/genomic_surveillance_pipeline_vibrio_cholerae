# Vibrio cholerae Genomic Surveillance Pipeline

A Nextflow (DSL2) pipeline that turns Illumina whole-genome reads of
*Vibrio cholerae* into a trimmed dataset, a mapped BAM, a variant call set, a
consensus genome, and an AMR / virulence report.

## What we built

A modular, reproducible pipeline composed of five independent Nextflow modules:

- **TRIM_READS** — quality trimming & adapter removal (`fastp`), emits a QC
  report (HTML/JSON).
- **ALIGN_READS** — reference alignment with `bwa-mem2`, sorting and indexing
  with `samtools`.
- **VARIANT_CALLING** — variant discovery with `bcftools mpileup` +
  `bcftools call -mv`.
- **GENERATE_CONSENSUS** — builds a consensus sequence with `bcftools consensus`.
- **SCREEN_AMR** — screens the consensus for resistance and virulence genes
  with `amrfinder --plus`.

The workflow (`main.nf`) chains these stages and publishes every output to a
structured `results/` tree. A `nextflow.config` defines a `standard` local
executor profile and pipeline manifest, and `nf-test` unit tests with snapshots
cover the modules.

## Test run — what we achieved

We executed the full pipeline end-to-end on test isolate **SRR40299199**
(*V. cholerae* O1 biovar El Tor str. N16961). **All five stages completed
successfully with zero failures** (4 stages served from cache on re-run).

### How we did it
1. **QC** — `fastp` retained 2,006,000 reads / 297.5 Mb (from 2,017,204 reads /
   299.2 Mb), dropping ~11k low-quality reads. QC report:
   `results/trimmed/SRR40299199.fastp.html`.
2. **Alignment** — trimmed reads were mapped to the N16961 reference with
   `bwa-mem2` and produced a sorted, indexed BAM (`results/bam/`).
3. **Variant calling** — `bcftools` produced **231 variants** (SNPs + indels)
   in `results/vcf/SRR40299199.raw.vcf`.
4. **Consensus** — `bcftools consensus` generated the full consensus genome
   (`results/consensus/SRR40299199.consensus.fasta`).
5. **AMR / virulence screen** — `amrfinder --plus` scanned the consensus and
   wrote `results/amr/SRR40299199.amr.tsv`.

### What we found

**Virulence — toxigenic profile confirmed:**
- `ctxA` + `ctxB` (cholera toxin subunits): 100% coverage, 100% identity.

**Antimicrobial resistance:**
| Gene | Class | Mechanism |
|------|-------|-----------|
| `varG` | β-lactam (carbapenem) | metallo-β-lactamase |
| `almE`, `almF`, `almG` | colistin | lipid-A glycine modification |
| `emrD3` | efflux | multidrug MFS transporter |
| `catB9` | phenicol | chloramphenicol O-acetyltransferase |

All AMR and virulence hits showed 100% reference coverage and ≥97.6% identity.

> **Caveat:** The test reads originate from the N16961 reference strain, so most
> of the 231 "variants" reflect reference/sample discrepancies rather than true
> polymorphisms. For real surveillance, run an independent isolate and apply
> variant filters (QUAL, DP, AF) before interpretation.

## Results layout

    results/
    ├── trimmed/   *_1.trim.fastq, *_2.trim.fastq, .fastp.html, .fastp.json
    ├── bam/       *.sorted.bam (.bai)
    ├── vcf/       *.raw.vcf.gz (.csi)
    ├── consensus/ *.consensus.fasta
    └── amr/       *.amr.tsv

## References

- Di Tommaso et al. (2017) *Nextflow enables reproducible computational
  workflows.* Nat Biotechnol 35:316–319. https://doi.org/10.1038/nbt.3820
- Chen et al. (2018) *fastp: an ultra-fast all-in-one FASTQ preprocessor.*
  Bioinformatics 34:i884–i890. https://doi.org/10.1093/bioinformatics/bty560
- Vasimuddin et al. (2019) *Efficient and accurate mapping of Illumina reads
  using bwa-mem2* (bwa-mem2). IEEE IPDPS.
  (original BWA-MEM: Li, 2013, arXiv:1303.3997)
- Danecek et al. (2021) *Twelve years of SAMtools and BCFtools.* GigaScience
  10:giab008. https://doi.org/10.1093/gigascience/giab008
- Li (2011) *A statistical framework for SNP calling, mutation discovery,
  association mapping and population genetical parameter estimation from
  sequencing data* (bcftools / mpileup). Bioinformatics 27:2987–2993.
- Feldgarden et al. (2021) *AMRFinderPlus and the Reference Gene Catalog
  facilitate examination of the genomic links among antimicrobial resistance,
  stress response, and virulence.* Sci Rep 11:12728.
  https://doi.org/10.1038/s41598-021-91456-0
- Heidelberg et al. (2000) *DNA sequence of both chromosomes of the cholera
  pathogen Vibrio cholerae* (N16961 reference genome). Nature 406:477–483.
  https://doi.org/10.1038/35020000
