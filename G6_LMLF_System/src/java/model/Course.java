package model;

import java.sql.Timestamp;

public class Course {
    private long courseId;
    private String code;
    private String name;
    private int credits;
    private Timestamp createdAt;

    public Course() {
    }

    public Course(long courseId, String code, String name, int credits, Timestamp createdAt) {
        this.courseId = courseId;
        this.code = code;
        this.name = name;
        this.credits = credits;
        this.createdAt = createdAt;
    }

    public long getCourseId() {
        return courseId;
    }

    public void setCourseId(long courseId) {
        this.courseId = courseId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCredits() {
        return credits;
    }

    public void setCredits(int credits) {
        this.credits = credits;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
