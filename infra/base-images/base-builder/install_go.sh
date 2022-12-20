#!/bin/bash -eux
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

cd /tmp
curl -O https://storage.googleapis.com/golang/getgo/installer_linux
chmod +x ./installer_linux
SHELL="bash" ./installer_linux -version=1.19
rm -rf ./installer_linux

echo 'Set "GOPATH=/root/go"'
echo 'Set "PATH=$PATH:/root/.go/bin:$GOPATH/bin"'

# We need to use an overlay file that contains file replacements for source files
# that are instrumented with bug detection capabilities. There is a pull request
# open in the original repository https://github.com/mdempsky/go114-fuzz-build.
# We a fork temporarily until this PR is merged.
cd /tmp
git clone https://github.com/kyakdan/go114-fuzz-build
cd go114-fuzz-build
go build
mkdir -p $GOPATH/bin
mv go114-fuzz-build $GOPATH/bin/go-fuzz

cd /tmp
git clone https://github.com/CodeIntelligenceTesting/gofuzz
cd gofuzz
git checkout d707ca0ca2db3da909e91bab87ebd44d52b9b6a7
make build
mv build/bin/gofuzz_linux $GOPATH/bin/ci-gofuzz

cd /tmp
git clone https://github.com/AdamKorcz/go-118-fuzz-build
cd go-118-fuzz-build
go build
mv go-118-fuzz-build $GOPATH/bin/
