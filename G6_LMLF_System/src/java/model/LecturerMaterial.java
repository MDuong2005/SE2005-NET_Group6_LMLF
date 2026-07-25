/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author maid8
 */
public class LecturerMaterial {
    private long lecturerMaterialId;
    private long courseId;
    private long lecturerId;
    private String title;
    private String fileUrl;
    private java.sql.Timestamp uploadedAt;
    private String category;
    private String materialType;
    
    // For joining with shared_materials
    private String sharedByEmail;
    private java.sql.Timestamp sharedAt;

    public LecturerMaterial() {
    }

    public long getLecturerMaterialId() {
        return lecturerMaterialId;
    }

    public void setLecturerMaterialId(long lecturerMaterialId) {
        this.lecturerMaterialId = lecturerMaterialId;
    }

    public long getCourseId() {
        return courseId;
    }

    public void setCourseId(long courseId) {
        this.courseId = courseId;
    }

    public long getLecturerId() {
        return lecturerId;
    }

    public void setLecturerId(long lecturerId) {
        this.lecturerId = lecturerId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public java.sql.Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(java.sql.Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getMaterialType() {
        return materialType;
    }

    public void setMaterialType(String materialType) {
        this.materialType = materialType;
    }

    public String getSharedByEmail() {
        return sharedByEmail;
    }

    public void setSharedByEmail(String sharedByEmail) {
        this.sharedByEmail = sharedByEmail;
    }

    public java.sql.Timestamp getSharedAt() {
        return sharedAt;
    }

    public void setSharedAt(java.sql.Timestamp sharedAt) {
        this.sharedAt = sharedAt;
    }
}
