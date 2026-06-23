package model;

import java.sql.Timestamp;
import java.util.List;

public class Curriculum {
    private Long curriculumId;
    private Long majorId;
    private String version;
    private String status; // DRAFT, ACTIVE, ARCHIVED
    private Integer totalSemesters;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Long updatedBy;
    private Timestamp deletedAt;
    private List<CurriculumCourse> courses;
    private Major major;

    public Curriculum() {}

    public Curriculum(Long majorId, String version, Integer totalSemesters) {
        this.majorId = majorId;
        this.version = version;
        this.status = "DRAFT";
        this.totalSemesters = totalSemesters;
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }

    // Getters and Setters
    public Long getCurriculumId() { return curriculumId; }
    public void setCurriculumId(Long curriculumId) { this.curriculumId = curriculumId; }
    public Long getMajorId() { return majorId; }
    public void setMajorId(Long majorId) { this.majorId = majorId; }
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getTotalSemesters() { return totalSemesters; }
    public void setTotalSemesters(Integer totalSemesters) { this.totalSemesters = totalSemesters; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public Long getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(Long updatedBy) { this.updatedBy = updatedBy; }
    public Timestamp getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Timestamp deletedAt) { this.deletedAt = deletedAt; }
    public List<CurriculumCourse> getCourses() { return courses; }
    public void setCourses(List<CurriculumCourse> courses) { this.courses = courses; }
    public Major getMajor() { return major; }
    public void setMajor(Major major) { this.major = major; }
    
    public boolean isDeleted() {
        return deletedAt != null;
    }
}