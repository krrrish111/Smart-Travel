import os

model_dir = r"C:\Users\Dell\Desktop\antigravity\src\main\java\com\voyastra\model"

configs = {
    "FlightBooking.java": {
        "getReference()": 'getBookingCode() != null ? getBookingCode() : ""',
        "getOrigin()": 'departureCity != null ? departureCity : ""',
        "getDestination()": 'arrivalCity != null ? arrivalCity : ""',
        "getCustomerNameAlias()": 'getCustomerName() != null ? getCustomerName() : ""',
        "getAmount()": 'getTotalPrice()',
        "getTravelDateAlias()": 'getTravelDate() != null ? getTravelDate() : ""'
    },
    "HotelBooking.java": {
        "getReference()": 'getBookingCode() != null ? getBookingCode() : ""',
        "getOrigin()": 'hotel != null ? hotel.getCity() : ""',
        "getDestination()": '""',
        "getCustomerNameAlias()": 'getCustomerName() != null ? getCustomerName() : ""',
        "getAmount()": 'getTotalPrice()',
        "getTravelDateAlias()": 'getTravelDate() != null ? getTravelDate() : ""'
    },
    "TrainBooking.java": {
        "getReference()": 'id != null ? id : ""',
        "getOrigin()": 'fromStation != null ? fromStation : ""',
        "getDestination()": 'toStation != null ? toStation : ""',
        "getCustomerNameAlias()": 'passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : ""',
        "getAmount()": '0.0', # We can use fare if it has it, else 0
        "getTravelDateAlias()": 'journeyDate != null ? journeyDate : ""'
    },
    "BusBooking.java": {
        "getReference()": 'id != null ? id : ""',
        "getOrigin()": 'fromCity != null ? fromCity : ""',
        "getDestination()": 'toCity != null ? toCity : ""',
        "getCustomerNameAlias()": 'passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : ""',
        "getAmount()": 'fare * (passengers != null ? passengers.size() : 1)',
        "getTravelDateAlias()": 'journeyDate != null ? journeyDate : ""'
    },
    "CabBooking.java": {
        "getReference()": 'id != null ? id : ""',
        "getOrigin()": 'pickup != null ? pickup : ""',
        "getDestination()": 'dropoff != null ? dropoff : ""',
        "getCustomerNameAlias()": 'passenger != null ? passenger.getName() : ""',
        "getAmount()": 'amount',
        "getTravelDateAlias()": 'date != null ? date : ""'
    },
    "CarBooking.java": {
        "getReference()": 'id != null ? id : ""',
        "getOrigin()": 'pickupLocation != null ? pickupLocation : ""',
        "getDestination()": 'dropoffLocation != null ? dropoffLocation : ""',
        "getCustomerNameAlias()": 'customer != null ? customer.getName() : ""',
        "getAmount()": 'totalAmount',
        "getTravelDateAlias()": 'pickupDate != null ? pickupDate : ""'
    },
    "CruiseBooking.java": {
        "getReference()": 'id != null ? id : ""',
        "getOrigin()": 'departurePort != null ? departurePort : ""',
        "getDestination()": '""',
        "getCustomerNameAlias()": 'passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : ""',
        "getAmount()": 'totalFare',
        "getTravelDateAlias()": 'sailingDate != null ? sailingDate : ""'
    },
    "HelicopterBooking.java": {
        "getReference()": 'id != null ? id : ""',
        "getOrigin()": 'departureHelipad != null ? departureHelipad : ""',
        "getDestination()": 'arrivalHelipad != null ? arrivalHelipad : ""',
        "getCustomerNameAlias()": 'passengers != null && !passengers.isEmpty() ? passengers.get(0).getName() : ""',
        "getAmount()": 'totalFare',
        "getTravelDateAlias()": 'flightDate != null ? flightDate : ""'
    }
}

def update_model(file_name, methods_dict):
    path = os.path.join(model_dir, file_name)
    if not os.path.exists(path):
        return
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    methods = []
    for sig, impl in methods_dict.items():
        ret_type = "double" if sig == "getAmount()" else "String"
        method_str = f"    public {ret_type} {sig} {{ return {impl}; }}"
        if f"public {ret_type} {sig}" not in content:
            methods.append(method_str)

    if not methods:
        return

    idx = content.rfind("}")
    if idx != -1:
        new_content = content[:idx] + "\n" + "\n".join(methods) + "\n" + content[idx:]
        with open(path, "w", encoding="utf-8") as f:
            f.write(new_content)
        print(f"Updated {file_name}")

for fname, mapping in configs.items():
    update_model(fname, mapping)

print("Done updating models.")
