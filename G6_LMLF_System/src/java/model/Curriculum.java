/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author maid8
 */
public class Curriculum {
    private long curriculumId;
    private long majorId;
    private String version;
    private String status;
    private int totalSemesters;

    public Curriculum() {
    }

    public Curriculum(long curriculumId, long majorId, String version, String status, int totalSemesters) {
        this.curriculumId = curriculumId;
        this.majorId = majorId;
        this.version = version;
        this.status = status;
        this.totalSemesters = totalSemesters;
    }

    public long getCurriculumId() {
        return curriculumId;
    }

    public void setCurriculumId(long curriculumId) {
        this.curriculumId = curriculumId;
    }

    public long getMajorId() {
        return majorId;
    }

    public void setMajorId(long majorId) {
        this.majorId = majorId;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getTotalSemesters() {
        return totalSemesters;
    }

    public void setTotalSemesters(int totalSemesters) {
        this.totalSemesters = totalSemesters;
    }
    
}
