import os

input_file = r'src\main\webapp\admin\index.jsp'
admin_dir = r'src\main\webapp\admin'

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Extract Users HTML
start_users = content.find('<!-- Manage Users Section -->')
end_users = content.find('<!-- Manage Bookings Section -->')
if start_users != -1 and end_users != -1:
    users_html = content[start_users:end_users].strip()
    with open(os.path.join(admin_dir, 'users.jsp'), 'w', encoding='utf-8') as f:
        f.write(users_html + '\n')
    content = content.replace(users_html, '<jsp:include page="users.jsp" />')

# 2. Extract Bookings HTML
start_bookings = content.find('<!-- Manage Bookings Section -->')
end_bookings = content.find('<!-- Activity Log Section -->')
if start_bookings != -1 and end_bookings != -1:
    bookings_html = content[start_bookings:end_bookings].strip()
    with open(os.path.join(admin_dir, 'bookings.jsp'), 'w', encoding='utf-8') as f:
        f.write(bookings_html + '\n')
    content = content.replace(bookings_html, '<jsp:include page="bookings.jsp" />')

with open(input_file, 'w', encoding='utf-8') as f:
    f.write(content)

print("Users and Bookings HTML extracted.")
