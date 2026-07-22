package model;

import java.util.ArrayList;
import java.util.List;

/** Published syllabus and reverse prerequisite information shown to Students. */
public class StudentPrerequisiteResult {

    private long syllabusId;
    private long courseId;
    private String subjectCode;
    private String syllabusName;
    private String decisionInformation;
    private List<StudentDependentCourse> dependentCourses = new ArrayList<>();

    public long getSyllabusId() {
        return syllabusId;
    }

    public void setSyllabusId(long syllabusId) {
        this.syllabusId = syllabusId;
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

    public List<StudentDependentCourse> getDependentCourses() {
        return dependentCourses;
    }

    public void setDependentCourses(List<StudentDependentCourse> dependentCourses) {
        this.dependentCourses = dependentCourses == null
                ? new ArrayList<>()
                : new ArrayList<>(dependentCourses);
    }
}
