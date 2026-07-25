package model;

import java.sql.Timestamp;

/**
 * Role-specific task projection used only by Lecturer My Tasks.
 */
public class LecturerTask {

    private long assignmentId;
    private String courseCode;
    private String courseName;
    private String taskRole;
    private String taskStatus;
    private Long submittedVersionId;
    private String versionNumber;
    private String versionStatus;
    private String assignedByName;
    private Timestamp assignedAt;
    private Timestamp dueDate;

    public long getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(long assignmentId) {
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

    public String getTaskRole() {
        return taskRole;
    }

    public void setTaskRole(String taskRole) {
        this.taskRole = taskRole;
    }

    public String getTaskStatus() {
        return taskStatus;
    }

    public void setTaskStatus(String taskStatus) {
        this.taskStatus = taskStatus;
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

    public String getAssignedByName() {
        return assignedByName;
    }

    public void setAssignedByName(String assignedByName) {
        this.assignedByName = assignedByName;
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

    public String getTaskStatusGroup() {
        if (taskStatus == null) {
            return "CLOSED";
        }

        switch (taskStatus.toUpperCase()) {
            case "PENDING":
                return "PENDING";
            case "ACCEPTED":
            case "ACTIVE":
            case "IN_PROGRESS":
            case "SUBMITTED":
                return "INPROGRESS";
            case "COMPLETED":
                return "COMPLETED";
            case "REJECTED":
                return "DESIGNER".equalsIgnoreCase(taskRole)
                        && "REJECTED".equalsIgnoreCase(versionStatus)
                        ? "INPROGRESS"
                        : "CLOSED";
            case "CANCELLED":
            default:
                return "CLOSED";
        }
    }

    public String getTaskStatusLabel() {
        if ("REVIEWER".equalsIgnoreCase(taskRole)) {
            if ("PENDING".equalsIgnoreCase(taskStatus)
                    && submittedVersionId == null) {
                return "Waiting for Submission";
            }
            if ("PENDING".equalsIgnoreCase(taskStatus)) {
                return "Pending Review";
            }
        }

        if ("DESIGNER".equalsIgnoreCase(taskRole)) {
            if ("SUBMITTED".equalsIgnoreCase(taskStatus)) {
                return "In Review";
            }
            if ("REJECTED".equalsIgnoreCase(taskStatus)
                    && "REJECTED".equalsIgnoreCase(versionStatus)) {
                return "Revision Required";
            }
        }

        if (taskStatus == null || taskStatus.trim().isEmpty()) {
            return "Closed";
        }

        String normalized = taskStatus.trim().toLowerCase()
                .replace('_', ' ');
        StringBuilder label = new StringBuilder();
        boolean capitalize = true;

        for (char character : normalized.toCharArray()) {
            if (capitalize && Character.isLetter(character)) {
                label.append(Character.toUpperCase(character));
                capitalize = false;
            } else {
                label.append(character);
            }

            if (character == ' ') {
                capitalize = true;
            }
        }

        return label.toString();
    }
}
