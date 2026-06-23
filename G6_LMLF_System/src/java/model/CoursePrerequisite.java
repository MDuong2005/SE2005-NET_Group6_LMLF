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

    public CoursePrerequisite() {
    }

    public CoursePrerequisite(long coursePrerequisiteId, long courseId, long prerequisiteCourseId) {
        this.coursePrerequisiteId = coursePrerequisiteId;
        this.courseId = courseId;
        this.prerequisiteCourseId = prerequisiteCourseId;
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
    
}
