import os

file_path = 'src/main/webapp/pages/profile.jsp'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace(r"\'", "'")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed backslashes.")
