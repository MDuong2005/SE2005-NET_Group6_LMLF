package model;

public class LearningOutcome {
    private Long outcomeId;
    private Long versionId;
    private String code;
    private String description;
    private String bloomLevel; // Remember, Understand, Apply, Analyze, Evaluate, Create

    public LearningOutcome() {}

    public LearningOutcome(Long versionId, String code, String description, String bloomLevel) {
        this.versionId = versionId;
        this.code = code;
        this.description = description;
        this.bloomLevel = bloomLevel;
    }

    // Getters and Setters
    public Long getOutcomeId() { return outcomeId; }
    public void setOutcomeId(Long outcomeId) { this.outcomeId = outcomeId; }
    public Long getVersionId() { return versionId; }
    public void setVersionId(Long versionId) { this.versionId = versionId; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getBloomLevel() { return bloomLevel; }
    public void setBloomLevel(String bloomLevel) { this.bloomLevel = bloomLevel; }
}