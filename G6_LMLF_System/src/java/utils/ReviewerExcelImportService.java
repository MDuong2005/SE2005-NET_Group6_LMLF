package utils;

import dao.ReviewerSectionDAO;
import java.io.InputStream;
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

        String contentText = convertSheetToText(sheet, formatter, evaluator);

        sectionDAO.insertSection(
                versionId,
                sectionCode,
                sectionDisplayName,
                contentText,
                displayOrder
        );

        return 1;
    }

    private String convertSheetToText(Sheet sheet,
                                      DataFormatter formatter,
                                      FormulaEvaluator evaluator) {
        StringBuilder sb = new StringBuilder();

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

            StringBuilder rowText = new StringBuilder();

            for (int j = 0; j < lastCell; j++) {
                Cell cell = row.getCell(j);

                String value = "";

                if (cell != null) {
                    value = formatter.formatCellValue(cell, evaluator).trim();
                }

                if (!value.isEmpty()) {
                    if (rowText.length() > 0) {
                        rowText.append(" | ");
                    }

                    rowText.append(value);
                }
            }

            if (rowText.length() > 0) {
                sb.append(rowText).append("\n");
            }
        }

        return sb.toString();
    }
}