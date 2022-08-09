import com.code_intelligence.jazzer.api.FuzzedDataProvider;

import org.osgi.framework.Filter;
import org.osgi.framework.FrameworkUtil;
import org.osgi.framework.InvalidSyntaxException;

import java.util.Dictionary;
import java.util.Hashtable;

public class CoreFilterFuzzer {

	Dictionary<String, String> m_dictionary;
	String m_filter;

	CoreFilterFuzzer(FuzzedDataProvider fuzzedDataProvider) {
		m_filter = fuzzedDataProvider.consumeString(10);
		m_dictionary = new Hashtable<String, String>();

		/*
		 * build datasets
		 */
		while(fuzzedDataProvider.remainingBytes() > 0) {
			int blocksize = fuzzedDataProvider.consumeInt(1,10);
			String key = fuzzedDataProvider.consumeString(blocksize);
			m_dictionary.put(key, key);
		}
	}

	void test() {
		Filter filter;
		try {
			filter = FrameworkUtil.createFilter(m_filter);
		} catch(InvalidSyntaxException ex) {
			/* ignore */
			return;
		}

		try {
			filter.match(m_dictionary);
		} catch(IllegalArgumentException ex) {
			/* ignore */
		}

		filter.toString();
	}

	public static void fuzzerTestOneInput(FuzzedDataProvider fuzzedDataProvider) {

		CoreFilterFuzzer testClosure = new CoreFilterFuzzer(fuzzedDataProvider);
		testClosure.test();
	}
}