/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author maid8
 */
public class Syllabus {
    private long syllabusId;
    private long courseId;
    private String title;
    private String currentVersion;
    private String status;

    public Syllabus() {
    }

    public Syllabus(long syllabusId, long courseId, String title, String currentVersion, String status) {
        this.syllabusId = syllabusId;
        this.courseId = courseId;
        this.title = title;
        this.currentVersion = currentVersion;
        this.status = status;
    }

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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCurrentVersion() {
        return currentVersion;
    }

    public void setCurrentVersion(String currentVersion) {
        this.currentVersion = currentVersion;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    
}
