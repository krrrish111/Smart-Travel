import os

details_templates = {
    "flight-details.jsp": {
        "title": "Flight Booking Details",
        "icon": "✈",
        "fields": [
            ("Passenger Name", "${booking.passengerName}"),
            ("Airline", "${booking.airline}"),
            ("Flight Number", "${booking.flightNum}"),
            ("Origin", "${booking.origin}"),
            ("Destination", "${booking.destination}"),
            ("Departure Date", "${booking.departureDate}"),
            ("Departure Time", "${booking.departureTime}"),
            ("Arrival Time", "${booking.arrivalTime}"),
            ("PNR", "${booking.pnr}"),
            ("Seat Number", "${booking.seatNumber}"),
            ("Gate", "${booking.gate}"),
            ("Class", "${booking.seatClass}"),
            ("Amount Paid", "₹${booking.amountPaid}"),
            ("Booking Status", "${booking.bookingStatus}"),
            ("Payment Status", "${booking.paymentStatus}")
        ],
        "dir": "src/main/webapp/pages/booking"
    },
    "hotel-confirmation.jsp": {
        "title": "Hotel Booking Details",
        "icon": "🏨",
        "fields": [
            ("Guest Name", "${booking.customerName}"),
            ("Hotel Name", "${booking.hotelName}"),
            ("Room Type", "${booking.roomType}"),
            ("Check In", "${booking.checkInDate}"),
            ("Check Out", "${booking.checkOutDate}"),
            ("Guests", "${booking.guestCount}"),
            ("Address", "${booking.hotelAddress}"),
            ("Booking ID", "${booking.bookingCode}"),
            ("Amount Paid", "₹${booking.amountPaid}"),
            ("Status", "${booking.bookingStatus}")
        ],
        "dir": "src/main/webapp/pages"
    },
    "train-confirmation.jsp": {
        "title": "Train Booking Details",
        "icon": "🚆",
        "fields": [
            ("Passenger Name", "${booking.passengerName}"),
            ("Train Name", "${booking.trainName}"),
            ("Train Number", "${booking.trainNumber}"),
            ("PNR", "${booking.pnr}"),
            ("Coach", "${booking.coach}"),
            ("Seat", "${booking.seat}"),
            ("Origin", "${booking.fromStation}"),
            ("Destination", "${booking.toStation}"),
            ("Departure Time", "${booking.departureTime}"),
            ("Arrival Time", "${booking.arrivalTime}"),
            ("Fare", "₹${booking.fare}")
        ],
        "dir": "src/main/webapp/pages/transport"
    },
    "bus-confirmation.jsp": {
        "title": "Bus Booking Details",
        "icon": "🚌",
        "fields": [
            ("Passenger Name", "${booking.passengerName}"),
            ("Bus Operator", "${booking.busOperator}"),
            ("Bus Type", "${booking.busType}"),
            ("Seat Number", "${booking.seatNumber}"),
            ("Boarding Point", "${booking.boardingPoint}"),
            ("Drop Point", "${booking.dropPoint}"),
            ("Departure", "${booking.departure}"),
            ("Arrival", "${booking.arrival}"),
            ("Amount Paid", "₹${booking.amountPaid}")
        ],
        "dir": "src/main/webapp/pages/transport"
    },
    "cab-confirmation.jsp": {
        "title": "Cab Booking Details",
        "icon": "🚕",
        "fields": [
            ("Passenger Name", "${booking.passengerName}"),
            ("Driver Name", "${booking.driverName}"),
            ("Vehicle Number", "${booking.vehicleNumber}"),
            ("Pickup", "${booking.pickup}"),
            ("Drop", "${booking.drop}"),
            ("Distance", "${booking.distance}"),
            ("Duration", "${booking.duration}"),
            ("Fare", "₹${booking.fare}")
        ],
        "dir": "src/main/webapp/pages/transport"
    },
    "car-confirmation.jsp": {
        "title": "Car Rental Details",
        "icon": "🚗",
        "fields": [
            ("Customer Name", "${booking.customerName}"),
            ("Vehicle Model", "${booking.vehicleModel}"),
            ("Vehicle Number", "${booking.vehicleNumber}"),
            ("Pickup City", "${booking.pickupCity}"),
            ("Pickup Date", "${booking.pickupDate}"),
            ("Return Date", "${booking.returnDate}"),
            ("Deposit", "${booking.deposit}"),
            ("Rental Charges", "${booking.rentalCharges}"),
            ("Total Paid", "₹${booking.totalPaid}")
        ],
        "dir": "src/main/webapp/pages/transport"
    },
    "cruise-confirmation.jsp": {
        "title": "Cruise Booking Details",
        "icon": "🚢",
        "fields": [
            ("Passenger Name", "${booking.passengerName}"),
            ("Cruise Name", "${booking.cruiseLine}"),
            ("Ship Name", "${booking.shipName}"),
            ("Cabin Number", "${booking.cabinNumber}"),
            ("Port", "${booking.port}"),
            ("Destination", "${booking.destinationPort}"),
            ("Duration", "${booking.duration}"),
            ("Fare", "₹${booking.fare}")
        ],
        "dir": "src/main/webapp/pages/transport"
    },
    "helicopter-confirmation.jsp": {
        "title": "Helicopter Booking Details",
        "icon": "🚁",
        "fields": [
            ("Passenger Name", "${booking.passengerName}"),
            ("Operator", "${booking.operator}"),
            ("Flight Number", "${booking.flightNumber}"),
            ("Origin", "${booking.source}"),
            ("Destination", "${booking.destination}"),
            ("Seat", "${booking.seat}"),
            ("Departure Time", "${booking.departureTime}"),
            ("Fare", "₹${booking.fare}")
        ],
        "dir": "src/main/webapp/pages/transport"
    }
}

