FROM mambaorg/micromamba:2.3.0

LABEL org.opencontainers.image.title="Vibrio Surveillance AMR"
LABEL org.opencontainers.image.description="Antimicrobial resistance gene detection using AMRFinderPlus"

USER root

RUN micromamba install -y -n base \
    -c conda-forge \
    -c bioconda \
    ncbi-amrfinderplus=4.2.7 \
    && micromamba clean --all --yes

ENV PATH=/opt/conda/bin:$PATH

WORKDIR /work
