import re
import codecs

with codecs.open('src/main/webapp/pages/planner.jsp', 'r', 'utf-8') as f:
    text = f.read()

# Replace JSP syntax like <c:out ... /> with strings so JS parses
text = re.sub(r'<c:.*?>', '""', text)
text = re.sub(r'</c:.*?>', '', text)
text = re.sub(r'<%@.*?>', '', text)

# Find all script blocks
scripts = re.findall(r'<script>(.*?)</script>', text, re.DOTALL)

with codecs.open('test.js', 'w', 'utf-8') as f:
    for s in scripts:
        f.write(s + '\n')
