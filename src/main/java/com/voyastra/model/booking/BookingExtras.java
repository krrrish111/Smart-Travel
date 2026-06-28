package com.voyastra.model.booking;

public class BookingExtras {
    private int id;
    private String draftId;
    private String mealType;       // none | veg | non-veg | jain
    private String extraBaggage;   // none | 15kg | 30kg
    private boolean priorityBoarding;
    private boolean travelInsurance;
    private double totalCost;

    public BookingExtras() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getDraftId() { return draftId; }
    public void setDraftId(String draftId) { this.draftId = draftId; }

    public String getMealType() { return mealType; }
    public void setMealType(String mealType) { this.mealType = mealType; }

    public String getExtraBaggage() { return extraBaggage; }
    public void setExtraBaggage(String extraBaggage) { this.extraBaggage = extraBaggage; }

    public boolean isPriorityBoarding() { return priorityBoarding; }
    public void setPriorityBoarding(boolean priorityBoarding) { this.priorityBoarding = priorityBoarding; }

    public boolean isTravelInsurance() { return travelInsurance; }
    public void setTravelInsurance(boolean travelInsurance) { this.travelInsurance = travelInsurance; }

    public double getTotalCost() { return totalCost; }
    public void setTotalCost(double totalCost) { this.totalCost = totalCost; }
}
