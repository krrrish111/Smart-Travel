import java.net.*;
import java.net.http.*;
import java.time.Duration;

public class VerifySetActive {
    public static void main(String[] args) throws Exception {
        CookieManager cookieManager = new CookieManager();
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL);
        HttpClient client = HttpClient.newBuilder().cookieHandler(cookieManager).followRedirects(HttpClient.Redirect.ALWAYS).build();
        
        System.out.println("Logging in...");
        String loginBody = "{\"email\":\"krishagrawal138@gmail.com\",\"password\":\"Admin@123\",\"redirect\":\"\"}";
        HttpRequest loginReq = HttpRequest.newBuilder().uri(URI.create("https://voyastra.onrender.com/login")).header("Content-Type", "application/json").POST(HttpRequest.BodyPublishers.ofString(loginBody)).build();
        client.send(loginReq, HttpResponse.BodyHandlers.ofString());
        
        int maxRetries = 30; // 5 minutes max
        for (int i = 1; i <= maxRetries; i++) {
            System.out.println("Attempt " + i + ": Checking /my-journey/set-active...");
            String postBody = "bookingId=19&bookingType=hotel";
            HttpRequest postReq = HttpRequest.newBuilder().uri(URI.create("https://voyastra.onrender.com/my-journey/set-active"))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(postBody)).build();
            
            HttpResponse<String> resp = client.send(postReq, HttpResponse.BodyHandlers.ofString());
            
            System.out.println("HTTP " + resp.statusCode());
            System.out.println("Response: " + resp.body());
            
            if (resp.statusCode() == 200) {
                System.out.println("SUCCESS! Endpoint is live and returned 200.");
                return;
            }
            if (resp.statusCode() == 405) {
                 System.out.println("Wait, 405 Method Not Allowed? But we sent POST. Something is wrong.");
                 return;
            }
            if (resp.statusCode() == 404) {
                 System.out.println("Still 404... Render has not finished deploying. Waiting 10s.");
                 Thread.sleep(10000);
            } else {
                 System.out.println("Unexpected status: " + resp.statusCode());
                 Thread.sleep(10000);
            }
        }
    }
}
