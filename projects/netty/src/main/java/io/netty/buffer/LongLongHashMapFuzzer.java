package io.netty.buffer;
import com.code_intelligence.jazzer.api.FuzzedDataProvider;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.PrimitiveIterator.OfLong;
import java.util.Set;


public class LongLongHashMapFuzzer {
    
    private FuzzedDataProvider fuzzedDataProvider;

	public LongLongHashMapFuzzer(FuzzedDataProvider fuzzedDataProvider) {
		this.fuzzedDataProvider = fuzzedDataProvider;

	}

	void test() {
        Map<Long, Long> expected = new HashMap<Long, Long>();
        LongLongHashMap actual = new LongLongHashMap(-1);
        while (fuzzedDataProvider.remainingBytes() >= 9) {
            long value = fuzzedDataProvider.consumeLong();
            if (expected.containsKey(value)) {
                //assertThat(actual.get(value)).isEqualTo(expected.get(value));
                if (fuzzedDataProvider.consumeBoolean()) {
                    actual.remove(value);
                    expected.remove(value);
                    //assertThat(actual.get(value)).isEqualTo(-1);
                } else {
                    long v = expected.get(value);
                    actual.put(value, -v);
                    expected.put(value, -v);
                    //assertThat(actual.put(value, -v)).isEqualTo(expected.put(value, -v));
                }
            } else {
                //assertThat(actual.get(value)).isEqualTo(-1);
                actual.put(value, value);
                //assertThat(actual.put(value, value)).isEqualTo(-1);
                expected.put(value, value);
            }
        }

	}

	public static void fuzzerTestOneInput(FuzzedDataProvider fuzzedDataProvider) {

		LongLongHashMapFuzzer fixture = new LongLongHashMapFuzzer(fuzzedDataProvider);
		fixture.test();
	}
}