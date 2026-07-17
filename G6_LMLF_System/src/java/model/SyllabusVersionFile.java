package model;

import java.sql.Timestamp;

public class SyllabusVersionFile {
    private Long fileId;
    private Long assignmentId;
    private Long syllabusId;
    private Long versionId;
    private String fileType;
    private String originalFileName;
    private String storedFilePath;
    private Long fileSize;
    private String mimeType;
    private Long uploadedBy;
    private Timestamp uploadedAt;
    private boolean isActive;

    public SyllabusVersionFile() {}

    public SyllabusVersionFile(Long fileId, Long assignmentId, Long syllabusId, Long versionId,
                               String fileType, String originalFileName, String storedFilePath,
                               Long fileSize, String mimeType, Long uploadedBy, Timestamp uploadedAt,
                               boolean isActive) {
        this.fileId = fileId;
        this.assignmentId = assignmentId;
        this.syllabusId = syllabusId;
        this.versionId = versionId;
        this.fileType = fileType;
        this.originalFileName = originalFileName;
        this.storedFilePath = storedFilePath;
        this.fileSize = fileSize;
        this.mimeType = mimeType;
        this.uploadedBy = uploadedBy;
        this.uploadedAt = uploadedAt;
        this.isActive = isActive;
    }

    public Long getFileId() { return fileId; }
    public void setFileId(Long fileId) { this.fileId = fileId; }

    public Long getAssignmentId() { return assignmentId; }
    public void setAssignmentId(Long assignmentId) { this.assignmentId = assignmentId; }

    public Long getSyllabusId() { return syllabusId; }
    public void setSyllabusId(Long syllabusId) { this.syllabusId = syllabusId; }

    public Long getVersionId() { return versionId; }
    public void setVersionId(Long versionId) { this.versionId = versionId; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public String getOriginalFileName() { return originalFileName; }
    public void setOriginalFileName(String originalFileName) { this.originalFileName = originalFileName; }

    public String getStoredFilePath() { return storedFilePath; }
    public void setStoredFilePath(String storedFilePath) { this.storedFilePath = storedFilePath; }

    public Long getFileSize() { return fileSize; }
    public void setFileSize(Long fileSize) { this.fileSize = fileSize; }

    public String getMimeType() { return mimeType; }
    public void setMimeType(String mimeType) { this.mimeType = mimeType; }

    public Long getUploadedBy() { return uploadedBy; }
    public void setUploadedBy(Long uploadedBy) { this.uploadedBy = uploadedBy; }

    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }

    public boolean isIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }
}
