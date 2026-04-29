import os
import re

input_file = r'src\main\webapp\pages\admin-dashboard.jsp'
admin_dir = r'src\main\webapp\admin'

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Extract Auth Check
auth_regex = re.compile(r'(<%[\s\S]*?HttpSession adminSession[\s\S]*?%>)')
auth_match = auth_regex.search(content)
if auth_match:
    with open(os.path.join(admin_dir, 'components', 'auth-check.jsp'), 'w', encoding='utf-8') as f:
        f.write(auth_match.group(1) + '\n')
    content = content.replace(auth_match.group(1), '<%@ include file="components/auth-check.jsp" %>')

# Extract CSS
css_regex = re.compile(r'<style>\s*/\* ADMIN LAYOUT Styles \*/[\s\S]*?</style>')
css_match = css_regex.search(content)
if css_match:
    css_content = css_match.group(0).replace('<style>', '').replace('</style>', '').strip()
    with open(os.path.join(admin_dir, 'css', 'admin.css'), 'w', encoding='utf-8') as f:
        f.write(css_content + '\n')
    content = content.replace(css_match.group(0), '<link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin.css">')

# Extract Sidebar
sidebar_regex = re.compile(r'<aside class="admin-sidebar" id="adminSidebar">[\s\S]*?</aside>')
sidebar_match = sidebar_regex.search(content)
if sidebar_match:
    with open(os.path.join(admin_dir, 'components', 'sidebar.jsp'), 'w', encoding='utf-8') as f:
        f.write(sidebar_match.group(0) + '\n')
    content = content.replace(sidebar_match.group(0), '<jsp:include page="components/sidebar.jsp" />')

# Extract Topbar
topbar_regex = re.compile(r'<div class="admin-topbar">[\s\S]*?</div>\s*</div>')
# Wait, let's just use string replace for topbar since regex with nested divs is hard.
# I will find the exact lines for topbar
topbar_start = content.find('<div class="admin-topbar">')
if topbar_start != -1:
    topbar_end = content.find('<!-- Overview Section -->')
    if topbar_end != -1:
        topbar_content = content[topbar_start:topbar_end].strip()
        with open(os.path.join(admin_dir, 'components', 'topbar.jsp'), 'w', encoding='utf-8') as f:
            f.write(topbar_content + '\n')
        content = content.replace(topbar_content, '<jsp:include page="components/topbar.jsp" />')

# Write index.jsp
# First, change include paths since we are in /admin/ now
content = content.replace('file="/components/', 'file="../components/')
content = content.replace('href="index.jsp"', 'href="../index.jsp"')

with open(os.path.join(admin_dir, 'index.jsp'), 'w', encoding='utf-8') as f:
    f.write(content)

print("Done splitting admin dashboard.")
