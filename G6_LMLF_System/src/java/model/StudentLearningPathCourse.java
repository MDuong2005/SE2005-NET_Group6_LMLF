package model;

/** One course in a Student learning path. */
public class StudentLearningPathCourse {

    private final long courseId;
    private final String code;
    private final String name;
    private final int depth;
    private final String directPrerequisiteCodes;

    public StudentLearningPathCourse(
            long courseId,
            String code,
            String name,
            int depth,
            String directPrerequisiteCodes
    ) {
        this.courseId = courseId;
        this.code = code;
        this.name = name;
        this.depth = depth;
        this.directPrerequisiteCodes = directPrerequisiteCodes;
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

    public int getDepth() {
        return depth;
    }

    public String getDirectPrerequisiteCodes() {
        return directPrerequisiteCodes;
    }

    public boolean isNoPrerequisite() {
        return directPrerequisiteCodes == null || directPrerequisiteCodes.isBlank();
    }
}
