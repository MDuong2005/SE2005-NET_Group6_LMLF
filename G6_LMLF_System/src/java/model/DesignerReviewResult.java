package model;

import java.sql.Timestamp;

public class DesignerReviewResult {

    private long reviewId;
    private long versionId;
    private String versionStatus;
    private long reviewerId;
    private String reviewerName;
    private String reviewerEmail;

    private String overallDecision;
    private String overallComment;
    private Timestamp reviewedAt;

    private long criteriaId;
    private String criteriaCode;
    private String criteriaName;

    private String sectionDecision;
    private String sectionComment;

    public DesignerReviewResult() {
    }

    public long getReviewId() {
        return reviewId;
    }

    public void setReviewId(long reviewId) {
        this.reviewId = reviewId;
    }

    public long getVersionId() {
        return versionId;
    }

    public void setVersionId(long versionId) {
        this.versionId = versionId;
    }

    public long getReviewerId() {
        return reviewerId;
    }

    public void setReviewerId(long reviewerId) {
        this.reviewerId = reviewerId;
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

    public String getOverallDecision() {
        return overallDecision;
    }

    public void setOverallDecision(String overallDecision) {
        this.overallDecision = overallDecision;
    }

    public String getOverallComment() {
        return overallComment;
    }

    public void setOverallComment(String overallComment) {
        this.overallComment = overallComment;
    }

    public Timestamp getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(Timestamp reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    public long getCriteriaId() {
        return criteriaId;
    }

    public void setCriteriaId(long criteriaId) {
        this.criteriaId = criteriaId;
    }

    public String getCriteriaCode() {
        return criteriaCode;
    }

    public void setCriteriaCode(String criteriaCode) {
        this.criteriaCode = criteriaCode;
    }

    public String getCriteriaName() {
        return criteriaName;
    }

    public void setCriteriaName(String criteriaName) {
        this.criteriaName = criteriaName;
    }

    public String getSectionDecision() {
        return sectionDecision;
    }

    public void setSectionDecision(String sectionDecision) {
        this.sectionDecision = sectionDecision;
    }

    public String getSectionComment() {
        return sectionComment;
    }

    public void setSectionComment(String sectionComment) {
        this.sectionComment = sectionComment;
    }

    public String getVersionStatus() {
        return versionStatus;
    }

    public void setVersionStatus(String versionStatus) {
        this.versionStatus = versionStatus;
    }
}
