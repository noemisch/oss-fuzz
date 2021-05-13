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

# Move seed corpus and dictionary.
mv $SRC/{*.zip,*.dict} $OUT

# Build OpenJDK from source.
# The build ignores the environment CFLAGS and CXXFLAGS, which is correct as we
# do not want to instrument the native binaries that are part of the JDK.
bash configure \
  --with-toolchain-type=clang \
  --disable-warnings-as-errors
make images

# Move JDK to $OUT as it is used to execute the fuzzers.
rm -rf $OUT/jdk_out
mv build/linux-x86_64-server-release/images/jdk $OUT/jdk_out

for fuzzer in $(find $SRC -name '*Fuzzer.java'); do
  fuzzer_basename=$(basename -s .java $fuzzer)
  javac -cp $JAZZER_API_PATH $fuzzer
  cp $SRC/$fuzzer_basename.class $OUT/

  # Create an execution wrapper that executes Jazzer with the correct arguments.
  # In particular, pass a custom instrumentation glob to Jazzer in order to
  # instrument Java core library classes.
  echo "#!/bin/sh
# LLVMFuzzerTestOneInput for fuzzer detection.
this_dir=\$(dirname \"\$0\")
JAVA_HOME=\$this_dir/jdk_out \
LD_LIBRARY_PATH=\$this_dir/jdk_out/lib/server \
\$this_dir/jazzer_driver --agent_path=\$this_dir/jazzer_agent_deploy.jar \
--cp=\$this_dir \
--target_class=$fuzzer_basename \
--jvm_args=\"-Xmx2048m\" \
--instrumentation_includes=javax.**:sun.**:com.sun.**:java.security.**:*Fuzzer \
\$@" > $OUT/$fuzzer_basename
  chmod u+x $OUT/$fuzzer_basename
done
