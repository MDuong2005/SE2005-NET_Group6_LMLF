/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author maid8
 */
public class CoursePrerequisite {
    private long coursePrerequisiteId;
    private long courseId;
    private long prerequisiteCourseId;
    private String courseCode;
    private String courseName;
    private String prerequisiteCourseCode;
    private String prerequisiteCourseName;

    public CoursePrerequisite() {
    }

    public CoursePrerequisite(long coursePrerequisiteId, long courseId, long prerequisiteCourseId) {
        this.coursePrerequisiteId = coursePrerequisiteId;
        this.courseId = courseId;
        this.prerequisiteCourseId = prerequisiteCourseId;
    }

    public CoursePrerequisite(long coursePrerequisiteId, long courseId, long prerequisiteCourseId, 
                              String courseCode, String courseName, 
                              String prerequisiteCourseCode, String prerequisiteCourseName) {
        this.coursePrerequisiteId = coursePrerequisiteId;
        this.courseId = courseId;
        this.prerequisiteCourseId = prerequisiteCourseId;
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.prerequisiteCourseCode = prerequisiteCourseCode;
        this.prerequisiteCourseName = prerequisiteCourseName;
    }

    public long getCoursePrerequisiteId() {
        return coursePrerequisiteId;
    }

    public void setCoursePrerequisiteId(long coursePrerequisiteId) {
        this.coursePrerequisiteId = coursePrerequisiteId;
    }

    public long getCourseId() {
        return courseId;
    }

    public void setCourseId(long courseId) {
        this.courseId = courseId;
    }

    public long getPrerequisiteCourseId() {
        return prerequisiteCourseId;
    }

    public void setPrerequisiteCourseId(long prerequisiteCourseId) {
        this.prerequisiteCourseId = prerequisiteCourseId;
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

    public String getPrerequisiteCourseCode() {
        return prerequisiteCourseCode;
    }

    public void setPrerequisiteCourseCode(String prerequisiteCourseCode) {
        this.prerequisiteCourseCode = prerequisiteCourseCode;
    }

    public String getPrerequisiteCourseName() {
        return prerequisiteCourseName;
    }

    public void setPrerequisiteCourseName(String prerequisiteCourseName) {
        this.prerequisiteCourseName = prerequisiteCourseName;
    }
}
