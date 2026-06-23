/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author maid8
 */
public class Syllabus {
    private long syllabusId;
    private long courseId;
    private String title;
    private String currentVersion;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Long updatedBy;
    private Timestamp deletedAt;
    private List<SyllabusVersion> versions;
    private Course course;
    
    public Syllabus() {
    }

    public Syllabus(long syllabusId, long courseId, String title, String currentVersion, String status) {
        this.syllabusId = syllabusId;
        this.courseId = courseId;
        this.title = title;
        this.currentVersion = currentVersion;
        this.status = status;
    }
    
    // Constructor với 2 tham số (dùng khi tạo mới)
    public Syllabus(Long courseId, String title) {
        this.courseId = courseId;
        this.title = title;
        this.status = "DRAFT";
        this.currentVersion = "v1.0";
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }

    public long getSyllabusId() {
        return syllabusId;
    }

    public void setSyllabusId(long syllabusId) {
        this.syllabusId = syllabusId;
    }

    public long getCourseId() {
        return courseId;
    }

    public void setCourseId(long courseId) {
        this.courseId = courseId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCurrentVersion() {
        return currentVersion;
    }

    public void setCurrentVersion(String currentVersion) {
        this.currentVersion = currentVersion;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public Long getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(Long updatedBy) { this.updatedBy = updatedBy; }
    public Timestamp getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Timestamp deletedAt) { this.deletedAt = deletedAt; }
    public List<SyllabusVersion> getVersions() { return versions; }
    public void setVersions(List<SyllabusVersion> versions) { this.versions = versions; }
    public Course getCourse() { return course; }
    public void setCourse(Course course) { this.course = course; }
    public boolean isDeleted() { return deletedAt != null; }
    
    
}
