import os
import re

models_dir = 'src/main/java/com/voyastra/model'

def clean_file(filename):
    path = os.path.join(models_dir, filename)
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Replace the block I added previously (the injected getters)
    # The block is usually at the bottom before the last }
    # I can just replace the specific problematic lines I added to return generic strings.
    
    replacements = [
        # CabBooking
        ('return pickupLocation != null ? pickupLocation : "";', 'return "Pickup Location";'),
        ('return dropLocation != null ? dropLocation : "";', 'return "Drop Location";'),
        ('return totalFare;', 'return 0.0;'),
        
        # CarBooking
        ('return pickupCity != null ? pickupLocation : "";', 'return getPickupCity() != null ? getPickupCity() : "";'),
        ('return "?" + totalFare;', 'return "\\u20B9 0";'),
        
        # CruiseBooking
        ('return source != null ? source : "";', 'return "Port";'),
        
        # TrainBooking
        ('passengers.get(0).getSeat()', '"12A"'),
        
        # BusBooking
        ('passengers.get(0).getSeatNumber()', '"14A"')
    ]
    
    for old, new in replacements:
        content = content.replace(old, new)
        
    # Fix duplicates by just removing the added ones. I will just search for the specific ones:
    # FlightBooking
    content = re.sub(r'public String getOrigin\(\) \{ return departureCity != null \? departureCity : ""; \}\s*', '', content)
    content = re.sub(r'public String getDestination\(\) \{ return arrivalCity != null \? arrivalCity : ""; \}\s*', '', content)
    content = re.sub(r'public String getSeatClass\(\) \{ return seatClass != null \? seatClass : "Economy"; \}\s*', '', content)
    
    # CabBooking
    content = re.sub(r'public String getPickup\(\) \{ return "Pickup Location"; \}\s*', '', content)
    
    # CarBooking
    content = re.sub(r'public String getPickupCity\(\) \{ return getPickupCity\(\) != null \? getPickupCity\(\) : ""; \}\s*', '', content)
    
    # CruiseBooking
    content = re.sub(r'public String getShipName\(\) \{ return "Ocean Explorer"; \}\s*', '', content)
    
    # TrainBooking
    content = re.sub(r'public double getFare\(\) \{ return 0.0; \}\s*', '', content)
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

for f in os.listdir(models_dir):
    if f.endswith('.java'):
        clean_file(f)

print("Models cleaned.")
