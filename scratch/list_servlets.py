import os
import glob
servlets = glob.glob('src/main/java/com/voyastra/servlet/**/*DetailsServlet.java', recursive=True)
for s in servlets:
    with open(s, 'r', encoding='utf-8') as f:
        content = f.read()
        jsp = ''
        for line in content.split('\n'):
            if 'getRequestDispatcher' in line and '.jsp' in line:
                jsp = line.split('"')[1]
        print(f'{os.path.basename(s)} -> {jsp}')
