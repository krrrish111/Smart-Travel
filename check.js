const fs = require('fs');
const code = fs.readFileSync('c:/Users/Dell/Desktop/antigravity/src/main/webapp/pages/experiences.jsp', 'utf8').split('\n');
for (let i = 0; i < code.length; i++) {
    if (code[i].includes('<c:if')) {
        let q = 0;
        let singleQ = 0;
        for (let j = 0; j < code[i].length; j++) {
            if (code[i][j] === '"') q++;
            if (code[i][j] === "'") singleQ++;
        }
        if (q % 2 !== 0) console.log(i + 1, 'UNBALANCED DOUBLE QUOTES:', code[i].trim());
        if (singleQ % 2 !== 0) console.log(i + 1, 'UNBALANCED SINGLE QUOTES:', code[i].trim());
    }
}
