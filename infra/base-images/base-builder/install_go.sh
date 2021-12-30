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
SHELL="bash" ./installer_linux
rm -rf ./installer_linuxv

git clone -b dev.libfuzzer.18 --single-branch https://github.com/CodeIntelligenceTesting/go.git /root/cifuzz-go
cd /root/cifuzz-go/src
./make.bash

go install github.com/CodeIntelligenceTesting/go114-fuzz-build@9926ed14738e95e0c33aacdc8effb16db6e725a1
ln -s $GOPATH/bin/go114-fuzz-build $GOPATH/bin/go-fuzz