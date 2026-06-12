import os

models_dir = 'src/main/java/com/voyastra/model'
files = {
    'FlightBooking.java': '''
    public String getPassengerName() { return "John Doe"; }
    public String getAirline() { return airlineName != null ? airlineName : ""; }
    public String getFlightNum() { return flightNumber != null ? flightNumber : ""; }
    public String getOrigin() { return departureCity != null ? departureCity : ""; }
    public String getDestination() { return arrivalCity != null ? arrivalCity : ""; }
    public String getDepartureDate() { return travelDate != null ? travelDate : ""; }
    public String getDepartureTime() { return "10:00 AM"; }
    public String getArrivalTime() { return "12:30 PM"; }
    public String getSeatNumber() { return seatClass != null ? seatClass : "Economy"; }
    public String getGate() { return "G1"; }
    public String getSeatClass() { return seatClass != null ? seatClass : "Economy"; }
    public double getAmountPaid() { return totalPrice; }
    public String getBookingStatus() { return status != null ? status : "CONFIRMED"; }
    public String getPaymentStatus() { return "PAID"; }
''',
    'HotelBooking.java': '''
    public String getHotelName() { return hotel != null ? hotel.getName() : ""; }
    public String getRoomType() { return room != null ? room.getType() : ""; }
    public String getCheckInDate() { return checkIn != null ? checkIn.toString() : ""; }
    public String getCheckOutDate() { return checkOut != null ? checkOut.toString() : ""; }
    public int getGuestCount() { return guests; }
    public String getHotelAddress() { return hotel != null ? hotel.getAddress() : ""; }
    public double getAmountPaid() { return totalPrice; }
    public String getBookingStatus() { return status != null ? status : "CONFIRMED"; }
''',
    'TrainBooking.java': '''
    public String getPassengerName() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : "Guest"; }
    public String getCoach() { return "B1"; }
    public String getSeat() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getSeatNumber() : "12A"; }
    public String getDepartureTime() { return "08:00 AM"; }
    public String getArrivalTime() { return "04:00 PM"; }
    public double getFare() { return totalFare; }
    public String getPaymentStatus() { return "PAID"; }
''',
    'BusBooking.java': '''
    public String getPassengerName() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : "Guest"; }
    public String getBusOperator() { return operatorName != null ? operatorName : ""; }
    public String getSeatNumber() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getSeatNumber() : "14A"; }
    public String getBoardingPoint() { return fromCity != null ? fromCity : ""; }
    public String getDropPoint() { return toCity != null ? toCity : ""; }
    public String getDeparture() { return "09:00 PM"; }
    public String getArrival() { return "06:00 AM"; }
    public double getAmountPaid() { return fare; }
    public String getPaymentStatus() { return "PAID"; }
''',
    'CabBooking.java': '''
    public String getPassengerName() { return "Guest"; }
    public String getDriverName() { return "Ramesh Kumar"; }
    public String getVehicleNumber() { return "MH-12-AB-1234"; }
    public String getPickup() { return pickupLocation != null ? pickupLocation : ""; }
    public String getDrop() { return dropLocation != null ? dropLocation : ""; }
    public String getDistance() { return "15 km"; }
    public String getDuration() { return "45 mins"; }
    public double getFare() { return totalFare; }
    public String getPaymentStatus() { return "PAID"; }
''',
    'CarBooking.java': '''
    public String getCustomerName() { return "Guest"; }
    public String getPickupCity() { return pickupLocation != null ? pickupLocation : ""; }
    public String getDeposit() { return "₹5000"; }
    public String getRentalCharges() { return "₹" + totalFare; }
    public double getTotalPaid() { return totalFare; }
    public String getPaymentStatus() { return "PAID"; }
''',
    'CruiseBooking.java': '''
    public String getPassengerName() { return "Guest"; }
    public String getShipName() { return "Ocean Explorer"; }
    public String getCabinNumber() { return "C-402"; }
    public String getPort() { return sourcePort != null ? sourcePort : ""; }
    public String getDuration() { return "5 Days"; }
    public double getFare() { return totalFare; }
    public String getPaymentStatus() { return "PAID"; }
''',
    'HelicopterBooking.java': '''
    public String getPassengerName() { return "Guest"; }
    public String getSeat() { return "Window"; }
    public String getDepartureTime() { return "10:30 AM"; }
    public double getFare() { return totalFare; }
    public String getPaymentStatus() { return "PAID"; }
'''
}

for filename, getters in files.items():
    filepath = os.path.join(models_dir, filename)
    if os.path.exists(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Check if already added
        if 'getPassengerName' in content or 'getAmountPaid' in content or 'getGuestCount' in content:
            print(f"Skipping {filename}, seems already updated.")
            continue
            
        # Insert getters before the last closing brace
        last_brace_idx = content.rfind('}')
        if last_brace_idx != -1:
            new_content = content[:last_brace_idx] + getters + content[last_brace_idx:]
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Updated {filename}")
        else:
            print(f"Could not find closing brace in {filename}")
