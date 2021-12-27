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

FROM base-builder-cifuzz

# Set up Golang environment variables (copied from /root/.bash_profile).
ENV GOPATH /root/go

# /root/.go/bin is for the standard Go binaries (i.e. go, gofmt, etc).
# $GOPATH/bin is for the binaries from the dependencies installed via "go get".
ENV PATH $PATH:/root/.go/bin:$GOPATH/bin
ENV LIB_FUZZING_ENGINE -fsanitize=fuzzer

ENV GOFUZZTAG 1d80aec48f8d240be71d617dc9b2ab11e1982f3a

RUN install_go.sh

ENV GOFUZZSRC /root/go/pkg/mod/github.com/\!code\!intelligence\!testing/go-fuzz\@v0.0.0-20211221112213-1d80aec48f8d

# TODO(jonathanmetzman): Install this file using install_go.sh.
COPY ossfuzz_coverage_runner.go $GOPATH

