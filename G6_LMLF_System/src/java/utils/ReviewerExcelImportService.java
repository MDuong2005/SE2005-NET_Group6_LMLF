package utils;

import dao.ReviewerSectionDAO;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ReviewerExcelImportService {

    private final ReviewerSectionDAO sectionDAO = new ReviewerSectionDAO();

    public int importExcelToVersion(InputStream inputStream, Long versionId) {
        int importedCount = 0;

        try (Workbook workbook = new XSSFWorkbook(inputStream)) {
            DataFormatter formatter = new DataFormatter();
            FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();

            sectionDAO.deleteByVersionId(versionId);

            importedCount += importOneSheet(workbook, formatter, evaluator,
                    versionId, "01_ACADEMIC_INFO", "ACADEMIC_INFO", "Academic Information", 1);

            importedCount += importOneSheet(workbook, formatter, evaluator,
                    versionId, "02_LEARNING_OUTCOMES", "LEARNING_OUTCOMES", "Learning Outcomes", 2);

            importedCount += importOneSheet(workbook, formatter, evaluator,
                    versionId, "03_STUDENT_TASKS", "STUDENT_TASKS", "Student Tasks", 3);

            importedCount += importOneSheet(workbook, formatter, evaluator,
                    versionId, "04_LEARNING_MATERIALS", "LEARNING_MATERIALS", "Learning Materials", 4);

            importedCount += importOneSheet(workbook, formatter, evaluator,
                    versionId, "05_COURSE_SCHEDULE", "COURSE_SCHEDULE", "Course Schedule", 5);

            importedCount += importOneSheet(workbook, formatter, evaluator,
                    versionId, "06_COURSE_ASSESSMENT", "COURSE_ASSESSMENT", "Course Assessment", 6);

            importedCount += importOneSheet(workbook, formatter, evaluator,
                    versionId, "07_ITU_TERM", "ITU_TERM", "ITU Term", 7);

            importedCount += importOneSheet(workbook, formatter, evaluator,
                    versionId, "08_VERSION_INFO", "VERSION_INFO", "Version Information", 8);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return importedCount;
    }

    private int importOneSheet(Workbook workbook,
            DataFormatter formatter,
            FormulaEvaluator evaluator,
            Long versionId,
            String sheetName,
            String sectionCode,
            String sectionDisplayName,
            int displayOrder) {

        Sheet sheet = workbook.getSheet(sheetName);

        if (sheet == null) {
            System.out.println("Missing sheet: " + sheetName);
            return 0;
        }

        String contentHtml = convertSheetToHtmlTable(sheet, formatter, evaluator);

        sectionDAO.insertSection(
                versionId,
                sectionCode,
                sectionDisplayName,
                contentHtml,
                displayOrder
        );

        return 1;
    }

    private String convertSheetToHtmlTable(Sheet sheet,
            DataFormatter formatter,
            FormulaEvaluator evaluator) {

        List<Integer> usedColumns = getUsedColumns(sheet, formatter, evaluator);

        if (usedColumns.isEmpty()) {
            return "";
        }

        StringBuilder html = new StringBuilder();

        html.append("<div class='excel-table-wrapper'>");
        html.append("<table class='excel-table'>");

        html.append("<colgroup>");
        for (Integer colIndex : usedColumns) {
            int widthPx = getColumnWidthPx(sheet, colIndex);
            html.append("<col style='width:")
                    .append(widthPx)
                    .append("px;'>");
        }
        html.append("</colgroup>");

        int lastRow = sheet.getLastRowNum();

        for (int i = 0; i <= lastRow; i++) {
            Row row = sheet.getRow(i);

            if (row == null || isEmptyRowByColumns(row, usedColumns, formatter, evaluator)) {
                continue;
            }

            html.append("<tr>");

            for (Integer colIndex : usedColumns) {
                Cell cell = row.getCell(colIndex);
                String value = "";

                if (cell != null) {
                    value = formatter.formatCellValue(cell, evaluator).trim();
                }

                html.append("<td>")
                        .append(formatCellHtml(value))
                        .append("</td>");
            }

            html.append("</tr>");
        }

        html.append("</table>");
        html.append("</div>");

        return html.toString();
    }

    private List<Integer> getUsedColumns(Sheet sheet,
            DataFormatter formatter,
            FormulaEvaluator evaluator) {
        Set<Integer> seen = new HashSet<>();
        List<Integer> columns = new ArrayList<>();

        int lastRow = sheet.getLastRowNum();

        for (int i = 0; i <= lastRow; i++) {
            Row row = sheet.getRow(i);

            if (row == null) {
                continue;
            }

            short lastCell = row.getLastCellNum();

            if (lastCell < 0) {
                continue;
            }

            for (int j = 0; j < lastCell; j++) {
                Cell cell = row.getCell(j);

                if (cell == null) {
                    continue;
                }

                String value = formatter.formatCellValue(cell, evaluator).trim();

                if (!value.isEmpty() && !seen.contains(j)) {
                    seen.add(j);
                    columns.add(j);
                }
            }
        }

        Collections.sort(columns);
        return columns;
    }

    private int getColumnWidthPx(Sheet sheet, int columnIndex) {
        int excelWidth = sheet.getColumnWidth(columnIndex);

        int px = (int) Math.round((excelWidth / 256.0) * 7);

        if (px < 70) {
            px = 70;
        }

        if (px > 420) {
            px = 420;
        }

        return px;
    }

    private boolean isEmptyRowByColumns(Row row,
            List<Integer> usedColumns,
            DataFormatter formatter,
            FormulaEvaluator evaluator) {
        for (Integer colIndex : usedColumns) {
            Cell cell = row.getCell(colIndex);

            if (cell != null) {
                String value = formatter.formatCellValue(cell, evaluator).trim();

                if (!value.isEmpty()) {
                    return false;
                }
            }
        }

        return true;
    }

    private int countNonEmptyCells(Row row,
            List<Integer> usedColumns,
            DataFormatter formatter,
            FormulaEvaluator evaluator) {
        int count = 0;

        for (Integer colIndex : usedColumns) {
            Cell cell = row.getCell(colIndex);

            if (cell != null) {
                String value = formatter.formatCellValue(cell, evaluator).trim();

                if (!value.isEmpty()) {
                    count++;
                }
            }
        }

        return count;
    }

    private String combineRowText(Row row,
            List<Integer> usedColumns,
            DataFormatter formatter,
            FormulaEvaluator evaluator) {
        StringBuilder sb = new StringBuilder();

        for (Integer colIndex : usedColumns) {
            Cell cell = row.getCell(colIndex);

            if (cell != null) {
                String value = formatter.formatCellValue(cell, evaluator).trim();

                if (!value.isEmpty()) {
                    if (sb.length() > 0) {
                        sb.append(" - ");
                    }

                    sb.append(value);
                }
            }
        }

        return sb.toString();
    }

    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String formatCellHtml(String value) {
        if (value == null) {
            return "";
        }

        String escaped = escapeHtml(value);

        escaped = escaped.replace("\r\n", "\n");
        escaped = escaped.replace("\r", "\n");

        escaped = escaped.replaceAll("\\s+(\\d+\\)\\s)", "<br>$1");
        escaped = escaped.replaceAll("\\s+(a\\)\\s)", "<br>$1");
        escaped = escaped.replaceAll("\\s+(b\\)\\s)", "<br>$1");
        escaped = escaped.replaceAll("\\s+(c\\)\\s)", "<br>$1");

        escaped = escaped.replace("\n", "<br>");

        return escaped;
    }
}
