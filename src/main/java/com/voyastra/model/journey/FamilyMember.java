package com.voyastra.model.journey;

import java.sql.Timestamp;

public class FamilyMember {
    private int id;
    private int userId;
    private String relation;
    private String name;
    private int age;
    private int passportReadiness; // 0 to 100 percentage
    private Timestamp createdAt;

    public FamilyMember() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getRelation() { return relation; }
    public void setRelation(String relation) { this.relation = relation; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public int getPassportReadiness() { return passportReadiness; }
    public void setPassportReadiness(int passportReadiness) { this.passportReadiness = passportReadiness; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
