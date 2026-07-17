package model;

import java.sql.Timestamp;

public class CurriculumPloPoMapping {
    private Long ploId;
    private Long poId;
    private Timestamp mappedAt;

    public CurriculumPloPoMapping() {}

    public CurriculumPloPoMapping(Long ploId, Long poId) {
        this.ploId = ploId;
        this.poId = poId;
        this.mappedAt = new Timestamp(System.currentTimeMillis());
    }

    public Long getPloId() {
        return ploId;
    }

    public void setPloId(Long ploId) {
        this.ploId = ploId;
    }

    public Long getPoId() {
        return poId;
    }

    public void setPoId(Long poId) {
        this.poId = poId;
    }

    public Timestamp getMappedAt() {
        return mappedAt;
    }

    public void setMappedAt(Timestamp mappedAt) {
        this.mappedAt = mappedAt;
    }
}
