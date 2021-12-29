#!/bin/bash -eu


buid_fuzzers() {
  project=$1
  echo "${project}: building image ..."
  yes | python3 infra/helper.py build_image $project &> build-logs/${project}-build.log
  echo "${project}: building fuzzers ..."
  python3 infra/helper.py build_fuzzers $project &>> build-logs/${project}-build.log  || true
  echo "${project}: building finished."
}

start_time=$(date +%s);

go_projects_number=$(grep "language: go" projects -R | wc -l)
echo "${go_projects_number} go projects were found."
echo "Start building:"

for project_path in $(grep "language: go" projects -Rl); do
  # some substring magic
  sub_path=${project_path#*/}
  project=${sub_path%/*}

  mkdir -p build-logs

  buid_fuzzers $project &
done
wait

end_time=$(date +%s)
elapsed=$(( end_time - start_time )); echo $elapsed
echo "Finished Building go fuzzers. Build took ${elapsed} seconds."