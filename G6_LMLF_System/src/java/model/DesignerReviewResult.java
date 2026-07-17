package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class DesignerReviewResult {

    private Long reviewId;
    private Long versionId;
    private String versionNumber;
    private String versionStatus;
    private String syllabusTitle;
    private String courseCode;
    private String courseName;
    private String reviewerName;
    private String reviewerEmail;
    private String decision;
    private String comment;
    private Timestamp reviewedAt;
    private List<DesignerReviewSection> sections = new ArrayList<>();

    public Long getReviewId() {
        return reviewId;
    }

    public void setReviewId(Long reviewId) {
        this.reviewId = reviewId;
    }

    public Long getVersionId() {
        return versionId;
    }

    public void setVersionId(Long versionId) {
        this.versionId = versionId;
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

    public String getSyllabusTitle() {
        return syllabusTitle;
    }

    public void setSyllabusTitle(String syllabusTitle) {
        this.syllabusTitle = syllabusTitle;
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

    public Timestamp getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(Timestamp reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    public List<DesignerReviewSection> getSections() {
        return sections;
    }

    public void setSections(List<DesignerReviewSection> sections) {
        this.sections = sections == null
                ? new ArrayList<>()
                : sections;
    }
}