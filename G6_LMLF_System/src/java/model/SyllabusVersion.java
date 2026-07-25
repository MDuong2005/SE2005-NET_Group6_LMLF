package model;

import java.sql.Timestamp;
import java.util.List;

public class SyllabusVersion {
    private Long versionId;
    private Long syllabusId;
    private String versionNumber;
    private String changeType;
    private String descriptionOfChanges;
    private String status;
    private Long createdBy;
    private Long updatedBy;
    private Timestamp submittedAt;
    private Timestamp approvedAt;
    private Timestamp rejectedAt;
    private Timestamp publishedAt;
    private Timestamp archivedAt;
    private Long publishedBy;
    private List<LearningMaterial> materials;
    private List<LearningOutcome> learningOutcomes;

    // Constructor mặc định
    public SyllabusVersion() {}

    // Constructor với 4 tham số
    public SyllabusVersion(Long syllabusId, String versionNumber, String changeType, Long createdBy) {
        this.syllabusId = syllabusId;
        this.versionNumber = versionNumber;
        this.changeType = changeType;
        this.status = "DRAFT";
        this.createdBy = createdBy;
    }

    // Constructor đầy đủ (nếu cần)
    public SyllabusVersion(Long versionId, Long syllabusId, String versionNumber, String changeType, 
                           String descriptionOfChanges, String status, Long createdBy) {
        this.versionId = versionId;
        this.syllabusId = syllabusId;
        this.versionNumber = versionNumber;
        this.changeType = changeType;
        this.descriptionOfChanges = descriptionOfChanges;
        this.status = status;
        this.createdBy = createdBy;
    }

    // Getters and Setters
    public Long getVersionId() { return versionId; }
    public void setVersionId(Long versionId) { this.versionId = versionId; }
    public Long getSyllabusId() { return syllabusId; }
    public void setSyllabusId(Long syllabusId) { this.syllabusId = syllabusId; }
    public String getVersionNumber() { return versionNumber; }
    public void setVersionNumber(String versionNumber) { this.versionNumber = versionNumber; }
    public String getChangeType() { return changeType; }
    public void setChangeType(String changeType) { this.changeType = changeType; }
    public String getDescriptionOfChanges() { return descriptionOfChanges; }
    public void setDescriptionOfChanges(String descriptionOfChanges) { this.descriptionOfChanges = descriptionOfChanges; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }
    public Long getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(Long updatedBy) { this.updatedBy = updatedBy; }
    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }
    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }
    public Timestamp getRejectedAt() { return rejectedAt; }
    public void setRejectedAt(Timestamp rejectedAt) { this.rejectedAt = rejectedAt; }
    public Timestamp getPublishedAt() { return publishedAt; }
    public void setPublishedAt(Timestamp publishedAt) { this.publishedAt = publishedAt; }
    public Timestamp getArchivedAt() { return archivedAt; }
    public void setArchivedAt(Timestamp archivedAt) { this.archivedAt = archivedAt; }
    public Long getPublishedBy() { return publishedBy; }
    public void setPublishedBy(Long publishedBy) { this.publishedBy = publishedBy; }
    public List<LearningMaterial> getMaterials() { return materials; }
    public void setMaterials(List<LearningMaterial> materials) { this.materials = materials; }
    public List<LearningOutcome> getLearningOutcomes() { return learningOutcomes; }
    public void setLearningOutcomes(List<LearningOutcome> learningOutcomes) { this.learningOutcomes = learningOutcomes; }
}