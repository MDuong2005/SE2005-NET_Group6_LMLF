/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author maid8
 */
public class SyllabusAssignment {
    private long assignmentId;
    private long courseId;
    private long designerId;
    private long reviewerId;
    private String semester;
    private int academicYear;
    private Timestamp assignedAt;
    private String assignmentStatus;
    private Long templateFileId;
    private Long submittedVersionId;
    
    // New DB fields
    private Long assignedBy;
    private Long syllabusId;
    private Timestamp dueDate;
    private Timestamp acceptedAt;
    private Timestamp submittedAt;
    private Timestamp completedAt;

    // Display helpers (for showing lecturer name/email/course code on front end)
    private String courseCode;
    private String courseName;
    private String designerName;
    private String designerEmail;
    private String reviewerName;
    private String reviewerEmail;
    private List<Long> reviewerIds = new ArrayList<>();
    private String assignedByName;

    public SyllabusAssignment() {
    }

    public SyllabusAssignment(long assignmentId, long courseId, long designerId, long reviewerId, String semester, int academicYear, Timestamp assignedAt) {
        this.assignmentId = assignmentId;
        this.courseId = courseId;
        this.designerId = designerId;
        this.reviewerId = reviewerId;
        this.semester = semester;
        this.academicYear = academicYear;
        this.assignedAt = assignedAt;
    }

    public long getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(long assignmentId) {
        this.assignmentId = assignmentId;
    }

    public long getCourseId() {
        return courseId;
    }

    public void setCourseId(long courseId) {
        this.courseId = courseId;
    }

    public long getDesignerId() {
        return designerId;
    }

    public void setDesignerId(long designerId) {
        this.designerId = designerId;
    }

    public long getReviewerId() {
        return reviewerId;
    }

    public void setReviewerId(long reviewerId) {
        this.reviewerId = reviewerId;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public int getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(int academicYear) {
        this.academicYear = academicYear;
    }

    public Timestamp getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(Timestamp assignedAt) {
        this.assignedAt = assignedAt;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getDesignerName() {
        return designerName;
    }

    public void setDesignerName(String designerName) {
        this.designerName = designerName;
    }

    public String getDesignerEmail() {
        return designerEmail;
    }

    public void setDesignerEmail(String designerEmail) {
        this.designerEmail = designerEmail;
    }

    public String getReviewerName() {
        return reviewerName;
    }

    public void setReviewerName(String reviewerName) {
        this.reviewerName = reviewerName;
    }

    public String getReviewerEmail() {
        return reviewerEmail;
    }

    public void setReviewerEmail(String reviewerEmail) {
        this.reviewerEmail = reviewerEmail;
    }

    public List<Long> getReviewerIds() {
        return reviewerIds;
    }

    public void setReviewerIds(List<Long> reviewerIds) {
        this.reviewerIds = reviewerIds == null
                ? new ArrayList<>()
                : new ArrayList<>(reviewerIds);
    }

    public boolean hasReviewer(long reviewerId) {
        return reviewerIds != null && reviewerIds.contains(reviewerId);
    }

    public String getAssignmentStatus() {
        return assignmentStatus;
    }

    public void setAssignmentStatus(String assignmentStatus) {
        this.assignmentStatus = assignmentStatus;
    }

    public Long getTemplateFileId() {
        return templateFileId;
    }

    public void setTemplateFileId(Long templateFileId) {
        this.templateFileId = templateFileId;
    }

    public Long getSubmittedVersionId() {
        return submittedVersionId;
    }

    public void setSubmittedVersionId(Long submittedVersionId) {
        this.submittedVersionId = submittedVersionId;
    }

    public Long getAssignedBy() {
        return assignedBy;
    }

    public void setAssignedBy(Long assignedBy) {
        this.assignedBy = assignedBy;
    }

    public Long getSyllabusId() {
        return syllabusId;
    }

    public void setSyllabusId(Long syllabusId) {
        this.syllabusId = syllabusId;
    }

    public Timestamp getDueDate() {
        return dueDate;
    }

    public void setDueDate(Timestamp dueDate) {
        this.dueDate = dueDate;
    }

    public Timestamp getAcceptedAt() {
        return acceptedAt;
    }

    public void setAcceptedAt(Timestamp acceptedAt) {
        this.acceptedAt = acceptedAt;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public String getAssignedByName() {
        return assignedByName;
    }

    public void setAssignedByName(String assignedByName) {
        this.assignedByName = assignedByName;
    }
}
