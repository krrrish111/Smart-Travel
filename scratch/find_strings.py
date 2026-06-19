import re
import codecs

with codecs.open('src/main/webapp/pages/planner.jsp', 'r', 'utf-8') as f:
    text = f.read()

scripts = re.findall(r'<script>(.*?)</script>', text, re.DOTALL)
for s in scripts:
    lines = s.split('\n')
    for i, line in enumerate(lines):
        in_single = False
        in_double = False
        escape = False
        for char in line:
            if escape:
                escape = False
                continue
            if char == '\\':
                escape = True
            elif char == "'" and not in_double:
                in_single = not in_single
            elif char == '"' and not in_single:
                in_double = not in_double
        if in_single or in_double:
            print(f"Unclosed string at line {i}: {line}")
