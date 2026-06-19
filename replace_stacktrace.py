import os
import re

servlet_dir = r'c:\Users\Dell\Desktop\antigravity\src\main\java\com\voyastra\servlet'

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'e.printStackTrace()' not in content:
        return False

    # Check for logger import
    if 'import java.util.logging.Logger;' not in content:
        content = re.sub(r'(import .*?;)\n', r'\1\nimport java.util.logging.Logger;\nimport java.util.logging.Level;\n', content, count=1)
    elif 'import java.util.logging.Level;' not in content:
        content = re.sub(r'(import java\.util\.logging\.Logger;)\n', r'\1\nimport java.util.logging.Level;\n', content, count=1)

    # Get class name
    class_match = re.search(r'public class (\w+)', content)
    if not class_match:
        return False
    class_name = class_match.group(1)

    # Check for logger declaration
    logger_decl = f'private static final Logger logger = Logger.getLogger({class_name}.class.getName());'
    if 'Logger logger =' not in content:
        content = re.sub(r'(public class ' + class_name + r'.*?\{)', r'\1\n    ' + logger_decl + '\n', content, count=1)

    # Replace e.printStackTrace()
    content = content.replace('e.printStackTrace();', 'logger.log(Level.SEVERE, "Exception occurred", e);')

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    return True

modified_count = 0
for root, dirs, files in os.walk(servlet_dir):
    for f in files:
        if f.endswith('.java'):
            filepath = os.path.join(root, f)
            if process_file(filepath):
                modified_count += 1
                print(f"Modified: {filepath}")

print(f"Total files modified: {modified_count}")
