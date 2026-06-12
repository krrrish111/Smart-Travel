import os
import re

file_path = 'src/main/webapp/pages/profile.jsp'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace div onclick with a href
replacements = [
    (r'<div class="nav-item \$\{activeTab == \'overview\' \? \'active\' : \'\'\}" onclick="switchSection\(\'overview\'\)">',
     r'<a href="${pageContext.request.contextPath}/profile?tab=overview" class="nav-item ${activeTab == \'overview\' ? \'active\' : \'\'}">'),
    
    (r'<div class="nav-item \$\{activeTab == \'edit-profile\' \? \'active\' : \'\'\}" onclick="switchSection\(\'edit-profile\'\)">',
     r'<a href="${pageContext.request.contextPath}/profile?tab=edit-profile" class="nav-item ${activeTab == \'edit-profile\' ? \'active\' : \'\'}">'),
    
    (r'<div class="nav-item \$\{activeTab == \'bookings\' \? \'active\' : \'\'\}" onclick="switchSection\(\'bookings\'\)">',
     r'<a href="${pageContext.request.contextPath}/profile?tab=bookings" class="nav-item ${activeTab == \'bookings\' ? \'active\' : \'\'}">'),
    
    (r'<div class="nav-item \$\{activeTab == \'saved-plans\' \? \'active\' : \'\'\}" onclick="switchSection\(\'saved-plans\'\)">',
     r'<a href="${pageContext.request.contextPath}/profile?tab=saved-plans" class="nav-item ${activeTab == \'saved-plans\' ? \'active\' : \'\'}">'),
    
    (r'<div class="nav-item \$\{activeTab == \'wishlist\' \? \'active\' : \'\'\}" onclick="switchSection\(\'wishlist\'\)">',
     r'<a href="${pageContext.request.contextPath}/profile?tab=wishlist" class="nav-item ${activeTab == \'wishlist\' ? \'active\' : \'\'}">'),
    
    (r'<div class="nav-item \$\{activeTab == \'security\' \? \'active\' : \'\'\}" onclick="switchSection\(\'security\'\)">',
     r'<a href="${pageContext.request.contextPath}/profile?tab=security" class="nav-item ${activeTab == \'security\' ? \'active\' : \'\'}">'),
    
    (r'<div class="nav-item \$\{activeTab == \'settings\' \? \'active\' : \'\'\}" onclick="switchSection\(\'settings\'\)">',
     r'<a href="${pageContext.request.contextPath}/profile?tab=settings" class="nav-item ${activeTab == \'settings\' ? \'active\' : \'\'}">'),
    
    # Close the div to a
    (r'            Overview\s*</div>', r'            Overview\n        </a>'),
    (r'            Edit Profile\s*</div>', r'            Edit Profile\n        </a>'),
    (r'            My Bookings\s*</div>', r'            My Bookings\n        </a>'),
    (r'            Saved Plans\s*</div>', r'            Saved Plans\n        </a>'),
    (r'            Wishlist & History\s*</div>', r'            Wishlist & History\n        </a>'),
    (r'            Security\s*</div>', r'            Security\n        </a>'),
    (r'            Settings\s*</div>', r'            Settings\n        </a>'),
]

for old, new in replacements:
    content = re.sub(old, new, content)

# Change the edit profile button in the header
content = content.replace(
    '''<button class="btn btn-primary" style="margin-top: 15px;" onclick="switchSection('edit-profile')">Edit Account Details</button>''',
    '''<a href="${pageContext.request.contextPath}/profile?tab=edit-profile" class="btn btn-primary" style="margin-top: 15px; display:inline-block;">Edit Account Details</a>'''
)

# Change the view all bookings button in overview
content = content.replace(
    '''<button class="btn btn-outline" style="margin-top: 20px; width: 100%;" onclick="switchSection('bookings')">View All Bookings</button>''',
    '''<a href="${pageContext.request.contextPath}/profile?tab=bookings" class="btn btn-outline" style="margin-top: 20px; width: 100%; display:block; text-align:center;">View All Bookings</a>'''
)

# Remove the switchSection function
content = re.sub(r'function switchSection.*?}\s*}\s*}', '', content, flags=re.DOTALL)
# Actually, the regex above might be flaky, let's just use string replacement or simpler regex
switch_section_func = re.search(r'function switchSection\(sectionId\) \{.*?\n    \}', content, re.DOTALL)
if switch_section_func:
    content = content.replace(switch_section_func.group(0), '')

# Add z-index to sidebar and position relative
content = content.replace(
    '''.profile-sidebar {
        background: var(--surface-glass);''',
    '''.profile-sidebar {
        z-index: 10; position: relative;
        background: var(--surface-glass);'''
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Profile links updated.")
