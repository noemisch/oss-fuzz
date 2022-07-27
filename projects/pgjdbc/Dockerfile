# Copyright 2022 Google LLC
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

FROM gcr.io/oss-fuzz-base/base-builder-jvm

RUN wget https://services.gradle.org/distributions/gradle-7.4.2-bin.zip -O gradle.zip && \
    unzip gradle.zip -d $SRC/gradle && \
    rm -rf gradle.zip

ENV GRADLE $SRC/gradle/gradle-7.4.2/bin/gradle

RUN apt-get install -y postgresql-all sudo

RUN git clone https://github.com/pgjdbc/pgjdbc.git pgjdbc

COPY build.sh $SRC/
COPY *.java $SRC/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN  chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

WORKDIR $SRC/pgjdbc