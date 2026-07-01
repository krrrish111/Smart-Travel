package com.voyastra.util;

public class ImageUtil {
    
    public static String resolveHotelImageUrl(String path, int id, String name) {
        if (path == null || path.trim().isEmpty() || path.contains("default-hotel")) {
            return getHotelFallback(id, name);
        }
        String clean = path.trim();
        if (clean.startsWith("/")) {
            clean = clean.substring(1);
        }
        if (clean.equals("images/hotel1.jpg") || clean.equals("images/hotel2.jpg")) {
            return "/voyastra/assets/" + clean;
        }
        if (clean.startsWith("images/")) {
            return getHotelFallback(id, name);
        }
        return path;
    }

    public static String resolveRoomImageUrl(String path, int id) {
        if (path == null || path.trim().isEmpty() || path.contains("default-room") || path.startsWith("images/room") || path.startsWith("/images/room")) {
            return getRoomFallback(id);
        }
        return path;
    }

    public static String resolveDestinationImageUrl(String path, int id) {
        if (path == null || path.trim().isEmpty() || path.startsWith("images/") || path.startsWith("/images/") || path.contains("hotel1")) {
            return getDestinationFallback(id);
        }
        return path;
    }

    public static String resolveExperienceImageUrl(String path, int id) {
        if (path == null || path.trim().isEmpty() || path.startsWith("images/") || path.startsWith("/images/") || path.contains("hotel1")) {
            return getExperienceFallback(id);
        }
        return path;
    }

    public static String resolveExperienceImageUrl(String path, String id) {
        int numericId = 0;
        if (id != null) {
            try {
                numericId = Integer.parseInt(id);
            } catch (NumberFormatException e) {
                numericId = id.hashCode();
            }
        }
        return resolveExperienceImageUrl(path, numericId);
    }

    public static String resolvePostImageUrl(String path, int id) {
        if (path == null || path.trim().isEmpty() || path.startsWith("images/") || path.startsWith("/images/") || path.contains("hotel1")) {
            return getCommunityFallback(id);
        }
        return path;
    }

    public static String resolveProfileImageUrl(String path, String firstName) {
        if (path == null || path.trim().isEmpty() || path.startsWith("/images/") || path.startsWith("images/")) {
            String name = (firstName != null ? firstName : "User");
            return "https://ui-avatars.com/api/?name=" + name.replace(" ", "+") + "&background=random&color=fff";
        }
        return path;
    }

    private static String getHotelFallback(int id, String name) {
        int hash = (id > 0) ? id : (name != null ? name.hashCode() : 0);
        hash = Math.abs(hash);
        String[] fallbacks = {
            "https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1551882547-ff40c0d5f8af?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1496417263034-38ec4f0b665a?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1542314831-c6a4d27ece50?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1584132967334-10e028bd69f7?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1529290130-4ca3753253ae?auto=format&fit=crop&w=500&q=80"
        };
        return fallbacks[hash % fallbacks.length];
    }

    private static String getRoomFallback(int id) {
        String[] fallbacks = {
            "https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=500&q=80"
        };
        return fallbacks[Math.abs(id) % fallbacks.length];
    }

    private static String getDestinationFallback(int id) {
        String[] fallbacks = {
            "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1506929562872-bb421503ef21?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1499856871958-5b9627545d1a?auto=format&fit=crop&w=500&q=80"
        };
        return fallbacks[Math.abs(id) % fallbacks.length];
    }

    private static String getExperienceFallback(int id) {
        String[] fallbacks = {
            "https://images.unsplash.com/photo-1533240332313-0cb49f47a9dd?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1504609774591-9dfc82075677?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1518182170546-076616fd4675?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=500&q=80"
        };
        return fallbacks[Math.abs(id) % fallbacks.length];
    }

    private static String getCommunityFallback(int id) {
        String[] fallbacks = {
            "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=500&q=80",
            "https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=500&q=80"
        };
        return fallbacks[Math.abs(id) % fallbacks.length];
    }
}
