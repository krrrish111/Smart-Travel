import os
import glob

files = glob.glob('**/FlightBookingDetailsServlet.class', recursive=True) + \
        glob.glob('**/HotelBookingDetailsServlet.class', recursive=True) + \
        glob.glob('**/TrainBookingDetailsServlet.class', recursive=True) + \
        glob.glob('**/BusBookingDetailsServlet.class', recursive=True) + \
        glob.glob('**/CabBookingDetailsServlet.class', recursive=True) + \
        glob.glob('**/CarBookingDetailsServlet.class', recursive=True) + \
        glob.glob('**/CruiseBookingDetailsServlet.class', recursive=True) + \
        glob.glob('**/HelicopterBookingDetailsServlet.class', recursive=True)

for file in files:
    try:
        os.remove(file)
        print(f"Deleted: {file}")
    except Exception as e:
        print(f"Failed to delete {file}: {e}")

print("Cleanup complete.")
