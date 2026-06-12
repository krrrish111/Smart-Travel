import os

ticket_jsps = [
    r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\transport\train-ticket.jsp",
    r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\transport\bus-ticket.jsp",
    r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\transport\cab-ticket.jsp",
    r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\transport\car-ticket.jsp",
    r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\transport\cruise-ticket.jsp",
    r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\transport\helicopter-ticket.jsp",
    r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\booking\booking-success.jsp",
    r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\booking\invoice.jsp"
]

script_to_append = """
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var isAutoPrint = '${autoPrint}';
            var isAutoDownload = '${autoDownload}';
            
            if (isAutoPrint === 'true' || isAutoPrint === true) {
                window.print();
            }
            
            if (isAutoDownload === 'true' || isAutoDownload === true) {
                // Find the main container to print. If ticket-container exists use it, else use body or main
                var element = document.querySelector('.ticket-container');
                if (!element) element = document.getElementById('printableTickets');
                if (!element) element = document.querySelector('.invoice-container');
                if (!element) element = document.body;
                
                var opt = {
                  margin:       1,
                  filename:     'Ticket_${booking.id}.pdf',
                  image:        { type: 'jpeg', quality: 0.98 },
                  html2canvas:  { scale: 2 },
                  jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
                };
                
                html2pdf().set(opt).from(element).save();
            }
        });
    </script>
"""

for filepath in ticket_jsps:
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        continue
        
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
        
    if "isAutoPrint" not in content and "isAutoDownload" not in content:
        # Insert before </body>
        idx = content.rfind("</body>")
        if idx != -1:
            new_content = content[:idx] + script_to_append + content[idx:]
            with open(filepath, "w", encoding="utf-8") as f:
                f.write(new_content)
            print(f"Updated {os.path.basename(filepath)}")

print("Done appending scripts.")
