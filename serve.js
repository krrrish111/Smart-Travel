const http = require('http');
const fs = require('fs');
const path = require('path');

const baseDir = path.join(__dirname, 'src', 'main', 'webapp');

const server = http.createServer((req, res) => {
    const urlObj = new URL(req.url, `http://${req.headers.host}`);
    console.log(`${req.method} ${urlObj.pathname}`);
    
    // --- PATH MAPPINGS (for flat URL support) ---
    let url = urlObj.pathname;
    if (url === '/' || url === '/index.jsp' || url === '/home') url = '/pages/home.jsp';
    else if (url === '/login') url = '/pages/login.jsp';
    else if (url === '/admin') url = '/admin/index.jsp';
    else if (url.endsWith('.jsp') && !url.startsWith('/pages/') && !url.startsWith('/admin/') && !fs.existsSync(path.join(baseDir, url))) {
        // Fallback for root JSPs that were moved to pages/
        if (fs.existsSync(path.join(baseDir, 'pages', url))) {
            url = '/pages' + url;
        }
    }
    
    let filePath = path.join(baseDir, url);
    let extname = path.extname(filePath);

    // --- MOCK API ENDPOINTS ---
    if (url === '/admin/stats' && req.method === 'GET') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ users: 1254, bookings: 450, revenue: 85200, plans: 12, destinations: 8 }));
        return;
    }
    if (url === '/admin/logs' && req.method === 'GET') {
        const mockLogs = [
            { id: 101, user: 'Admin', action: 'LOGIN', type: 'info', details: 'Admin logged in', timestamp: Date.now() },
            { id: 102, user: 'Admin', action: 'UPDATE', type: 'warning', details: 'Updated plan #5', timestamp: Date.now() - 3600000 }
        ];
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(mockLogs));
        return;
    }
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
        res.writeHead(302, { 'Location': '/admin/index.jsp' });
        res.end();
        return;
    }

    if (!fs.existsSync(filePath)) {
        res.writeHead(404);
        res.end('Not Found');
        return;
    }

    if (fs.statSync(filePath).isDirectory()) {
        if (fs.existsSync(path.join(filePath, 'index.jsp'))) {
            res.writeHead(302, { 'Location': path.join(url, 'index.jsp').replace(/\\/g, '/') });
            res.end();
            return;
        }
        res.writeHead(403);
        res.end('Forbidden');
        return;
    }

    if (extname === '.jsp') {
        let content = fs.readFileSync(filePath, 'utf8');
        
        function resolveJSP(text, currentDir) {
            // Static include: <%@ include file="..." %>
            text = text.replace(/<%@\s*include\s+file="([^"]+)"\s*%>/g, (match, p1) => {
                let includePath = p1.startsWith('/') ? path.join(baseDir, p1) : path.join(currentDir, p1);
                if (fs.existsSync(includePath)) {
                    return resolveJSP(fs.readFileSync(includePath, 'utf8'), path.dirname(includePath));
                }
                return `<!-- Include Error: ${p1} at ${includePath} -->`;
            });
            
            // Dynamic include: <jsp:include page="..." /> - handles optional trailing spaces/slashes
            text = text.replace(/<jsp:include\s+page="([^"]+)"\s*\/?>/g, (match, p1) => {
                let includePath = p1.startsWith('/') ? path.join(baseDir, p1) : path.join(currentDir, p1);
                if (fs.existsSync(includePath)) {
                    return resolveJSP(fs.readFileSync(includePath, 'utf8'), path.dirname(includePath));
                }
                return `<!-- JSP:Include Error: ${p1} at ${includePath} -->`;
            });
            
            return text;
        }

        content = resolveJSP(content, path.dirname(filePath));

        // STRIP ALL JSP TAGS for browser viewing
        content = content.replace(/<%[\s\S]*?%>/g, '');
        content = content.replace(/\$\{.*?\}/g, (match) => {
            if (match.includes('pageContext.request.contextPath')) return '';
            if (match.includes('sessionScope.user_id')) return '1';
            if (match.includes('sessionScope.role')) return 'admin';
            if (match.includes('sessionScope.name')) return 'Admin User';
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
