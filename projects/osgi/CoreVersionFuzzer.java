import com.code_intelligence.jazzer.api.FuzzedDataProvider;

import org.osgi.framework.Version;

public class CoreVersionFuzzer {
	public static void fuzzerTestOneInput(FuzzedDataProvider fuzzedDataProvider) {
		Version v = null;
		try {
			v = new Version(fuzzedDataProvider.consumeRemainingAsString());
		} catch(IllegalArgumentException ex) {
			/* documented, ignore */
			return;
		}

		/*
		 * these don't throw exceptions
		 */
		v.getMajor();
		v.getMinor();
		v.getMicro();
		v.getQualifier();
		v.toString();
	}
}