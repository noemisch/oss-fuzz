#!/bin/bash -eu

# manual list of go projects created on 30.12.2020 
# nats go-sftp etcd loki caddy go-snappy istio cel-go fasthttp grpc-gateway smt runc sigstore blackfriday juju fluxcd go-ethereum cosmos-sdk fastjson linkerd2 go-redis gitea gcloud-go grpc-go tailscale go-json-iterator argo pulumi golang cascadia go-dns lotus ygot minify go-attestation json-patch ipfs cilium dragonfly hugo protoreflect excelize kubernetes go-coredns gonids jsonparser teleport gvisor influxdb gopacket containerd prometheus quic-go p9 config-validator tidb radon vitess go-sqlite3 dgraph hcl golang-protobuf syzkaller tendermint mtail

#manual_project_list1="nats go-sftp etcd loki caddy go-snappy istio cel-go fasthttp grpc-gateway smt runc sigstore blackfriday juju fluxcd go-ethereum cosmos-sdk fastjson linkerd2 go-redis gitea gcloud-go grpc-go tailscale go-json-iterator argo pulumi golang cascadia go-dns lotus ygot minify go-attestation"
#manual_project_list2="json-patch ipfs cilium dragonfly hugo protoreflect excelize kubernetes go-coredns gonids jsonparser teleport gvisor influxdb gopacket containerd prometheus quic-go p9 config-validator tidb radon vitess go-sqlite3 dgraph hcl golang-protobuf syzkaller tendermint mtail"

#specify some projects
manual_project_list=""

build_fuzzer() {
  project=$1
  echo "${project}: building image ..."
  yes | python3 infra/helper.py build_image $project &> build-logs/${project}-build.log
  echo "${project}: building fuzzers ..."
  python3 infra/helper.py build_fuzzers $project &>> build-logs/${project}-build.log  || true
  
  if grep -q "fuzzers failed" build-logs/${project}-build.log; then
    echo "${project}: building FAILED!"
  else
    echo "${project}: building finished."
  fi
}


build_all_fuzzer() {
  start_time=$(date +%s);

  go_projects_number=$(grep "language: go" projects -R | wc -l)
  echo "${go_projects_number} go projects were found."
  echo "Start building:"

  for project_path in $(grep "language: go" projects -Rl); do
    # some substring magic
    sub_path=${project_path#*/}
    project=${sub_path%/*}

    mkdir -p build-logs
    build_fuzzer $project &
  done
  wait

  end_time=$(date +%s)
  elapsed=$(( end_time - start_time ))
  echo "Finished Building go fuzzers. Build took ${elapsed} seconds."
}


build_fuzzer_from_list() {
  start_time=$(date +%s);
  echo "Start building: ${manual_project_list}"
  
  for project_path in $manual_project_list; do
    # some substring magic
    sub_path=${project_path#*/}
    project=${sub_path%/*}

    mkdir -p build-logs
    build_fuzzer $project &
  done
  wait

  end_time=$(date +%s)
  elapsed=$(( end_time - start_time ))
  echo "Finished Building go fuzzers. Build took ${elapsed} seconds."
}


# Uncomment if you want to build all fuzz targets
#build_all_fuzzer

# build only projects in manual_project_list
build_fuzzer_from_list