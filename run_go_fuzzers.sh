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
  start_time=$(date +%s);

  fuzzer_path=$1
  fuzzer=${fuzzer_path#*/*/}
  fuzzer_dir=${fuzzer_path%/*}
  fuzzer_corpus_path=${fuzzer_dir}/corpus
  cd $fuzzer_dir
  echo "Start ${fuzzer_path}..."
  ./$fuzzer corpus -use_value_profile=1 &> full.log || true
  end_time=$(date +%s)
  elapsed=$(( end_time - start_time ))
  
  #minimize log, only save last 200 lines
  echo "$(tail -150 full.log)" > fuzzer.log
  rm -f full.log

  if grep -q "panic" fuzzer.log; then
    echo "${fuzzer_path}: Stopped after ${elapsed} seconds! PANIC found"
  elif grep -q "no interesting inputs were found" fuzzer.log; then
    echo "${fuzzer_path}: Stopped after ${elapsed} seconds! Please adjust instrumentation filer. No interesting inputs found."
  elif grep -q "ALARM: working on the last Unit for" fuzzer.log; then
    echo "${fuzzer_path}: Stopped after ${elapsed} seconds! TIMEOUT found"
  elif grep -q "ERROR: libFuzzer: out-of-memory" fuzzer.log; then
    echo "${fuzzer_path}: Stopped after ${elapsed} seconds! libfuzzer out-of-memory found"
  else
    echo "${fuzzer_path}: Stopped after ${elapsed} seconds! Something else found. Check ${fuzzer_dir}/fuzzer.log"
  fi
}

start_all_fuzzers() {
  for fuzzer_path in $(find fuzztargets -name "*fuzz*" -type f -executable); do
    start_each_fuzzer $fuzzer_path &
  done
  wait
}

clean_full_log_files() {
  echo " ..."
  echo "Clean: Delete all full.log files in fuzztargets"
  find fuzztargets -name "full.log" -exec rm -rf {} \;
}

start_half_of_fuzzers_alternating() {
  
  #create two lists
  fuzzer_path_list1=""
  fuzzer_path_list2=""
  counter=1
  for fuzzer_path in $(find fuzztargets -name "*fuzz*" -type f -executable); do
    if [ $((counter%2)) -eq 0 ]; then
      fuzzer_path_list1="${fuzzer_path_list1} ${fuzzer_path} "
    else
      fuzzer_path_list2="${fuzzer_path_list2} ${fuzzer_path} "
    fi
    counter=$counter+1
  done
  
  while :
  do
    echo "Start fuzzing of first half: ${fuzzer_path_list1}"
    for fuzzer_path in $fuzzer_path_list1; do
      start_each_fuzzer $fuzzer_path &
    done
    sleep 3600
    pkill -P $$ -9
    wait   
    echo "Finished fuzzing of first half"
    #give some time to recover
    sleep 5
    clean_full_log_files
    
    echo "Lets switch! Start fuzzing of second half: ${fuzzer_path_list2}"
    for fuzzer_path in $fuzzer_path_list2; do
      start_each_fuzzer $fuzzer_path &
    done
    sleep 3600
    pkill -P $$ -9
    wait
    echo "Finished fuzzing of second half"

    #give some time to recover
    sleep 5 
    clean_full_log_files
    
    echo "NEW ROUND started"
  done
}

cleanup() {
    clean_full_log_files
    echo "exit"
    exit
}

prepare_fuzzers
#start_all_fuzzers
trap cleanup SIGINT
start_half_of_fuzzers_alternating


