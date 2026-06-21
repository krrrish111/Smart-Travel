const fs = require('fs');
const code = fs.readFileSync('c:/Users/Dell/Desktop/antigravity/src/main/webapp/pages/experiences.jsp', 'utf8').split('\n');

for (let i = 0; i < code.length; i++) {
    const line = code[i];
    if (line.includes('<c:if')) {
        let inDouble = false;
        let inSingle = false;
        
        for (let j = 0; j < line.length; j++) {
            const char = line[j];
            
            if (char === '"' && !inSingle) {
                inDouble = !inDouble;
            } else if (char === "'" && !inDouble) {
                inSingle = !inSingle;
            }
        }
        
        if (inDouble || inSingle) {
            console.log("UNBALANCED QUOTES on line " + (i + 1) + ": " + line.trim());
        }
    }
}
