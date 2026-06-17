const fs = require('fs');

async function run() {
    try {
        console.log("Logging in...");
        const loginRes = await fetch('http://localhost:8080/voyastra/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: 'admin@voyastra.com', password: 'adminpassword' })
        });
        
        const loginData = await loginRes.json();
        console.log("Login result:", loginData);
        
        const rawCookie = loginRes.headers.get('set-cookie');
        if (!rawCookie) {
            throw new Error("No cookie returned on login!");
        }
        const jsessionid = rawCookie.split(';')[0];
        console.log("Session Cookie:", jsessionid);
        
        console.log("Sending POST generatePlan request with JSON payload...");
        const planRes = await fetch('http://localhost:8080/voyastra/generatePlan', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Cookie': jsessionid
            },
            body: JSON.stringify({
                destination: 'Manali',
                origin: 'Delhi',
                budget: '40000',
                travelers: 3,
                interests: 'Adventure'
            })
        });
        
        console.log("Response Status:", planRes.status);
        const planData = await planRes.json();
        console.log("Plan result (first 500 chars):", JSON.stringify(planData).substring(0, 500) + "...");
        
        if (planData.title && planData.days && planData.days.length > 0) {
            console.log("SUCCESS: Itinerary generated and validated successfully!");
        } else {
            console.error("FAILURE: Generated itinerary structure is invalid!", planData);
        }
    } catch (err) {
        console.error("Error during integration test:", err);
    }
}

run();
