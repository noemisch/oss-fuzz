
// Copyright 2022 Google LLC
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

import javax.ws.rs.core.NewCookie;
import javax.ws.rs.core.Cookie;
import javax.ws.rs.ext.RuntimeDelegate;
import javax.ws.rs.core.RuntimeDelegateStub;

public class NewCookieFuzzer {
  public static void fuzzerTestOneInput(FuzzedDataProvider data) {
    try{
      RuntimeDelegate.setInstance(new RuntimeDelegateStub());
      Cookie c = new Cookie(data.consumeString(1000), data.consumeRemainingAsString());
      NewCookie nc = new NewCookie(c);
      nc.hashCode();
    }
    catch (IllegalArgumentException e){
      return;
    }
  }
}
