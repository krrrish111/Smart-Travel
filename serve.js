const http = require('http');
const fs = require('fs');
const path = require('path');

const baseDir = path.join(__dirname, 'src', 'main', 'webapp');

const server = http.createServer((req, res) => {
    const urlObj = new URL(req.url, `http://${req.headers.host}`);
    let url = urlObj.pathname === '/' ? '/index.jsp' : urlObj.pathname;
    let filePath = path.join(baseDir, url);
    let extname = path.extname(filePath);

    console.log(`${req.method} ${url}`);

    // --- MOCK API ENDPOINTS ---
    if (url === '/review' && req.method === 'GET') {
        const action = urlObj.searchParams.get('action');
        if (action === 'list') {
            const mockReviews = [
                { id: 201, userName: "Sarah Connor", location: "Los Angeles", rating: 5, comment: "Excellent planning tools. Made my trip so much easier!", createdAt: "2026-04-05 12:00:00", approved: true },
                { id: 101, userName: "Alice Smith", location: "Pangong Lake", rating: 5, comment: "Absolutely breathtaking views! Highly recommend visiting at sunrise.", createdAt: "2026-04-01 10:00:00", approved: true },
                { id: 102, userName: "Bob Jones", location: "Munnar", rating: 2, comment: "Beautiful tea gardens, but a bit crowded during peak hours.", createdAt: "2026-04-02 14:30:00", approved: true },
                { id: 103, userName: "Charlie Brown", location: "Malvan", rating: 3, comment: "Scuba was okay, but visibility could have been better.", createdAt: "2026-04-03 09:15:00", approved: true },
                { id: 104, userName: "Diana Prince", location: "Goa", rating: 4, comment: "The hidden gems are the best part of Voyastra!", createdAt: "2026-04-04 18:20:00", approved: true }
            ];
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(mockReviews));
            return;
        }
    }

    if (url === '/login' && req.method === 'POST') {
        res.writeHead(302, { 'Location': '/admin-dashboard.jsp' });
        res.end();
        return;
    }

    if (!fs.existsSync(filePath)) {
        res.writeHead(404);
        res.end('Not Found');
        return;
    }

    if (extname === '.jsp') {
        let content = fs.readFileSync(filePath, 'utf8');
        
        function resolveJSP(text) {
            // Include logic
            text = text.replace(/<%@\s*include\s+file="([^"]+)"\s*%>/g, (match, p1) => {
                let includePath = path.join(baseDir, p1);
                if (fs.existsSync(includePath)) {
                    return resolveJSP(fs.readFileSync(includePath, 'utf8'));
                }
                return `<!-- Include Error: ${p1} -->`;
            });
            return text;
        }

        content = resolveJSP(content);

        // STRIP ALL JSP TAGS for browser viewing
        content = content.replace(/<%[\s\S]*?%>/g, '');
        content = content.replace(/\$\{.*?\}/g, (match) => {
            if (match.includes('pageContext.request.contextPath')) return '';
            return 'MOCK_VALUE';
        });

        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(content);
    } else {
        let contentType = 'text/plain';
        if (extname === '.css') contentType = 'text/css';
        else if (extname === '.js') contentType = 'application/javascript';
        else if (extname === '.png') contentType = 'image/png';
        else if (extname === '.jpg') contentType = 'image/jpeg';
        else if (extname === '.svg') contentType = 'image/svg+xml';
        
        res.writeHead(200, { 'Content-Type': contentType });
        const readStream = fs.createReadStream(filePath);
        readStream.pipe(res);
    }
});

server.listen(3000, () => {
    console.log('Mock Server running at http://localhost:3000/');
});
