<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.voyastra.config.ConfigManager" %>
<%-- Fallback logic for API Keys --%>
<%
    String googleMapsKey = ConfigManager.get("GOOGLE_MAPS_API_KEY");
    String googlePlacesKey = ConfigManager.get("GOOGLE_PLACES_API_KEY");
    String apiKey = (googleMapsKey != null && !googleMapsKey.trim().isEmpty()) ? googleMapsKey : googlePlacesKey;
%>
<script>
    // Maps Configuration
    var APP_CONFIG = APP_CONFIG || {
        googleMapsApiKey: "<%= apiKey %>"
    };

    window.gm_authFailure = function() {
        if (typeof showToast === 'function') {
            showToast('API key not valid. Please pass a valid API key.', 'error');
        } else {
            console.error('API key not valid. Please pass a valid API key.');
            alert('Google Maps API key not valid. Please check your configuration.');
        }
    };

    // Google's recommended inline bootstrap loader
    (g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.googleapis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})({
        key: APP_CONFIG.googleMapsApiKey,
        v: "weekly",
        loading: "async",
        libraries: "places"
    });
</script>