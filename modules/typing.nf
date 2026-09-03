process TYPE_ISOLATE {
    tag "${sample_id}"
    container 'vibrio-typing:1.0'
    publishDir "${params.outDir}/typing", mode: 'copy'

    input:
    tuple val(sample_id), path(consensus)
    path marker_dir

    output:
    tuple val(sample_id), path("${sample_id}.typing.tsv"), emit: typing_tsv
    path ("${sample_id}.mlst.tsv"), emit: mlst_tsv

    script:
    """
    # MLST
    mlst --scheme vcholerae ${consensus} > ${sample_id}.mlst.tsv
    ST=\$(cut -f2 ${sample_id}.mlst.tsv | tail -n +2)

    # BLAST markers
    echo -e "sample_id\\tST\\tserogroup\\tbiotype\\ttoxigenic" > ${sample_id}.typing.tsv
    SEROGROUP="unknown"; BIOTYPE="unknown"; TOXIGENIC="no"

    for m in ctxB_eltor ctxB_classical tcpA_eltor tcpA_classical rfbO1 rfbO139; do
        [ -s "\${marker_dir}/\${m}.fna" ] || continue
        read len pid <<< \$(blastn -query ${consensus} -subject "\${marker_dir}/\${m}.fna" -outfmt '6 length pident' -max_target_seqs 1 -max_hsps 1 2>/dev/null | head -n1)
        [ -n "\$len" ] && [ \$(echo "\$pid > 90.0" | bc -l) -eq 1 ] && [ \$len -gt 50 ] || continue

        case \$m in
            ctxB_eltor)       TOXIGENIC="yes (El Tor)" ;;
            ctxB_classical)   TOXIGENIC="yes (Classical)" ;;
            tcpA_eltor)       BIOTYPE="El Tor" ;;
            tcpA_classical)   BIOTYPE="Classical" ;;
            rfbO1)            SEROGROUP="O1" ;;
            rfbO139)          SEROGROUP="O139" ;;
        esac
    done

    echo -e "${sample_id}\\t\${ST}\\t\${SEROGROUP}\\t\${BIOTYPE}\\t\${TOXIGENIC}" >> ${sample_id}.typing.tsv
    """
}
