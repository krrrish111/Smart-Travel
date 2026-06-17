const fs = require('fs');
const vm = require('vm');
const path = require('path');

const jspPath = path.join(__dirname, '..', 'src', 'main', 'webapp', 'pages', 'planner.jsp');
const jsp = fs.readFileSync(jspPath, 'utf8');

// Find all script tags
const scriptRegex = /<script\b[^>]*>([\s\S]*?)<\/script>/gi;
let match;
let count = 0;
while ((match = scriptRegex.exec(jsp)) !== null) {
    count++;
    let code = match[1];
    
    // Replace EL expressions like \${...} and ${...}
    // We replace them with simple dummy variables or strings depending on context
    code = code.replace(/\$\{pageContext\.request\.contextPath\}/g, '/voyastra');
    code = code.replace(/\$\{error\}/g, 'some_error');
    code = code.replace(/\$\{sessionScope\.user_name\}/g, 'some_user');
    code = code.replace(/\$\{itineraryJson\}/g, '{}');
    code = code.replace(/\\\$\{/g, '${'); // Unescape escaped EL for JS template literals
    
    try {
        new vm.Script(code);
        console.log(`Script ${count} parsed successfully.`);
    } catch (e) {
        console.error(`Error in script ${count}:`, e.message);
        console.error(e.stack);
    }
}
