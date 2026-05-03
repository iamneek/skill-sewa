package com.inception.skillsewa.model;

import java.sql.Timestamp;

public class SkillModel {
    private int skillId;
    private String teacherId;
    private int categoryId;
    private String title;
    private String description;
    private double price_per_10min;
    private boolean isActive;
    private Timestamp createdAt;

    public int getSkillId() {
        return skillId;
    }

    public void setSkillId(int skillId) {
        this.skillId = skillId;
    }

    public String getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(String teacherId) {
        this.teacherId = teacherId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice_per_10min() {
        return price_per_10min;
    }

    public void setPrice_per_10min(double price_per_10min) {
        this.price_per_10min = price_per_10min;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
