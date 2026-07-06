import java.net.*;
import java.net.http.*;
import java.time.Duration;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FetchHtml {
    public static void main(String[] args) throws Exception {
        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
        HttpClient client = HttpClient.newBuilder().cookieHandler(cookieManager).followRedirects(HttpClient.Redirect.ALWAYS).build();
        
        String loginBody = "{\"email\":\"krishagrawal138@gmail.com\",\"password\":\"Admin@123\",\"redirect\":\"\"}";
        HttpRequest loginReq = HttpRequest.newBuilder().uri(URI.create("https://voyastra.onrender.com/login")).header("Content-Type", "application/json").POST(HttpRequest.BodyPublishers.ofString(loginBody)).build();
        client.send(loginReq, HttpResponse.BodyHandlers.ofString());
        
        HttpRequest upcomingReq = HttpRequest.newBuilder().uri(URI.create("https://voyastra.onrender.com/my-journey?tab=upcoming")).GET().build();
        HttpResponse<String> upcomingResp = client.send(upcomingReq, HttpResponse.BodyHandlers.ofString());
        
        Files.write(Paths.get("scratch/upcoming_test.html"), upcomingResp.body().getBytes());
        System.out.println("Done fetching.");
    }
}
