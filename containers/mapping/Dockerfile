FROM mambaorg/micromamba:2.3.0

LABEL org.opencontainers.image.title="Vibrio Surveillance Mapping"
LABEL org.opencontainers.image.description="Read alignment and BAM processing"

USER root

RUN micromamba install -y -n base \
    -c conda-forge \
    -c bioconda \
    bwa-mem2=2.3 \
    samtools=1.24 \
    && micromamba clean --all --yes

ENV PATH=/opt/conda/bin:$PATH

WORKDIR /work
