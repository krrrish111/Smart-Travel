const http = require('http');
const fs = require('fs');
const path = require('path');

const baseDir = path.join(__dirname, 'src', 'main', 'webapp');

const server = http.createServer((req, res) => {
    let url = req.url === '/' ? '/index.jsp' : req.url;
    url = url.split('?')[0]; // Remove query params
    
    let filePath = path.join(baseDir, url);
    let extname = path.extname(filePath);

    if (!fs.existsSync(filePath)) {
        res.writeHead(404);
        res.end('Not Found');
        return;
    }

    if (extname === '.jsp') {
        let content = fs.readFileSync(filePath, 'utf8');
        
        function resolveJSP(text) {
            // Strip JSP comments first so we don't process includes inside them
            text = text.replace(/<%--[\s\S]*?--%>/g, '');
            // Process includes recursively
            return text.replace(/<%@\s*include\s+file="([^"]+)"\s*%>/g, (match, p1) => {
                let includePath = path.join(baseDir, p1);
                if (fs.existsSync(includePath)) {
                    return resolveJSP(fs.readFileSync(includePath, 'utf8'));
                }
                return `<!-- Error including ${p1} -->`;
            });
        }

        content = resolveJSP(content);

        // Strip page encoding directives
        content = content.replace(/<%@\s*page\s+[^%]*%>/g, '');

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
    console.log('Server running at http://localhost:3000/');
});
