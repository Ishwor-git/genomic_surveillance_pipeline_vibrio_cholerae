FROM mambaorg/micromamba:2.3.0

LABEL org.opencontainers.image.title="Vibrio Surveillance Typing"
LABEL org.opencontainers.image.description="MLST and Vibrio cholerae marker-based typing"

USER root

RUN micromamba install -y -n base \
    -c conda-forge \
    -c bioconda \
    mlst=2.35 \
    blast=2.17.0 \
    bc \
    && micromamba clean --all --yes

ENV PATH=/opt/conda/bin:$PATH

WORKDIR /work
