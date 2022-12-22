package ossfuzz;

import com.code_intelligence.jazzer.api.FuzzedDataProvider;

import java.io.DataOutputStream;
import java.io.IOException;
import java.net.*;
import org.apache.http.client.utils.URIBuilder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.apache.axis2.kernel.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


public class XLSX2CSVFuzzer extends SimpleAxis2Server {

    private static final Log log = LogFactory.getLog(XLSX2CSVFuzzer.class);

    private FuzzedDataProvider fuzzedDataProvider;

    public XLSX2CSVFuzzer(FuzzedDataProvider fuzzedDataProvider) throws Exception {
        super(null, null);
        this.fuzzedDataProvider = fuzzedDataProvider;
    }

    void test() {
        try{
            var client = HttpClient.newHttpClient();
            URI uri = new URI("http://localhost:6060/axis2/services/HelloWorld/" + fuzzedDataProvider.consumeRemainingAsString());
            var request = HttpRequest.newBuilder(uri)
                        .GET()
                        .build();
            var reponse = client.send(request, HttpResponse.BodyHandlers.ofString());
            System.out.println(reponse);

        } catch (MalformedURLException e)
        {
            
        } catch (IOException e)
        {

        } catch (URISyntaxException e) {

        } catch (InterruptedException e)
        {

        }



    }

    public static void fuzzerTestOneInput(FuzzedDataProvider fuzzedDataProvider)  throws Exception {
        XLSX2CSVFuzzer server = null;
        try {
            server = new XLSX2CSVFuzzer(null);
            server.deployService("ossfuzz.HelloWorld");
            server.start();
            log.info("[SimpleAxisServer] Started");
            System.out.println("[SimpleAxisServer] Started");
        } catch (Throwable t) {
            log.fatal("[SimpleAxisServer] Shutting down. Error starting SimpleAxisServer", t);
            System.err.println("[SimpleAxisServer] Shutting down. Error starting SimpleAxisServer");
        }

        System.out.println("Hello World");
        XLSX2CSVFuzzer fixture = new XLSX2CSVFuzzer(fuzzedDataProvider);
        fixture.test();


        try {
            System.err.println("[SimpleAxisServer] Shutting down.");
            server.stop();
            System.err.println("[SimpleAxisServer] Shutdown complete");
        } catch (Throwable t) {
            log.fatal("[SimpleAxisServer] Failed to shut down.");
        }


    }

    public static void main(String []args) {
        try {
            XLSX2CSVFuzzer server = new XLSX2CSVFuzzer(null);
            server.deployService("ossfuzz.HelloWorld");
            server.start();
            log.info("[SimpleAxisServer] Started");
            System.out.println("[SimpleAxisServer] Started");
        } catch (Throwable t) {
            log.fatal("[SimpleAxisServer] Shutting down. Error starting SimpleAxisServer", t);
            System.err.println("[SimpleAxisServer] Shutting down. Error starting SimpleAxisServer");
        }

        System.out.println("Hello World");
    }
}