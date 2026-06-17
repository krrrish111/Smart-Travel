const fs = require('fs');
const vm = require('vm');

try {
    const html = fs.readFileSync('planner_rendered.html', 'utf8');
    
    // Simple regex to extract script blocks (ignoring attributes, assuming no nested scripts)
    const scriptRegex = /<script\b[^>]*>([\s\S]*?)<\/script>/gi;
    let match;
    let index = 1;
    
    while ((match = scriptRegex.exec(html)) !== null) {
        const scriptContent = match[1];
        if (scriptContent.trim().length === 0) continue;
        
        console.log(`Checking Script Block #${index}...`);
        
        // Find line number in original HTML for this script block
        const offset = html.slice(0, match.index).split('\n').length;
        
        try {
            new vm.Script(scriptContent, { filename: `planner_rendered.html`, lineOffset: offset - 1 });
            console.log(`Script Block #${index} is syntactically VALID!`);
        } catch (err) {
            console.error(`Syntax Error in Script Block #${index} (near HTML line ${err.stack}):`);
            console.error(err.message);
            console.error(err.stack);
        }
        index++;
    }
} catch (err) {
    console.error("Failed to read/parse:", err);
}
