package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.StudentDependentCourse;
import model.StudentPrerequisiteResult;

/** Read-only reverse prerequisite queries owned by the Student module. */
public class StudentPrerequisiteDAO extends DBContext {

    public List<StudentPrerequisiteResult> searchBySubjectCode(String subjectCode) {
        List<StudentPrerequisiteResult> results = new ArrayList<>();
        String sql = """
                SELECT publishedSyllabus.syllabus_id,
                       course.course_id,
                       course.code AS subject_code,
                       course.name AS syllabus_name,
                       COALESCE(decision.decision_information, 'N/A') AS decision_information
                FROM courses course
                CROSS APPLY (
                    SELECT TOP 1 syllabus.syllabus_id
                    FROM syllabuses syllabus
                    INNER JOIN syllabus_versions versionRow
                        ON versionRow.syllabus_id = syllabus.syllabus_id
                       AND versionRow.version_number = syllabus.current_version
                       AND versionRow.status = 'PUBLISHED'
                    WHERE syllabus.course_id = course.course_id
                      AND syllabus.deleted_at IS NULL
                      AND syllabus.status = 'PUBLISHED'
                    ORDER BY syllabus.updated_at DESC, syllabus.syllabus_id DESC
                ) publishedSyllabus
                OUTER APPLY (
                    SELECT TOP 1
                           CONCAT(
                               curriculum.decision_no,
                               CASE
                                   WHEN curriculum.issued_date IS NULL THEN ''
                                   ELSE CONCAT(' dated ', CONVERT(VARCHAR(10), curriculum.issued_date, 101))
                               END
                           ) AS decision_information
                    FROM curriculum_courses curriculumCourse
                    INNER JOIN curriculums curriculum
                        ON curriculum.curriculum_id = curriculumCourse.curriculum_id
                    WHERE curriculumCourse.course_id = course.course_id
                      AND curriculum.deleted_at IS NULL
                      AND curriculum.is_active = 1
                    ORDER BY curriculum.issued_date DESC, curriculum.curriculum_id DESC
                ) decision
                WHERE UPPER(course.code) = UPPER(?)
                  AND course.deleted_at IS NULL
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, subjectCode);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    StudentPrerequisiteResult item = new StudentPrerequisiteResult();
                    item.setSyllabusId(result.getLong("syllabus_id"));
                    item.setCourseId(result.getLong("course_id"));
                    item.setSubjectCode(result.getString("subject_code"));
                    item.setSyllabusName(result.getString("syllabus_name"));
                    item.setDecisionInformation(result.getString("decision_information"));
                    results.add(item);
                }
            }

            if (!results.isEmpty()) {
                List<StudentDependentCourse> dependentCourses
                        = findDirectDependentCourses(results.get(0).getCourseId());
                for (StudentPrerequisiteResult item : results) {
                    item.setDependentCourses(dependentCourses);
                }
            }
            return results;
        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Unable to search reverse prerequisites for the Student module.",
                    exception
            );
        }
    }

    private List<StudentDependentCourse> findDirectDependentCourses(long prerequisiteCourseId)
            throws SQLException {
        List<StudentDependentCourse> dependentCourses = new ArrayList<>();
        String sql = """
                SELECT dependent.course_id,
                       dependent.code,
                       dependent.name
                FROM course_prerequisites relation
                INNER JOIN courses dependent
                    ON dependent.course_id = relation.course_id
                WHERE relation.prerequisite_course_id = ?
                  AND dependent.deleted_at IS NULL
                ORDER BY dependent.code
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, prerequisiteCourseId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    dependentCourses.add(new StudentDependentCourse(
                            result.getLong("course_id"),
                            result.getString("code"),
                            result.getString("name")
                    ));
                }
            }
        }
        return dependentCourses;
    }
}
