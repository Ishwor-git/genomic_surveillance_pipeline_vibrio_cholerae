# Classical ctxB
DATA_DIR="$(pwd)"
MARKER_DIR="${DATA_DIR}/markers"

mkdir -p "${MARKER_DIR}"

# Extract ctxB_eltor from the reference (coordinates from earlier)
samtools faidx ref/GCF_900205735.1_N16961_v2_genomic.fna "NZ_LT906614.1:1566979-1567353" | \
    sed "s/^>.*/>ctxB_eltor_N16961/" > ${MARKER_DIR}/ctxB_eltor.fna

# Extract tcpA_eltor from the reference (coordinates from earlier)
samtools faidx ref/GCF_900205735.1_N16961_v2_genomic.fna "NZ_LT906614.1:890454-891128" | \
    sed "s/^>.*/>tcpA_eltor_N16961/" > ${MARKER_DIR}/tcpA_eltor.fna

curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=HM143770&rettype=fasta&retmode=text" | sed "s/^>.*/>ctxB_classical_O395/" > ${MARKER_DIR}/ctxB_classical.fna

# Classical tcpA
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=M36980&rettype=fasta&retmode=text" | sed "s/^>.*/>tcpA_classical_O395/" > ${MARKER_DIR}/tcpA_classical.fna

# O139 rfb
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=AF263334&rettype=fasta&retmode=text" | \
    sed 's/^>.*/>rfbO1_cluster_N16961/' > ${MARKER_DIR}/rfbO1.fna

# Try to get O1 rfb (from NC_002505)
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NC_002505&rettype=fasta&retmode=text" | grep -A 50 "rfbV" | sed 's/^>.*/>rfbO1_eltor_N16961/' > ${MARKER_DIR}/rfbO1.fna
