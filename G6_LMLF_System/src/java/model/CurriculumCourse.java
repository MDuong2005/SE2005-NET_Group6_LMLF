package model;

public class CurriculumCourse {
    private Long id;
    private Long curriculumId;
    private Long courseId;
    private Integer semester;
    private Course course;
    private String knowledgeBlock;

    public CurriculumCourse() {}

    public CurriculumCourse(Long curriculumId, Long courseId, Integer semester) {
        this.curriculumId = curriculumId;
        this.courseId = courseId;
        this.semester = semester;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getCurriculumId() { return curriculumId; }
    public void setCurriculumId(Long curriculumId) { this.curriculumId = curriculumId; }
    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }
    public Integer getSemester() { return semester; }
    public void setSemester(Integer semester) { this.semester = semester; }
    public Course getCourse() { return course; }
    public void setCourse(Course course) { this.course = course; }
    public String getKnowledgeBlock() { return knowledgeBlock; }
    public void setKnowledgeBlock(String knowledgeBlock) { this.knowledgeBlock = knowledgeBlock; }
}