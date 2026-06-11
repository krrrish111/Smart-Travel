import os

d = r'c:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\transport'
for f in os.listdir(d):
    if f.endswith('-ticket.jsp'):
        path = os.path.join(d, f)
        with open(path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # Replace the different session attributes with 'booking'
        content = content.replace('currentTrainBooking', 'booking')
        content = content.replace('currentBusBooking', 'booking')
        content = content.replace('currentCabBooking', 'booking')
        content = content.replace('currentCarBooking', 'booking')
        content = content.replace('currentCruiseBooking', 'booking')
        content = content.replace('currentHelicopterBooking', 'booking')
        
        with open(path, 'w', encoding='utf-8') as file:
            file.write(content)
        print(f"Updated {f}")
