package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.StudentLearningPathCourse;
import model.StudentLearningPathResult;

/** Read-only learning-path queries owned by the Student module. */
public class StudentLearningPathDAO extends DBContext {

    public List<StudentLearningPathResult> searchBySubjectCode(String subjectCode) {
        List<StudentLearningPathResult> results = new ArrayList<>();
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
                    StudentLearningPathResult item = new StudentLearningPathResult();
                    long syllabusId = result.getLong("syllabus_id");
                    item.setSyllabusId(result.wasNull() ? null : syllabusId);
                    item.setCourseId(result.getLong("course_id"));
                    item.setSubjectCode(result.getString("subject_code"));
                    item.setSyllabusName(result.getString("syllabus_name"));
                    item.setDecisionInformation(result.getString("decision_information"));
                    results.add(item);
                }
            }

            if (!results.isEmpty()) {
                List<StudentLearningPathCourse> prerequisites
                        = findTransitivePrerequisites(results.get(0).getCourseId());
                for (StudentLearningPathResult item : results) {
                    item.setPrerequisites(prerequisites);
                }
            }
            return results;
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to search the Student learning path.", exception);
        }
    }

    private List<StudentLearningPathCourse> findTransitivePrerequisites(long targetCourseId)
            throws SQLException {
        List<StudentLearningPathCourse> prerequisites = new ArrayList<>();
        String sql = """
                WITH prerequisiteTree AS (
                    SELECT relation.prerequisite_course_id AS required_course_id,
                           1 AS path_depth,
                           CAST(
                               '|' + CONVERT(VARCHAR(20), ?) + '|'
                               + CONVERT(VARCHAR(20), relation.prerequisite_course_id) + '|'
                               AS VARCHAR(MAX)
                           ) AS visited_path
                    FROM course_prerequisites relation
                    WHERE relation.course_id = ?

                    UNION ALL

                    SELECT relation.prerequisite_course_id,
                           tree.path_depth + 1,
                           CAST(
                               tree.visited_path
                               + CONVERT(VARCHAR(20), relation.prerequisite_course_id) + '|'
                               AS VARCHAR(MAX)
                           )
                    FROM prerequisiteTree tree
                    INNER JOIN course_prerequisites relation
                        ON relation.course_id = tree.required_course_id
                    WHERE CHARINDEX(
                              '|' + CONVERT(VARCHAR(20), relation.prerequisite_course_id) + '|',
                              tree.visited_path
                          ) = 0
                ), requiredCourses AS (
                    SELECT required_course_id, MAX(path_depth) AS path_depth
                    FROM prerequisiteTree
                    GROUP BY required_course_id
                )
                SELECT course.course_id,
                       course.code,
                       course.name,
                       required.path_depth,
                       directPrerequisites.direct_codes
                FROM requiredCourses required
                INNER JOIN courses course ON course.course_id = required.required_course_id
                OUTER APPLY (
                    SELECT STRING_AGG(directCourse.code, ', ')
                               WITHIN GROUP (ORDER BY directCourse.code) AS direct_codes
                    FROM course_prerequisites directRelation
                    INNER JOIN courses directCourse
                        ON directCourse.course_id = directRelation.prerequisite_course_id
                    WHERE directRelation.course_id = course.course_id
                      AND directCourse.deleted_at IS NULL
                ) directPrerequisites
                WHERE course.deleted_at IS NULL
                ORDER BY required.path_depth DESC, course.code
                OPTION (MAXRECURSION 100)
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, targetCourseId);
            statement.setLong(2, targetCourseId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    prerequisites.add(new StudentLearningPathCourse(
                            result.getLong("course_id"),
                            result.getString("code"),
                            result.getString("name"),
                            result.getInt("path_depth"),
                            result.getString("direct_codes")
                    ));
                }
            }
        }
        return prerequisites;
    }
}
