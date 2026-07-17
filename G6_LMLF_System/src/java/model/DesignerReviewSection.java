package model;

import java.sql.Timestamp;

public class DesignerReviewSection {

    private Long sectionReviewId;
    private Long criteriaId;
    private String criteriaCode;
    private String criteriaName;
    private String decision;
    private String comment;
    private Timestamp createdAt;

    public Long getSectionReviewId() {
        return sectionReviewId;
    }

    public void setSectionReviewId(Long sectionReviewId) {
        this.sectionReviewId = sectionReviewId;
    }

    public Long getCriteriaId() {
        return criteriaId;
    }

    public void setCriteriaId(Long criteriaId) {
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

    public String getDecision() {
        return decision;
    }

    public void setDecision(String decision) {
        this.decision = decision;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}