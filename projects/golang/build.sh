# Copyright 2020 Google Inc.
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

# These two dependencies cause build issues and are not used by oss-fuzz:
rm -r sqlparser
rm -r parser

mkdir math && cp $SRC/math_big_fuzzer.go ./math/

go get -u golang.org/x/text
mkdir text && cp $SRC/text_fuzzer.go ./text/

go mod init "github.com/dvyukov/go-fuzz-corpus"
export FUZZ_ROOT="github.com/dvyukov/go-fuzz-corpus"
compile_go_fuzzer $FUZZ_ROOT/text FuzzAcceptLanguage accept_language_fuzzer golang.org/x/text*
compile_go_fuzzer $FUZZ_ROOT/text FuzzCurrency currency_fuzzer golang.org/x/text* 
compile_go_fuzzer $FUZZ_ROOT/math FuzzBigIntCmp1 big_cmp_fuzzer1 math/big*
compile_go_fuzzer $FUZZ_ROOT/math FuzzBigIntCmp2 big_cmp_fuzzer2 math/big*
compile_go_fuzzer $FUZZ_ROOT/math FuzzRatSetString big_rat_fuzzer math/big*
compile_go_fuzzer $FUZZ_ROOT/asn1 Fuzz asn_fuzzer encoding/asn1*
compile_go_fuzzer $FUZZ_ROOT/csv Fuzz csv_fuzzer encoding/csv*
compile_go_fuzzer $FUZZ_ROOT/elliptic Fuzz elliptic_fuzzer crypto/elliptic*
compile_go_fuzzer $FUZZ_ROOT/flate Fuzz flate_fuzzer compress/flate*
compile_go_fuzzer $FUZZ_ROOT/fmt Fuzz fmt_fuzzer fmt*
compile_go_fuzzer $FUZZ_ROOT/gzip Fuzz gzip_fuzzer compress/gzip* 
compile_go_fuzzer $FUZZ_ROOT/httpreq Fuzz httpreq_fuzzer net/http*
compile_go_fuzzer $FUZZ_ROOT/jpeg Fuzz jpeg_fuzzer image/jpeg*
compile_go_fuzzer $FUZZ_ROOT/json Fuzz json_fuzzer encoding/json*
compile_go_fuzzer $FUZZ_ROOT/lzw Fuzz lzw_fuzzer compress/lzw*
compile_go_fuzzer $FUZZ_ROOT/mime Fuzz mime_fuzzer mime*
compile_go_fuzzer $FUZZ_ROOT/multipart Fuzz multipart_fuzzer mime/multipart*
compile_go_fuzzer $FUZZ_ROOT/png Fuzz png_fuzzer image/png*
compile_go_fuzzer $FUZZ_ROOT/tar Fuzz tar_fuzzer archive/tar*
compile_go_fuzzer $FUZZ_ROOT/time Fuzz time_fuzzer time*
compile_go_fuzzer $FUZZ_ROOT/xml Fuzz xml_fuzzer encoding/xml*
compile_go_fuzzer $FUZZ_ROOT/zip Fuzz zip_fuzzer archive/zip*
compile_go_fuzzer $FUZZ_ROOT/zlib Fuzz zlib_fuzzer compress/zlib*
