package com.voyastra.model;

public class Inclusion {
    private String inclusionName;
    private boolean included;

    public Inclusion() {}

    public Inclusion(String inclusionName, boolean included) {
        this.inclusionName = inclusionName;
        this.included = included;
    }

    public String getInclusionName() { return inclusionName; }
    public void setInclusionName(String inclusionName) { this.inclusionName = inclusionName; }
    public boolean isIncluded() { return included; }
    public void setIncluded(boolean included) { this.included = included; }
}
