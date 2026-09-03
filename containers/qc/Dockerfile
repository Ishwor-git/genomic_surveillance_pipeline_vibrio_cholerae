FROM mambaorg/micromamba:2.3.0

LABEL org.opencontainers.image.title="Vibrio Surveillance QC"
LABEL org.opencontainers.image.description="Quality control and adapter trimming with fastp"

USER root

RUN micromamba install -y -n base \
    -c conda-forge \
    -c bioconda \
    fastp=1.3.6 \
    && micromamba clean --all --yes

ENV PATH=/opt/conda/bin:$PATH

WORKDIR /work

ENTRYPOINT ["fastp"]
