#!/bin/bash -eu

#manual_project_list1="nats go-sftp etcd loki caddy go-snappy istio cel-go fasthttp grpc-gateway smt runc sigstore blackfriday juju fluxcd go-ethereum cosmos-sdk fastjson linkerd2 go-redis gitea gcloud-go grpc-go tailscale go-json-iterator argo pulumi golang cascadia go-dns lotus ygot minify go-attestation"
#manual_project_list2="json-patch ipfs cilium dragonfly hugo protoreflect excelize kubernetes go-coredns gonids jsonparser teleport gvisor influxdb gopacket containerd prometheus quic-go p9 config-validator tidb radon vitess go-sqlite3 dgraph hcl golang-protobuf syzkaller tendermint mtail"

#specify some projects
export_project_list=""


export_corpora_of_list() {
    echo "Start exporting corpora for ${export_project_list}"
    mkdir -p export_corpora/fuzztargets
    for export_project_path in $export_project_list; do
      for fuzzer_path in $(find fuzztargets -name "*fuzz*" -type f -executable); do
        
        #substring magic
        fuzzer_dir=${fuzzer_path%/*}
        fuzzer_dir_sub2=${fuzzer_dir#*/}
        fuzzer_dir_sub3=${fuzzer_dir_sub2/_/__}
        fuzzertargets_project_name=${fuzzer_dir_sub3%__*}

        fuzzer_corpus=${fuzzer_dir}/corpus

        if [ "$export_project_path" = "$fuzzertargets_project_name" ]; then
          mkdir -p export_corpora/${fuzzer_dir}
          cp -R $fuzzer_corpus export_corpora/${fuzzer_dir}
        fi

        #cd export_corpora
        #zip -r fuzztargets.zip export_corpora/fuzztargets
      done
    done
    cd export_corpora
    zip -r fuzztargets.zip fuzztargets/
    echo "Corpora exported to export_corpora/fuzztargets.zip"
}

export_corpora_of_list