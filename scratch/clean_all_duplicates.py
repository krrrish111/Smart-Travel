import os
import glob

# Find all Java and Class files matching the old naming convention
files = glob.glob('src/main/java/**/*.java', recursive=True) + glob.glob('**/*.class', recursive=True)

to_delete = [
    f for f in files if "BookingDetailsServlet" in f
]

for file in to_delete:
    try:
        os.remove(file)
        print(f"Deleted: {file}")
    except Exception as e:
        print(f"Failed to delete {file}: {e}")

print("Cleanup of duplicates complete.")
