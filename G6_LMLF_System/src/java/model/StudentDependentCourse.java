package model;

/** One course that directly requires a searched prerequisite in the Student module. */
public class StudentDependentCourse {

    private final long courseId;
    private final String code;
    private final String name;

    public StudentDependentCourse(long courseId, String code, String name) {
        this.courseId = courseId;
        this.code = code;
        this.name = name;
    }

    public long getCourseId() {
        return courseId;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }
}
