package com.voyastra.service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class GeminiService {
    
    // In production, this would be injected via properties or environment variables
    private static final String GEMINI_API_KEY = System.getenv("GEMINI_API_KEY");
    private static final String GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=";

    public String getAIResponse(String userMessage, String pageContext, java.util.Map<String, String> userContext) {
        try {
            if (GEMINI_API_KEY == null || GEMINI_API_KEY.isEmpty()) {
                // Return a mock response if no API key is provided so the UI works
                return generateMockResponse(userMessage, pageContext, userContext);
            }

            // Build the system prompt using page context and user database context
            String systemPrompt = "You are the Voyastra AI Travel Buddy. Be helpful, concise, and friendly. " +
                                  "Current Page Context: " + pageContext + ". " +
                                  "User Context: " + userContext.toString();

            String fullPrompt = systemPrompt + "\nUser Message: " + userMessage;

            String jsonBody = "{" +
                "\"contents\": [{" +
                    "\"parts\":[{\"text\": \"" + escapeJson(fullPrompt) + "\"}]" +
                "}]" +
            "}";

            HttpClient client = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_2)
                    .connectTimeout(Duration.ofSeconds(10))
                    .build();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(GEMINI_URL + GEMINI_API_KEY))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                // Parse the JSON response minimally (in real app, use Jackson or Gson)
                String body = response.body();
                int textIndex = body.indexOf("\"text\": \"");
                if (textIndex > -1) {
                    int startIndex = textIndex + 9;
                    int endIndex = body.indexOf("\"", startIndex);
                    String reply = body.substring(startIndex, endIndex);
                    return reply.replace("\\n", "\n").replace("\\\"", "\"");
                }
            }
            return "Sorry, I had trouble processing your request with my AI core.";

        } catch (Exception e) {
            e.printStackTrace();
            return "I'm having network issues at the moment. Please try again later.";
        }
    }

    private String escapeJson(String text) {
        return text.replace("\"", "\\\"").replace("\n", "\\n");
    }

    private String generateMockResponse(String msg, String context, java.util.Map<String, String> userCtx) {
        msg = msg.toLowerCase();
        if (msg.contains("destination")) {
            return "Based on your preference for budget-friendly places, I'd highly recommend exploring Hanoi, Vietnam, or Oaxaca, Mexico!";
        } else if (msg.contains("budget")) {
            return "I see you have an upcoming flight to Paris. I can suggest some great free walking tours and affordable vegetarian restaurants there.";
        } else if (msg.contains("food")) {
            return "You mentioned you like vegetarian street food. How about trying the famous falafel stands in the Marais district?";
        }
        return "I am the Voyastra AI Buddy! (Mock Mode: GEMINI_API_KEY not set). " +
               "I see you are on the " + context + " page. How can I assist you with your travels today?";
    }
}
