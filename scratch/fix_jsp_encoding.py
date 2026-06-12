import os
import glob

jsps = glob.glob('src/main/webapp/**/*.jsp', recursive=True)

encoding_line = '<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>\n'
meta_line = '<meta charset="UTF-8">\n'

for jsp in jsps:
    with open(jsp, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    modified = False
    
    if '<%@ page' not in content[:200]:
        content = encoding_line + content
        modified = True
    elif 'pageEncoding="UTF-8"' not in content[:200]:
        # Simple string replacement if possible, or just prepend
        content = encoding_line + content
        modified = True
        
    if '<head>' in content and '<meta charset=' not in content:
        content = content.replace('<head>', '<head>\n    ' + meta_line)
        modified = True
        
    if modified:
        with open(jsp, 'w', encoding='utf-8') as f:
            f.write(content)
        
print(f"Processed {len(jsps)} JSPs for encoding.")
