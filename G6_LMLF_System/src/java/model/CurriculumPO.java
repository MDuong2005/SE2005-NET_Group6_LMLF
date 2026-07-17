package model;

import java.sql.Timestamp;

public class CurriculumPO {
    private Long poId;
    private Long curriculumId;
    private String code;
    private String description;
    private Timestamp createdAt;

    public CurriculumPO() {}

    public CurriculumPO(Long curriculumId, String code, String description) {
        this.curriculumId = curriculumId;
        this.code = code;
        this.description = description;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    public Long getPoId() {
        return poId;
    }

    public void setPoId(Long poId) {
        this.poId = poId;
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
