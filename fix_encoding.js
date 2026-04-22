const fs = require('fs');
const path = require('path');

const targetDir = path.join(__dirname, 'src', 'main', 'webapp');

const symbolMap = {
    'âž”': '→',
    'â€¢': '•',
    'â€”': '—',
    'â€œ': '“',
    'â€': '”', // 'â€\x9d' specifically might be right quote, but we'll try replacing 'â€' with '”' if it's loose, but let's be careful. Actually, in UTF-8, '”' is E2 80 9D (â€”). Wait, 'â€' is E2 80. 'â€”' is Em Dash. Let's just do direct string replace.
    'â‚¹': '₹',
    '&#8377;': '₹',
    '\uFEFF': '' // BOM
};

// Also let's fix â€\x9d etc if they are split. A better way: Node fs.readFileSync(file, 'utf8') will read these if the file was saved in ANSI/Windows-1252 but interpreted as UTF-8. Wait, if the file is UTF-8 but contains these literal characters because someone pasted them? Yes, that's what usually happens. We will replace the literal sequences.

function processDirectory(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
            processDirectory(fullPath);
        } else if (stat.isFile()) {
            const ext = path.extname(fullPath).toLowerCase();
            if (['.jsp', '.html', '.css', '.js'].includes(ext)) {
                processFile(fullPath, ext);
            }
        }
    }
}

function processFile(filePath, ext) {
    let content = fs.readFileSync(filePath, 'utf8');
    let originalContent = content;

    // 1. Replace symbols
    for (const [bad, good] of Object.entries(symbolMap)) {
        // use split join to replace all occurrences
        content = content.split(bad).join(good);
    }

    // Replace the specific quotes: sometimes 'â€œ' is left and 'â€\x9d' is right.
    // 'â€' might conflict with 'â€”' (dash) or 'â€¢' (bullet) if we replace it first.
    // Notice that my symbolMap has keys. We should replace longer keys first!
    // But above I just used Object.entries. Let's do it ordered by length descending.

    // 2. Add Meta Charset
    if (ext === '.jsp' || ext === '.html') {
        if (!content.includes('<meta charset="UTF-8">')) {
            content = content.replace(/<head>/i, '<head>\n    <meta charset="UTF-8">');
        }
    }

    // 3. Update Fonts
    // Replace font-family: 'Inter', sans-serif; etc.
    const fontRegex = /font-family:\s*[^;\}]+;?/gi;
    content = content.replace(fontRegex, (match) => {
        if (match.includes('monospace')) {
            return match; // keep monospace
        }
        return "font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;";
    });
    
    // Also update style="font-family: ..."
    const inlineFontRegex = /font-family:\s*[^;"\']+;?/gi;
    content = content.replace(inlineFontRegex, (match) => {
        if (match.includes('monospace')) {
            return match; // keep monospace
        }
        return "font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;";
    });

    if (content !== originalContent) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated: ${filePath}`);
    }
}

// Let's re-run symbol replacement safely
function processFileSafely(filePath, ext) {
    let content = fs.readFileSync(filePath, 'utf8');
    let originalContent = content;

    const symbols = [
        { bad: 'âž”', good: '→' },
        { bad: 'â€”', good: '—' },
        { bad: 'â€¢', good: '•' },
        { bad: 'â€œ', good: '“' },
        { bad: 'â€\x9d', good: '”' },
        { bad: 'â€', good: '”' }, // Catchall for right quote or others
        { bad: 'â‚¹', good: '₹' },
        { bad: '&#8377;', good: '₹' },
        { bad: '\uFEFF', good: '' }
    ];

    for (const {bad, good} of symbols) {
        content = content.split(bad).join(good);
    }

    if (ext === '.jsp' || ext === '.html') {
        // Try to insert after <head>
        if (!content.includes('<meta charset="UTF-8">') && !content.includes('<meta charset="utf-8">')) {
            content = content.replace(/<head>/i, '<head>\n    <meta charset="UTF-8">');
        }
    }

    const fontRegex = /font-family:\s*[^;\}"]+[;]?/gi;
    content = content.replace(fontRegex, (match) => {
        if (match.includes('monospace') || match.includes('FontAwesome')) {
            return match; 
        }
        if (match.endsWith(';')) {
             return "font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;";
        } else {
             return "font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif";
        }
    });

    if (content !== originalContent) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated: ${filePath}`);
    }
}

// Re-assign process directory to use safe one
function processDirectory2(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
            processDirectory2(fullPath);
        } else if (stat.isFile()) {
            const ext = path.extname(fullPath).toLowerCase();
            if (['.jsp', '.html', '.css', '.js'].includes(ext)) {
                processFileSafely(fullPath, ext);
            }
        }
    }
}

processDirectory2(targetDir);
console.log('Done.');
