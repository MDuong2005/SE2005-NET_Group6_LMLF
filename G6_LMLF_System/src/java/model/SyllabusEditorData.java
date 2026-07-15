package model;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SyllabusEditorData {
    private Long versionId;
    private String versionNumber;
    private String status;
    private GeneralInformation generalInformation = new GeneralInformation();
    private List<CloItem> clos = new ArrayList<>();
    private List<TextItem> studentTasks = new ArrayList<>();
    private List<ResourceItem> learningResources = new ArrayList<>();
    private List<ScheduleItem> scheduleItems = new ArrayList<>();
    private List<AssessmentItem> assessments = new ArrayList<>();
    private List<PloItem> plos = new ArrayList<>();
    private Map<String, List<Long>> cloPloMappings = new LinkedHashMap<>();

    public Long getVersionId() { return versionId; }
    public void setVersionId(Long versionId) { this.versionId = versionId; }
    public String getVersionNumber() { return versionNumber; }
    public void setVersionNumber(String versionNumber) { this.versionNumber = versionNumber; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public GeneralInformation getGeneralInformation() { return generalInformation; }
    public void setGeneralInformation(GeneralInformation generalInformation) { this.generalInformation = generalInformation == null ? new GeneralInformation() : generalInformation; }
    public List<CloItem> getClos() { return clos; }
    public void setClos(List<CloItem> clos) { this.clos = clos == null ? new ArrayList<>() : clos; }
    public List<TextItem> getStudentTasks() { return studentTasks; }
    public void setStudentTasks(List<TextItem> studentTasks) { this.studentTasks = studentTasks == null ? new ArrayList<>() : studentTasks; }
    public List<ResourceItem> getLearningResources() { return learningResources; }
    public void setLearningResources(List<ResourceItem> learningResources) { this.learningResources = learningResources == null ? new ArrayList<>() : learningResources; }
    public List<ScheduleItem> getScheduleItems() { return scheduleItems; }
    public void setScheduleItems(List<ScheduleItem> scheduleItems) { this.scheduleItems = scheduleItems == null ? new ArrayList<>() : scheduleItems; }
    public List<AssessmentItem> getAssessments() { return assessments; }
    public void setAssessments(List<AssessmentItem> assessments) { this.assessments = assessments == null ? new ArrayList<>() : assessments; }
    public List<PloItem> getPlos() { return plos; }
    public void setPlos(List<PloItem> plos) { this.plos = plos == null ? new ArrayList<>() : plos; }
    public Map<String, List<Long>> getCloPloMappings() { return cloPloMappings; }
    public void setCloPloMappings(Map<String, List<Long>> cloPloMappings) { this.cloPloMappings = cloPloMappings == null ? new LinkedHashMap<>() : cloPloMappings; }

    public static class GeneralInformation {
        private String courseName;
        private String courseCode;
        private Integer credits;
        private String degreeLevel;
        private String timeAllocation;
        private String prerequisiteText;
        private String courseDescription;
        public String getCourseName() { return courseName; }
        public void setCourseName(String courseName) { this.courseName = courseName; }
        public String getCourseCode() { return courseCode; }
        public void setCourseCode(String courseCode) { this.courseCode = courseCode; }
        public Integer getCredits() { return credits; }
        public void setCredits(Integer credits) { this.credits = credits; }
        public String getDegreeLevel() { return degreeLevel; }
        public void setDegreeLevel(String degreeLevel) { this.degreeLevel = degreeLevel; }
        public String getTimeAllocation() { return timeAllocation; }
        public void setTimeAllocation(String timeAllocation) { this.timeAllocation = timeAllocation; }
        public String getPrerequisiteText() { return prerequisiteText; }
        public void setPrerequisiteText(String prerequisiteText) { this.prerequisiteText = prerequisiteText; }
        public String getCourseDescription() { return courseDescription; }
        public void setCourseDescription(String courseDescription) { this.courseDescription = courseDescription; }
    }

    public static class CloItem {
        private Long outcomeId;
        private String code;
        private String description;
        private String bloomLevel;
        public Long getOutcomeId() { return outcomeId; }
        public void setOutcomeId(Long outcomeId) { this.outcomeId = outcomeId; }
        public String getCode() { return code; }
        public void setCode(String code) { this.code = code; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public String getBloomLevel() { return bloomLevel; }
        public void setBloomLevel(String bloomLevel) { this.bloomLevel = bloomLevel; }
    }

    public static class TextItem {
        private String content;
        public TextItem() {}
        public TextItem(String content) { this.content = content; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
    }

    public static class ResourceItem {
        private String category = "OTHER";
        private String title;
        private String author;
        private String publisher;
        private String isbn;
        private String url;
        private String description;
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getAuthor() { return author; }
        public void setAuthor(String author) { this.author = author; }
        public String getPublisher() { return publisher; }
        public void setPublisher(String publisher) { this.publisher = publisher; }
        public String getIsbn() { return isbn; }
        public void setIsbn(String isbn) { this.isbn = isbn; }
        public String getUrl() { return url; }
        public void setUrl(String url) { this.url = url; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
    }

    public static class ScheduleItem {
        private Integer sessionNumber;
        private String category;
        private String topic;
        private String cloCodes;
        private String ituLevel;
        private String materials;
        private String activities;
        public Integer getSessionNumber() { return sessionNumber; }
        public void setSessionNumber(Integer sessionNumber) { this.sessionNumber = sessionNumber; }
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public String getTopic() { return topic; }
        public void setTopic(String topic) { this.topic = topic; }
        public String getCloCodes() { return cloCodes; }
        public void setCloCodes(String cloCodes) { this.cloCodes = cloCodes; }
        public String getItuLevel() { return ituLevel; }
        public void setItuLevel(String ituLevel) { this.ituLevel = ituLevel; }
        public String getMaterials() { return materials; }
        public void setMaterials(String materials) { this.materials = materials; }
        public String getActivities() { return activities; }
        public void setActivities(String activities) { this.activities = activities; }
    }

    public static class AssessmentItem {
        private String category;
        private String partNumber;
        private Double weight;
        private String duration;
        private String cloCodes;
        private String questionType;
        private String numberOfQuestions;
        private String knowledgeScope;
        private String assessmentMethod;
        private String note;
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        public String getPartNumber() { return partNumber; }
        public void setPartNumber(String partNumber) { this.partNumber = partNumber; }
        public Double getWeight() { return weight; }
        public void setWeight(Double weight) { this.weight = weight; }
        public String getDuration() { return duration; }
        public void setDuration(String duration) { this.duration = duration; }
        public String getCloCodes() { return cloCodes; }
        public void setCloCodes(String cloCodes) { this.cloCodes = cloCodes; }
        public String getQuestionType() { return questionType; }
        public void setQuestionType(String questionType) { this.questionType = questionType; }
        public String getNumberOfQuestions() { return numberOfQuestions; }
        public void setNumberOfQuestions(String numberOfQuestions) { this.numberOfQuestions = numberOfQuestions; }
        public String getKnowledgeScope() { return knowledgeScope; }
        public void setKnowledgeScope(String knowledgeScope) { this.knowledgeScope = knowledgeScope; }
        public String getAssessmentMethod() { return assessmentMethod; }
        public void setAssessmentMethod(String assessmentMethod) { this.assessmentMethod = assessmentMethod; }
        public String getNote() { return note; }
        public void setNote(String note) { this.note = note; }
    }

    public static class PloItem {
        private Long ploId;
        private String code;
        private String name;
        private String description;
        public Long getPloId() { return ploId; }
        public void setPloId(Long ploId) { this.ploId = ploId; }
        public String getCode() { return code; }
        public void setCode(String code) { this.code = code; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
    }
}
