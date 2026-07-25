package model;

import java.sql.Timestamp;

public class AcademicPublicationItem {

    private long versionId;
    private long syllabusId;
    private Long assignmentId;
    private String courseCode;
    private String courseName;
    private String versionNumber;
    private String versionStatus;
    private String designerName;
    private int reviewerCount;
    private int completedReviewerCount;
    private int approvedReviewerCount;
    private Timestamp approvedAt;
    private Timestamp publishedAt;

    public AcademicPublicationItem() {
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

    public Long getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Long assignmentId) {
        this.assignmentId = assignmentId;
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

    public String getDesignerName() {
        return designerName;
    }

    public void setDesignerName(String designerName) {
        this.designerName = designerName;
    }

    public int getReviewerCount() {
        return reviewerCount;
    }

    public void setReviewerCount(int reviewerCount) {
        this.reviewerCount = reviewerCount;
    }

    public int getCompletedReviewerCount() {
        return completedReviewerCount;
    }

    public void setCompletedReviewerCount(int completedReviewerCount) {
        this.completedReviewerCount = completedReviewerCount;
    }

    public int getApprovedReviewerCount() {
        return approvedReviewerCount;
    }

    public void setApprovedReviewerCount(int approvedReviewerCount) {
        this.approvedReviewerCount = approvedReviewerCount;
    }

    public Timestamp getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }

    public Timestamp getPublishedAt() {
        return publishedAt;
    }

    public void setPublishedAt(Timestamp publishedAt) {
        this.publishedAt = publishedAt;
    }

    public boolean isReadyToPublish() {
        return "APPROVED".equalsIgnoreCase(versionStatus)
                && reviewerCount > 0
                && completedReviewerCount == reviewerCount
                && approvedReviewerCount == reviewerCount;
    }

    public String getCourseLabel() {
        if (courseCode == null || courseCode.trim().isEmpty()) {
            return courseName == null ? "Course" : courseName;
        }

        if (courseName == null || courseName.trim().isEmpty()) {
            return courseCode;
        }

        return courseCode + " - " + courseName;
    }
}
