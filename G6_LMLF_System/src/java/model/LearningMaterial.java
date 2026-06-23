package model;

import java.sql.Timestamp;

public class LearningMaterial {
    private Long materialId;
    private Long versionId;
    private Long uploadedBy;
    private String materialType; // SLIDE, DOCUMENT, VIDEO, REFERENCE, OTHER
    private String title;
    private String fileUrl;
    private Long fileSize;
    private String accessLevel; // PUBLIC, STUDENTS_ONLY, LECTURERS_ONLY
    private Timestamp uploadedAt;
    private Timestamp deletedAt;

    public LearningMaterial() {}

    public LearningMaterial(Long versionId, Long uploadedBy, String materialType, String title, String fileUrl) {
        this.versionId = versionId;
        this.uploadedBy = uploadedBy;
        this.materialType = materialType;
        this.title = title;
        this.fileUrl = fileUrl;
        this.accessLevel = "PUBLIC";
        this.uploadedAt = new Timestamp(System.currentTimeMillis());
    }

    // Getters and Setters
    public Long getMaterialId() { return materialId; }
    public void setMaterialId(Long materialId) { this.materialId = materialId; }
    public Long getVersionId() { return versionId; }
    public void setVersionId(Long versionId) { this.versionId = versionId; }
    public Long getUploadedBy() { return uploadedBy; }
    public void setUploadedBy(Long uploadedBy) { this.uploadedBy = uploadedBy; }
    public String getMaterialType() { return materialType; }
    public void setMaterialType(String materialType) { this.materialType = materialType; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getFileUrl() { return fileUrl; }
    public void setFileUrl(String fileUrl) { this.fileUrl = fileUrl; }
    public Long getFileSize() { return fileSize; }
    public void setFileSize(Long fileSize) { this.fileSize = fileSize; }
    public String getAccessLevel() { return accessLevel; }
    public void setAccessLevel(String accessLevel) { this.accessLevel = accessLevel; }
    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
    public Timestamp getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Timestamp deletedAt) { this.deletedAt = deletedAt; }
}