package service;

import model.SyllabusEditorData;
import org.apache.poi.ss.usermodel.*;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SyllabusExcelImportService {
    private static final Pattern OUTCOME_PATTERN = Pattern.compile("(?i)(?:C?LO|L)\\s*0*(\\d+)");
    private final DataFormatter formatter = new DataFormatter(Locale.ENGLISH);

    public SyllabusEditorData parse(InputStream inputStream) throws Exception {
        SyllabusEditorData data = new SyllabusEditorData();
        try (Workbook workbook = WorkbookFactory.create(inputStream)) {
            parseGeneral(findSheet(workbook, "01_ACADEMIC_INFO"), data);
            parseClos(findSheet(workbook, "02_COURSE_LEARNING_OUTCOMES", "02_LEARNING_OUTCOMES", "02_CLOS"), data);
            parseStudentTasks(findSheet(workbook, "03_STUDENT_TASKS"), data);
            parseResources(findSheet(workbook, "04_LEARNING_MATERIALS"), data);
            parseSchedule(findSheet(workbook, "05_COURSE_SCHEDULE"), data);
            parseAssessments(findSheet(workbook, "06_COURSE_ASSESSMENT"), data);
        }
        return data;
    }

    private Sheet findSheet(Workbook workbook, String... names) {
        for (String name : names) {
            Sheet exact = workbook.getSheet(name);
            if (exact != null) return exact;
        }
        for (Sheet sheet : workbook) {
            String normalized = sheet.getSheetName().trim().toUpperCase(Locale.ENGLISH);
            for (String name : names) {
                if (normalized.equals(name.toUpperCase(Locale.ENGLISH))) return sheet;
            }
        }
        return null;
    }

    private void parseGeneral(Sheet sheet, SyllabusEditorData data) {
        if (sheet == null) return;
        SyllabusEditorData.GeneralInformation info = new SyllabusEditorData.GeneralInformation();
        info.setCourseName(value(sheet, 5, 2));
        info.setCourseCode(value(sheet, 6, 2));
        info.setCredits(integer(value(sheet, 7, 2)));
        info.setDegreeLevel(value(sheet, 8, 2));
        info.setTimeAllocation(value(sheet, 9, 2));
        info.setPrerequisiteText(value(sheet, 10, 2));
        info.setCourseDescription(value(sheet, 11, 2));
        data.setGeneralInformation(info);
    }

    private void parseClos(Sheet sheet, SyllabusEditorData data) {
        if (sheet == null) return;
        List<SyllabusEditorData.CloItem> list = new ArrayList<>();
        for (int r = sheet.getFirstRowNum() + 1; r <= sheet.getLastRowNum(); r++) {
            String rawCode = value(sheet, r, 0);
            String description = value(sheet, r, 1);
            String code = normalizeSingleClo(rawCode);
            if (code == null && blank(description)) continue;
            SyllabusEditorData.CloItem item = new SyllabusEditorData.CloItem();
            item.setCode(code == null ? "CLO" + (list.size() + 1) : code);
            item.setDescription(description);
            list.add(item);
        }
        data.setClos(list);
    }

    private void parseStudentTasks(Sheet sheet, SyllabusEditorData data) {
        if (sheet == null) return;
        String text = value(sheet, 0, 2);
        List<SyllabusEditorData.TextItem> items = new ArrayList<>();
        for (String line : text.split("\\r?\\n")) {
            String cleaned = line.replaceFirst("^\\s*[-•]\\s*", "").trim();
            if (!cleaned.isEmpty()) items.add(new SyllabusEditorData.TextItem(cleaned));
        }
        data.setStudentTasks(items);
    }

    private void parseResources(Sheet sheet, SyllabusEditorData data) {
        if (sheet == null) return;
        String text = value(sheet, 0, 2);
        List<SyllabusEditorData.ResourceItem> items = new ArrayList<>();
        String currentCategory = "MAIN";
        for (String line : text.split("\\r?\\n")) {
            String cleaned = line.trim();
            if (cleaned.isEmpty()) continue;
            String lower = cleaned.toLowerCase(Locale.ENGLISH);
            if (lower.startsWith("a) main")) { currentCategory = "MAIN"; continue; }
            if (lower.startsWith("b) reference")) { currentCategory = "REFERENCE"; continue; }
            cleaned = cleaned.replaceFirst("^\\d+[.)]\\s*", "");
            SyllabusEditorData.ResourceItem item = new SyllabusEditorData.ResourceItem();
            item.setCategory(currentCategory);
            item.setTitle(cleaned);
            items.add(item);
        }
        data.setLearningResources(items);
    }

    private void parseSchedule(Sheet sheet, SyllabusEditorData data) {
        if (sheet == null) return;
        List<SyllabusEditorData.ScheduleItem> items = new ArrayList<>();
        for (int r = 6; r <= sheet.getLastRowNum(); r++) {
            Integer session = integer(value(sheet, r, 0));
            if (session == null) continue;
            SyllabusEditorData.ScheduleItem item = new SyllabusEditorData.ScheduleItem();
            item.setSessionNumber(session);
            item.setCategory(value(sheet, r, 1));
            item.setTopic(value(sheet, r, 2));
            item.setCloCodes(normalizeCloList(value(sheet, r, 3)));
            item.setItuLevel(value(sheet, r, 4));
            item.setMaterials(value(sheet, r, 5));
            item.setActivities(value(sheet, r, 6));
            items.add(item);
        }
        data.setScheduleItems(items);
    }

    private void parseAssessments(Sheet sheet, SyllabusEditorData data) {
        if (sheet == null) return;
        List<SyllabusEditorData.AssessmentItem> items = new ArrayList<>();
        for (int r = 4; r <= sheet.getLastRowNum(); r++) {
            String category = value(sheet, r, 0);
            if (blank(category)) continue;
            SyllabusEditorData.AssessmentItem item = new SyllabusEditorData.AssessmentItem();
            item.setCategory(category);
            item.setPartNumber(value(sheet, r, 1));
            item.setWeight(decimal(value(sheet, r, 2)));
            item.setDuration(value(sheet, r, 3));
            item.setCloCodes(normalizeCloList(value(sheet, r, 4)));
            item.setQuestionType(value(sheet, r, 5));
            item.setNumberOfQuestions(value(sheet, r, 6));
            item.setKnowledgeScope(value(sheet, r, 7));
            item.setAssessmentMethod(value(sheet, r, 8));
            item.setNote(value(sheet, r, 9));
            items.add(item);
        }
        data.setAssessments(items);
    }

    public String normalizeCloList(String raw) {
        if (blank(raw)) return "";
        List<String> values = new ArrayList<>();
        Matcher matcher = OUTCOME_PATTERN.matcher(raw);
        while (matcher.find()) {
            String code = "CLO" + Integer.parseInt(matcher.group(1));
            if (!values.contains(code)) values.add(code);
        }
        if (raw.matches("(?i).*?(?:C?LO|L)\\s*0*(\\d+)\\s*-\\s*(?:C?LO|L)?\\s*0*(\\d+).*")) {
            Matcher range = Pattern.compile("(?i)(?:C?LO|L)\\s*0*(\\d+)\\s*-\\s*(?:C?LO|L)?\\s*0*(\\d+)").matcher(raw);
            if (range.find()) {
                int start = Integer.parseInt(range.group(1));
                int end = Integer.parseInt(range.group(2));
                for (int i = Math.min(start, end); i <= Math.max(start, end); i++) {
                    String code = "CLO" + i;
                    if (!values.contains(code)) values.add(code);
                }
            }
        }
        return String.join(", ", values);
    }

    private String normalizeSingleClo(String raw) {
        Matcher matcher = OUTCOME_PATTERN.matcher(raw == null ? "" : raw);
        return matcher.find() ? "CLO" + Integer.parseInt(matcher.group(1)) : null;
    }

    private String value(Sheet sheet, int rowIndex, int columnIndex) {
        if (sheet == null) return "";
        Row row = sheet.getRow(rowIndex);
        if (row == null) return "";
        Cell cell = row.getCell(columnIndex);
        return cell == null ? "" : formatter.formatCellValue(cell).trim();
    }

    private Integer integer(String value) {
        try { return blank(value) ? null : (int) Math.round(Double.parseDouble(value.trim())); }
        catch (Exception e) { return null; }
    }

    private Double decimal(String value) {
        try { return blank(value) ? null : Double.parseDouble(value.trim().replace("%", "")) / (value.contains("%") ? 100d : 1d); }
        catch (Exception e) { return null; }
    }

    private boolean blank(String value) { return value == null || value.trim().isEmpty(); }
}
