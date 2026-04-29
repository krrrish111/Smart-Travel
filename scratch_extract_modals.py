import os
import re

input_file = r'src\main\webapp\admin\index.jsp'
admin_dir = r'src\main\webapp\admin'

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Extract from '<!-- Add/Edit Plan Modal -->' up to '<!-- Bulk Action Bar -->'
start_marker = '<!-- Add/Edit Plan Modal -->'
end_marker = '<!-- Bulk Action Bar -->'

start_idx = content.find(start_marker)
end_idx = content.find(end_marker)

if start_idx != -1 and end_idx != -1:
    modals_content = content[start_idx:end_idx].strip()
    with open(os.path.join(admin_dir, 'components', 'modals.jsp'), 'w', encoding='utf-8') as f:
        f.write(modals_content + '\n')
    
    # Replace in index.jsp
    new_content = content[:start_idx] + '<jsp:include page="components/modals.jsp" />\n\n' + content[end_idx:]
    with open(input_file, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Modals extracted successfully.")
else:
    print("Could not find modals markers.")
