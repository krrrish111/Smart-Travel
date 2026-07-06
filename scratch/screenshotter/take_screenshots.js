const puppeteer = require('puppeteer');

(async () => {
    console.log("Launching browser...");
    const browser = await puppeteer.launch({
        headless: "new",
        defaultViewport: { width: 1280, height: 1024 }
    });
    const page = await browser.newPage();
    
    console.log("Navigating to login...");
    await page.goto('https://voyastra.onrender.com/login', { waitUntil: 'networkidle2', timeout: 90000 });
    
    console.log("Logging in...");
    await page.type('#loginEmail', 'krishagrawal138@gmail.com');
    await page.type('#loginPassword', 'Admin@123');
    await page.click('#loginBtn');
    
    console.log("Waiting for My Journey page...");
    await page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 30000 }).catch(e => console.log("Nav timeout, continuing..."));
    
    console.log("Current URL: " + page.url());
    if(!page.url().includes("my-journey")) {
        await page.goto('https://voyastra.onrender.com/my-journey', { waitUntil: 'networkidle2' });
    }
    
    console.log("Taking Overview screenshot...");
    // Wait for the Upcoming Trips widget to render
    await page.waitForSelector('.ri-download-2-line');
    await page.screenshot({ path: 'overview_tab.png', fullPage: true });
    
    console.log("Switching to Upcoming tab...");
    await page.goto('https://voyastra.onrender.com/my-journey?tab=upcoming', { waitUntil: 'networkidle2' });
    
    console.log("Taking Upcoming screenshot...");
    await page.screenshot({ path: 'upcoming_tab.png', fullPage: true });

    // Output inner HTML of the upcoming panel to prove it has Set Active
    const html = await page.evaluate(() => {
        const el = document.querySelector('.panel');
        return el ? el.innerHTML : 'No panel found';
    });
    
    const fs = require('fs');
    fs.writeFileSync('upcoming_panel.html', html);
    console.log("Saved HTML snapshot.");
    
    await browser.close();
    console.log("Screenshots saved.");
})();
