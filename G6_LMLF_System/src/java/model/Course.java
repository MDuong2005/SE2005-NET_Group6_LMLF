package model;

import java.time.LocalDateTime;

public class Course {
    private Long courseId;
    private String code;
    private String name;
    private Integer credits;
    private transient LocalDateTime createdAt;
    
    public Course() {}
    
    public Course(Long courseId, String code, String name, Integer credits, LocalDateTime createdAt) {
        this.courseId = courseId;
        this.code = code;
        this.name = name;
        this.credits = credits;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public Integer getCredits() { return credits; }
    public void setCredits(Integer credits) { this.credits = credits; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}