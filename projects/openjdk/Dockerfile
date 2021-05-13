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

FROM gcr.io/oss-fuzz-base/base-builder

RUN git clone --depth 1 https://github.com/openjdk/jdk

RUN apt-get install -y autoconf

# Install OpenJDK 16 as a bootstrap JDK.
ENV JAVA_HOME=/usr/lib/jvm/java-16-openjdk-amd64
RUN cd /tmp && \
    curl -L -O https://download.java.net/java/GA/jdk16.0.1/7147401fd7354114ac51ef3e1328291f/9/GPL/openjdk-16.0.1_linux-x64_bin.tar.gz && \
    echo "b1198ffffb7d26a3fdedc0fa599f60a0d12aa60da1714b56c1defbce95d8b235  openjdk-16.0.1_linux-x64_bin.tar.gz" | sha256sum --check && \
    mkdir -p $JAVA_HOME && \
    tar -xzv --strip-components=1 -f openjdk-16.0.1_linux-x64_bin.tar.gz --directory $JAVA_HOME && \
    rm -f openjdk-16.0.1_linux-x64_bin.tar.gz

RUN apt-get install -y libcups2-dev libx11-dev libxext-dev libxrender-dev libxrandr-dev libxtst-dev libxt-dev libasound2-dev libfontconfig1-dev

# Dictionaries
RUN git clone --depth 1 https://github.com/google/fuzzing && \
    find -name \*.dict | while read f; do tail -n1 $f | read -r _ || echo >> $f; done && \
    cat fuzzing/dictionaries/gif.dict \
        fuzzing/dictionaries/jpeg.dict \
        fuzzing/dictionaries/png.dict \
        fuzzing/dictionaries/tiff.dict \
      > $SRC/JavaxImageioImageIOReadFuzzer.dict && \
    rm -rf fuzzing

# Seed corpus (go-fuzz-corpus)
RUN git clone --depth 1 https://github.com/dvyukov/go-fuzz-corpus && \
    zip -j $SRC/JavaxImageioImageIOReadFuzzer_seed_corpus.zip go-fuzz-corpus/bmp/corpus/* && \
    zip -ju $SRC/JavaxImageioImageIOReadFuzzer_seed_corpus.zip go-fuzz-corpus/gif/corpus/* && \
    zip -ju $SRC/JavaxImageioImageIOReadFuzzer_seed_corpus.zip go-fuzz-corpus/jpeg/corpus/* && \
    zip -ju $SRC/JavaxImageioImageIOReadFuzzer_seed_corpus.zip go-fuzz-corpus/png/corpus/* && \
    zip -ju $SRC/JavaxImageioImageIOReadFuzzer_seed_corpus.zip go-fuzz-corpus/tiff/corpus/* && \
    rm -rf go-fuzz-corpus

# Copy build script and all fuzzers
COPY build.sh $SRC/
COPY JavaSecurityKeyFactoryGeneratePublicFuzzer.java JavaxImageioImageIOReadFuzzer.java $SRC/
WORKDIR $SRC/jdk
