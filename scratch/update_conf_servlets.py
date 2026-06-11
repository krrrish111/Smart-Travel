import os
import glob

d = r'c:\Users\Dell\Desktop\antigravity\src\main\java\com\voyastra\servlet\transport'

types = ['Train', 'Bus', 'Cab', 'Car', 'Cruise', 'Helicopter']

for t in types:
    path = os.path.join(d, f'{t}ConfirmationServlet.java')
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            code = f.read()
        
        # It looks like:
        # if ("true".equals(request.getParameter("print"))) { request.getRequestDispatcher("/pages/transport/train-ticket.jsp").forward(request, response); } else { request.getRequestDispatcher("/pages/transport/train-confirmation.jsp").forward(request, response); }
        
        # We replace the first block
        search_str = f'request.getRequestDispatcher("/pages/transport/{t.lower()}-ticket.jsp").forward(request, response);'
        replace_str = f'request.setAttribute("bookingType", "{t.upper()}"); request.getRequestDispatcher("/pages/common/TicketTemplate.jsp").forward(request, response);'
        
        if search_str in code:
            code = code.replace(search_str, replace_str)
            with open(path, 'w', encoding='utf-8') as f:
                f.write(code)
            print(f"Updated {t}ConfirmationServlet.java")
        else:
            print(f"NOT FOUND in {t}ConfirmationServlet.java")
