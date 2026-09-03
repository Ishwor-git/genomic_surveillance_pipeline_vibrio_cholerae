FROM mambaorg/micromamba:2.3.0

LABEL org.opencontainers.image.title="Vibrio Surveillance Variant Calling"
LABEL org.opencontainers.image.description="Variant calling, normalization, filtering and consensus generation"

USER root

RUN micromamba install -y -n base \
    -c conda-forge \
    -c bioconda \
    bcftools=1.24 \
    htslib=1.24 \
    && micromamba clean --all --yes

ENV PATH=/opt/conda/bin:$PATH

WORKDIR /work
