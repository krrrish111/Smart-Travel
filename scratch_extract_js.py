import os
import re

input_file = r'src\main\webapp\admin\index.jsp'
admin_dir = r'src\main\webapp\admin'

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Look for blocks that might relate to users
start_users_js = content.find('/* =========================================================\n   USERS SCRIPT')
if start_users_js == -1:
    start_users_js = content.find('/* USERS SCRIPT')
    
end_users_js = content.find('/* =========================================================', start_users_js + 10)

if start_users_js != -1 and end_users_js != -1:
    users_js = content[start_users_js:end_users_js].strip()
    with open(os.path.join(admin_dir, 'js', 'users.js'), 'w', encoding='utf-8') as f:
        f.write(users_js + '\n')
    content = content.replace(users_js, '')
    print("Users JS extracted.")
else:
    print("Users JS block not found.")

start_bookings_js = content.find('/* =========================================================\n   BOOKINGS SCRIPT')
end_bookings_js = content.find('/* =========================================================', start_bookings_js + 10)

if start_bookings_js != -1 and end_bookings_js != -1:
    bookings_js = content[start_bookings_js:end_bookings_js].strip()
    with open(os.path.join(admin_dir, 'js', 'bookings.js'), 'w', encoding='utf-8') as f:
        f.write(bookings_js + '\n')
    content = content.replace(bookings_js, '')
    print("Bookings JS extracted.")
else:
    print("Bookings JS block not found.")

with open(input_file, 'w', encoding='utf-8') as f:
    f.write(content)
