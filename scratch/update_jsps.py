import os
import glob

base_dir = r"C:\Users\Dell\Desktop\antigravity\src\main\webapp\pages\transport"
files = glob.glob(os.path.join(base_dir, "*.jsp"))

replacements = {
    "currentTrainBooking": "booking",
    "currentBusBooking": "booking",
    "currentCabBooking": "booking",
    "currentCarBooking": "booking",
    "currentCruiseBooking": "booking",
    "currentHelicopterBooking": "booking"
}

for filepath in files:
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    original = content
    for old, new in replacements.items():
        content = content.replace(old, new)
        
    if content != original:
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Updated {os.path.basename(filepath)}")

# Also we need to add the autoPrint and autoDownload JS scripts to all ticket and details JSPs if requested.
# But wait, autoPrint and autoDownload are only on Ticket JSPs.
print("Done updating JSPs.")