base_template = """<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    .details-container {{
        max-width: 800px;
        margin: 60px auto;
        background: var(--surface-glass);
        backdrop-filter: blur(12px);
        border: 1px solid var(--color-border);
        border-radius: 24px;
        padding: 40px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.1);
    }}
    .details-header {{
        text-align: center;
        margin-bottom: 40px;
        border-bottom: 1px solid var(--color-border);
        padding-bottom: 20px;
    }}
    .details-icon {{
        font-size: 3rem;
        margin-bottom: 10px;
        display: inline-block;
    }}
    .details-title {{
        font-size: 2rem;
        font-weight: 800;
        color: var(--text-primary);
    }}
    .details-grid {{
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }}
    .detail-item {{
        background: rgba(255, 255, 255, 0.02);
        padding: 15px 20px;
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.05);
    }}
    .detail-label {{
        font-size: 0.85rem;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 5px;
        font-weight: 600;
    }}
    .detail-value {{
        font-size: 1.1rem;
        font-weight: 700;
        color: var(--text-primary);
    }}
    .actions {{
        margin-top: 40px;
        display: flex;
        justify-content: center;
        gap: 15px;
    }}
</style>

<div class="details-container">
    <div class="details-header">
        <div class="details-icon">{icon}</div>
        <h1 class="details-title">{title}</h1>
        <p style="color:var(--text-secondary); margin-top:10px;">Booking Reference: ${{booking.id != null ? booking.id : ''}}</p>
    </div>
    
    <div class="details-grid">
{fields_html}
    </div>
    
    <div class="actions">
        <button class="btn btn-primary" onclick="window.location.href='${{pageContext.request.contextPath}}/profile?tab=bookings'">Back to My Bookings</button>
    </div>
</div>

<%@ include file="/components/footer.jsp" %>
"""

for filename, config in details_templates.items():
    fields_html = ""
    for label, val in config["fields"]:
        fields_html += f"""        <div class="detail-item">
            <div class="detail-label">{label}</div>
            <div class="detail-value">{val}</div>
        </div>\n"""
        
    final_content = base_template.format(
        title=config["title"],
        icon=config["icon"],
        fields_html=fields_html
    )
    
    filepath = os.path.join(config["dir"], filename)
    os.makedirs(config["dir"], exist_ok=True)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(final_content)

print("Details JSPs generated successfully.")
