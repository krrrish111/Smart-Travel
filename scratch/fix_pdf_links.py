import os
import re

d = r'c:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\transport'
types = ['train', 'bus', 'cab', 'car', 'cruise', 'helicopter']

for t in types:
    path = os.path.join(d, f'{t}-confirmation.jsp')
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            code = f.read()
        
        # Replace the direct JSP link with the servlet link that supports print=true and bookingRef
        old_str = f'/pages/transport/{t}-ticket.jsp'
        new_str = f'/transport/{t}/confirmation?print=true&bookingRef=${{booking.id}}'
        
        if old_str in code:
            code = code.replace(old_str, new_str)
            with open(path, 'w', encoding='utf-8') as f:
                f.write(code)
            print(f"Updated {t}-confirmation.jsp")
        else:
            print(f"Link not found in {t}-confirmation.jsp")
