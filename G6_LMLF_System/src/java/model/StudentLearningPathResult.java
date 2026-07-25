package model;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/** Subject and published-syllabus information shown in Student learning-path search. */
public class StudentLearningPathResult {

    private Long syllabusId;
    private long courseId;
    private String subjectCode;
    private String syllabusName;
    private String decisionInformation;
    private List<StudentLearningPathCourse> prerequisites = new ArrayList<>();

    public Long getSyllabusId() {
        return syllabusId;
    }

    public void setSyllabusId(Long syllabusId) {
        this.syllabusId = syllabusId;
    }

    public boolean isPublishedSyllabusAvailable() {
        return syllabusId != null;
    }

    public long getCourseId() {
        return courseId;
    }

    public void setCourseId(long courseId) {
        this.courseId = courseId;
    }

    public String getSubjectCode() {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }

    public String getSyllabusName() {
        return syllabusName;
    }

    public void setSyllabusName(String syllabusName) {
        this.syllabusName = syllabusName;
    }

    public String getDecisionInformation() {
        return decisionInformation;
    }

    public void setDecisionInformation(String decisionInformation) {
        this.decisionInformation = decisionInformation;
    }

    public List<StudentLearningPathCourse> getPrerequisites() {
        return prerequisites;
    }

    public void setPrerequisites(List<StudentLearningPathCourse> prerequisites) {
        this.prerequisites = prerequisites == null
                ? new ArrayList<>()
                : new ArrayList<>(prerequisites);
    }

    public String getAllPrerequisiteCodes() {
        return prerequisites.stream()
                .map(StudentLearningPathCourse::getCode)
                .collect(Collectors.joining(", "));
    }
}
