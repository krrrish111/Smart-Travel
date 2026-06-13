import os

bus_model = 'src/main/java/com/voyastra/model/BusBooking.java'
with open(bus_model, 'r') as f:
    model = f.read()

if 'private String email;' not in model:
    model = model.replace('private List<BusPassenger> passengers = new ArrayList<>();', 
                          'private List<BusPassenger> passengers = new ArrayList<>();\n    private String email;\n    private String phone;\n    public String getEmail() { return email; }\n    public void setEmail(String email) { this.email = email; }\n    public String getPhone() { return phone; }\n    public void setPhone(String phone) { this.phone = phone; }\n    public int getPassengerAge() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getAge() : 0; }\n    public String getPassengerGender() { return passengers != null && !passengers.isEmpty() ? passengers.get(0).getGender() : "N/A"; }')

with open(bus_model, 'w') as f:
    f.write(model)
print("BusBooking.java fixed!")
