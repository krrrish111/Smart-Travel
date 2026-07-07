const fs = require('fs');
const path = require('path');

function walk(dir, done) {
  let results = [];
  fs.readdir(dir, function(err, list) {
    if (err) return done(err);
    let pending = list.length;
    if (!pending) return done(null, results);
    list.forEach(function(file) {
      file = path.resolve(dir, file);
      fs.stat(file, function(err, stat) {
        if (stat && stat.isDirectory()) {
          walk(file, function(err, res) {
            results = results.concat(res);
            if (!--pending) done(null, results);
          });
        } else {
          results.push(file);
          if (!--pending) done(null, results);
        }
      });
    });
  });
}

walk('src/main/java', (err, files) => {
  if (err) throw err;
  
  files.forEach(file => {
    if (!file.endsWith('.java')) return;
    const content = fs.readFileSync(file, 'utf8');
    const lines = content.split('\n');
    
    lines.forEach((line, index) => {
      if (line.includes('DBConnection.getConnection()') && !line.includes('try (')) {
        // Check if there is a 'try' on the same/previous line, or if 'conn' is closed in finally
        const hasFinally = content.includes('finally') && (content.includes('conn.close()') || content.includes('.close()'));
        if (!hasFinally) {
          console.log(`POTENTIAL LEAK: ${file}:${index + 1}`);
          console.log(`  > ${line.trim()}`);
        }
      }
    });
  });
});
