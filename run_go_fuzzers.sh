#!/bin/bash -eu

prepare_fuzzers() {
  echo "Prepare fuzzer environment..."
  fuzzer_number=$(find build -name "*fuzz*" -type f -executable | wc -l)
  echo "${fuzzer_number} fuzz targets were found."

  mkdir -p fuzztargets
  for fuzz_path in $(find build -name "*fuzz*" -type f -executable); do
    #some substring magic
    sub_path=${fuzz_path#*/*/}
    fuzz_dir=${sub_path/\//_}

    mkdir -p fuzztargets/${fuzz_dir}
    cp $fuzz_path fuzztargets/${fuzz_dir}/

    mkdir -p fuzztargets/${fuzz_dir}/corpus
  done
}

start_each_fuzzer() {
  fuzzer_path=$1
  fuzzer=${fuzzer_path#*/*/}
  fuzzer_dir=${fuzzer_path%/*}
  fuzzer_corpus_path=${fuzzer_dir}/corpus
  cd $fuzzer_dir
  echo "Start ${fuzzer_path}..."
  ./$fuzzer corpus -use_value_profile=1 &> fuzzer.log || true
  echo "${fuzzer_path} CRASHED!"
}

start_fuzzers() {
  for fuzzer_path in $(find fuzztargets -name "*fuzz*" -type f -executable); do
    start_each_fuzzer $fuzzer_path &
  done
}
wait

prepare_fuzzers
start_fuzzers