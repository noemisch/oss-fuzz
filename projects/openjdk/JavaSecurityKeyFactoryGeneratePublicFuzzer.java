// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

import com.code_intelligence.jazzer.api.FuzzedDataProvider;

import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;

public class JavaSecurityKeyFactoryGeneratePublicFuzzer {
    private static String[] VALID_ALGORITHMS = {
            "DiffieHellman",
            "DSA",
            "EC",
            "EdDSA",
            "Ed25519",
            "Ed448",
            "RSA",
            "RSASSA-PSS",
            "XDH",
            "X25519",
            "X448",
    };

    public static void fuzzerTestOneInput(FuzzedDataProvider data) {
        try {
            KeyFactory keyFactory = KeyFactory.getInstance(data.pickValue(VALID_ALGORITHMS));
            X509EncodedKeySpec keySpec = new X509EncodedKeySpec(data.consumeRemainingAsBytes());
            keyFactory.generatePublic(keySpec);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException ignored) {
        }
    }
}
