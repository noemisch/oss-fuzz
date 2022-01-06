#!/bin/bash -eu
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

#$SRC/runc/tests/fuzzing/oss_fuzz_build.sh
compile_go_fuzzer github.com/opencontainers/runc/libcontainer/userns FuzzUIDMap id_map_fuzzer github.com/opencontainers/runc* gofuzz
compile_go_fuzzer github.com/opencontainers/runc/libcontainer/user FuzzUser user_fuzzer github.com/opencontainers/runc*
compile_go_fuzzer github.com/opencontainers/runc/libcontainer/configs FuzzUnmarshalJSON configs_fuzzer github.com/opencontainers/runc*

#$SRC/cncf-fuzzing/projects/runc/build.sh
go clean --modcache
go mod tidy
go mod vendor

# This one has a fuzzer that breaks
rm /root/go/pkg/mod/github.com/cilium/ebpf@v0.7.0/internal/btf/fuzz.go

rm -r $SRC/runc/vendor
go get github.com/AdaLogics/go-fuzz-headers

export RUNC_PATH=github.com/opencontainers/runc
export RUNC_FUZZERS=/src/cncf-fuzzing/projects/runc

compile_go_fuzzer $RUNC_PATH/libcontainer/userns FuzzUIDMap fuzz_uid_map github.com/opencontainers/runc*

mv $RUNC_FUZZERS/fs2_fuzzer.go $SRC/runc/libcontainer/cgroups/fs2/
compile_go_fuzzer $RUNC_PATH/libcontainer/cgroups/fs2 FuzzGetStats get_stats_fuzzer github.com/opencontainers/runc*
compile_go_fuzzer $RUNC_PATH/libcontainer/cgroups/fs2 FuzzCgroupReader cgroup_reader_fuzzer github.com/opencontainers/runc*

mv $RUNC_FUZZERS/specconv_fuzzer.go $SRC/runc/libcontainer/specconv/
compile_go_fuzzer $RUNC_PATH/libcontainer/specconv Fuzz specconv_fuzzer github.com/opencontainers/runc*

mv $RUNC_FUZZERS/devices_fuzzer.go $SRC/runc/libcontainer/cgroups/devices
compile_go_fuzzer $RUNC_PATH/libcontainer/cgroups/devices Fuzz devices_fuzzer github.com/opencontainers/runc*

mv $RUNC_FUZZERS/fscommon_fuzzer.go $SRC/runc/libcontainer/cgroups/fscommon/
compile_go_fuzzer $RUNC_PATH/libcontainer/cgroups/fscommon FuzzSecurejoin securejoin_fuzzer github.com/opencontainers/runc*

mv $RUNC_FUZZERS/intelrdt_fuzzer.go $SRC/runc/libcontainer/intelrdt/
mv $SRC/runc/libcontainer/intelrdt/util_test.go $SRC/runc/libcontainer/intelrdt/util_test_fuzz.go
compile_go_fuzzer $RUNC_PATH/libcontainer/intelrdt FuzzFindMpDir find_mountpoint_dir_fuzzer github.com/opencontainers/runc*
compile_go_fuzzer $RUNC_PATH/libcontainer/intelrdt FuzzSetCacheScema set_cache_schema_fuzzer github.com/opencontainers/runc*
compile_go_fuzzer $RUNC_PATH/libcontainer/intelrdt FuzzfindIntelRdtMountpointDir fuzz_find_intel_rdt_mountpoint_dir github.com/opencontainers/runc*
compile_go_fuzzer $RUNC_PATH/libcontainer/intelrdt FuzzParseMonFeatures parse_mon_features_fuzzer github.com/opencontainers/runc*

mv $RUNC_FUZZERS/libcontainer_fuzzer.go $SRC/runc/libcontainer/
compile_go_fuzzer $RUNC_PATH/libcontainer FuzzStateApi state_api_fuzzer github.com/opencontainers/runc*