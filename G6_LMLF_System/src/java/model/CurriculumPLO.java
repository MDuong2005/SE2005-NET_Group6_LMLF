package model;

import java.sql.Timestamp;

public class CurriculumPLO {
    private Long ploId;
    private Long curriculumId;
    private String code;
    private String description;
    private Timestamp createdAt;

    public CurriculumPLO() {}

    public CurriculumPLO(Long curriculumId, String code, String description) {
        this.curriculumId = curriculumId;
        this.code = code;
        this.description = description;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    public Long getPloId() {
        return ploId;
    }

    public void setPloId(Long ploId) {
        this.ploId = ploId;
    }

    public Long getCurriculumId() {
        return curriculumId;
    }

    public void setCurriculumId(Long curriculumId) {
        this.curriculumId = curriculumId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
