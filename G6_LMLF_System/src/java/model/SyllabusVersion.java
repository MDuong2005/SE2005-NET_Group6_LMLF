/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author maid8
 */
public class SyllabusVersion {
    private long versionId;
    private long syllabusId;
    private String versionNumber;
    private String changeType;
    private String descriptionOfChanges;
    private String status;
    private long createdBy;

    public SyllabusVersion() {
    }

    public SyllabusVersion(long versionId, long syllabusId, String versionNumber, String changeType, String descriptionOfChanges, String status, long createdBy) {
        this.versionId = versionId;
        this.syllabusId = syllabusId;
        this.versionNumber = versionNumber;
        this.changeType = changeType;
        this.descriptionOfChanges = descriptionOfChanges;
        this.status = status;
        this.createdBy = createdBy;
    }
    

    public long getVersionId() {
        return versionId;
    }

    public void setVersionId(long versionId) {
        this.versionId = versionId;
    }

    public long getSyllabusId() {
        return syllabusId;
    }

    public void setSyllabusId(long syllabusId) {
        this.syllabusId = syllabusId;
    }

    public String getVersionNumber() {
        return versionNumber;
    }

    public void setVersionNumber(String versionNumber) {
        this.versionNumber = versionNumber;
    }

    public String getChangeType() {
        return changeType;
    }

    public void setChangeType(String changeType) {
        this.changeType = changeType;
    }

    public String getDescriptionOfChanges() {
        return descriptionOfChanges;
    }

    public void setDescriptionOfChanges(String descriptionOfChanges) {
        this.descriptionOfChanges = descriptionOfChanges;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(long createdBy) {
        this.createdBy = createdBy;
    }
    
}
