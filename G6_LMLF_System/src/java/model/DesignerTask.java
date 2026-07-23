package model;

import java.sql.Timestamp;

public class DesignerTask {
    private Long assignmentId;
    private Long courseId;
    private Long syllabusId;
    private Long designerId;
    private Long reviewerId;

    private String courseCode;
    private String courseName;
    private Integer credits;

    private String syllabusTitle;
    private String syllabusStatus;
    private String currentVersion;

    private String reviewerName;
    private String reviewerEmail;

    private String semester;
    private Integer academicYear;
    private String assignmentStatus;
    private Timestamp assignedAt;
    private Timestamp dueDate;
    private Timestamp acceptedAt;
    private Timestamp submittedAt;
    private Timestamp completedAt;

    private Long templateFileId;
    private String templateFileName;

    private Long submittedVersionId;
    private String versionNumber;
    private String versionStatus;
    private String descriptionOfChanges;
    private Timestamp versionSubmittedAt;

    private Long submissionFileId;
    private String submissionFileName;

    public boolean isPending() {
        return "PENDING".equalsIgnoreCase(assignmentStatus);
    }

    public boolean isRejected() {
        return "REJECTED".equalsIgnoreCase(assignmentStatus);
    }

    public boolean isSubmitted() {
        return submittedVersionId != null || "SUBMITTED".equalsIgnoreCase(assignmentStatus);
    }

    public boolean isCompleted() {
        return "COMPLETED".equalsIgnoreCase(assignmentStatus);
    }

    public boolean isUploadAllowed() {
        if (assignmentStatus == null) {
            return false;
        }

        if ("CANCELLED".equalsIgnoreCase(assignmentStatus)
                || "COMPLETED".equalsIgnoreCase(assignmentStatus)
                || "PUBLISHED".equalsIgnoreCase(versionStatus)) {
            return false;
        }

        /*
         * A published syllabus may receive a new Academic update assignment.
         * Academic already created the next DRAFT version (2.0, 3.0, ...),
         * so Designer must be allowed to edit that DRAFT.
         */
        if ("PUBLISHED".equalsIgnoreCase(syllabusStatus)
                && !"DRAFT".equalsIgnoreCase(versionStatus)) {
            return false;
        }

        /*
         * A Reviewer rejection may also set assignment_status=REJECTED.
         * When the assignment already has a submitted version and that
         * version is REJECTED, the Designer must be allowed to revise it.
         */
        if (submittedVersionId != null
                && "REJECTED".equalsIgnoreCase(versionStatus)) {
            return true;
        }

        /*
         * REJECTED without a rejected submitted version means that the
         * Designer rejected the original assignment.
         */
        if ("REJECTED".equalsIgnoreCase(assignmentStatus)) {
            return false;
        }

        if ("SUBMITTED".equalsIgnoreCase(versionStatus)
                || "APPROVED".equalsIgnoreCase(versionStatus)
                || "ARCHIVED".equalsIgnoreCase(versionStatus)) {
            return false;
        }

        return submittedVersionId == null
                || versionStatus == null
                || "DRAFT".equalsIgnoreCase(versionStatus);
    }

    public Long getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Long assignmentId) {
        this.assignmentId = assignmentId;
    }

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public Long getSyllabusId() {
        return syllabusId;
    }

    public void setSyllabusId(Long syllabusId) {
        this.syllabusId = syllabusId;
    }

    public Long getDesignerId() {
        return designerId;
    }

    public void setDesignerId(Long designerId) {
        this.designerId = designerId;
    }

    public Long getReviewerId() {
        return reviewerId;
    }

    public void setReviewerId(Long reviewerId) {
        this.reviewerId = reviewerId;
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

    public Integer getCredits() {
        return credits;
    }

    public void setCredits(Integer credits) {
        this.credits = credits;
    }

    public String getSyllabusTitle() {
        return syllabusTitle;
    }

    public void setSyllabusTitle(String syllabusTitle) {
        this.syllabusTitle = syllabusTitle;
    }

    public String getSyllabusStatus() {
        return syllabusStatus;
    }

    public void setSyllabusStatus(String syllabusStatus) {
        this.syllabusStatus = syllabusStatus;
    }

    public String getCurrentVersion() {
        return currentVersion;
    }

    public void setCurrentVersion(String currentVersion) {
        this.currentVersion = currentVersion;
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

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public Integer getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(Integer academicYear) {
        this.academicYear = academicYear;
    }

    public String getAssignmentStatus() {
        return assignmentStatus;
    }

    public void setAssignmentStatus(String assignmentStatus) {
        this.assignmentStatus = assignmentStatus;
    }

    public Timestamp getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(Timestamp assignedAt) {
        this.assignedAt = assignedAt;
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

    public Long getTemplateFileId() {
        return templateFileId;
    }

    public void setTemplateFileId(Long templateFileId) {
        this.templateFileId = templateFileId;
    }

    public String getTemplateFileName() {
        return templateFileName;
    }

    public void setTemplateFileName(String templateFileName) {
        this.templateFileName = templateFileName;
    }

    public Long getSubmittedVersionId() {
        return submittedVersionId;
    }

    public void setSubmittedVersionId(Long submittedVersionId) {
        this.submittedVersionId = submittedVersionId;
    }

    public String getVersionNumber() {
        return versionNumber;
    }

    public void setVersionNumber(String versionNumber) {
        this.versionNumber = versionNumber;
    }

    public String getVersionStatus() {
        return versionStatus;
    }

    public void setVersionStatus(String versionStatus) {
        this.versionStatus = versionStatus;
    }

    public String getDescriptionOfChanges() {
        return descriptionOfChanges;
    }

    public void setDescriptionOfChanges(String descriptionOfChanges) {
        this.descriptionOfChanges = descriptionOfChanges;
    }

    public Timestamp getVersionSubmittedAt() {
        return versionSubmittedAt;
    }

    public void setVersionSubmittedAt(Timestamp versionSubmittedAt) {
        this.versionSubmittedAt = versionSubmittedAt;
    }

    public Long getSubmissionFileId() {
        return submissionFileId;
    }

    public void setSubmissionFileId(Long submissionFileId) {
        this.submissionFileId = submissionFileId;
    }

    public String getSubmissionFileName() {
        return submissionFileName;
    }

    public void setSubmissionFileName(String submissionFileName) {
        this.submissionFileName = submissionFileName;
    }
}