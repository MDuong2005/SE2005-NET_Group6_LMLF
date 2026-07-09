package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Curriculum {
    private Long curriculumId;
    private Long majorId;
    private String curriculumCode;
    private String name;
    private boolean isActive = false;
    private String description;
    private String decisionNo;
    private Date issuedDate;
    private Integer totalCredits;
    private String version;
    private Integer totalSemesters;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Long updatedBy;
    private Timestamp deletedAt;
    
    private List<CurriculumCourse> courses = new ArrayList<>();
    private List<CurriculumPO> pos = new ArrayList<>();
    private List<CurriculumPLO> plos = new ArrayList<>();
    private List<CurriculumPloPoMapping> mappings = new ArrayList<>();
    private Major major;

    public Curriculum() {}

    public Curriculum(Long majorId, String version, Integer totalSemesters) {
        this.majorId = majorId;
        this.version = version;
        this.totalSemesters = totalSemesters;
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
        this.isActive = false;
    }

    // Getters and Setters
    public Long getCurriculumId() { return curriculumId; }
    public void setCurriculumId(Long curriculumId) { this.curriculumId = curriculumId; }
    
    public Long getMajorId() { return majorId; }
    public void setMajorId(Long majorId) { this.majorId = majorId; }
    
    public String getCurriculumCode() { return curriculumCode; }
    public void setCurriculumCode(String curriculumCode) { this.curriculumCode = curriculumCode; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public boolean getIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getDecisionNo() { return decisionNo; }
    public void setDecisionNo(String decisionNo) { this.decisionNo = decisionNo; }
    
    public Date getIssuedDate() { return issuedDate; }
    public void setIssuedDate(Date issuedDate) { this.issuedDate = issuedDate; }
    
    public Integer getTotalCredits() { return totalCredits; }
    public void setTotalCredits(Integer totalCredits) { this.totalCredits = totalCredits; }
    
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    
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
    
    public List<CurriculumPO> getPos() { return pos; }
    public void setPos(List<CurriculumPO> pos) { this.pos = pos; }
    
    public List<CurriculumPLO> getPlos() { return plos; }
    public void setPlos(List<CurriculumPLO> plos) { this.plos = plos; }
    
    public List<CurriculumPloPoMapping> getMappings() { return mappings; }
    public void setMappings(List<CurriculumPloPoMapping> mappings) { this.mappings = mappings; }
    
    public Major getMajor() { return major; }
    public void setMajor(Major major) { this.major = major; }
    
    public boolean isDeleted() {
        return deletedAt != null;
    }
}