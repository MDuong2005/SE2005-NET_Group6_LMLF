package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Read-only curriculum queries for the Student module.
 *
 * Every entry point enforces the Student visibility rule at query level:
 * only active, non-deleted curricula may be returned.
 */
public class StudentCurriculumDAO extends DBContext {

    public int countVisibleCurriculums(String search) {
        StringBuilder sql = new StringBuilder("""
                SELECT COUNT(*)
                FROM curriculums curriculum
                INNER JOIN majors major ON major.major_id = curriculum.major_id
                WHERE curriculum.deleted_at IS NULL
                  AND curriculum.is_active = 1
                """);
        boolean hasSearch = hasText(search);
        if (hasSearch) {
            sql.append(" AND (curriculum.name LIKE ? OR curriculum.curriculum_code LIKE ? OR major.name LIKE ?) ");
        }

        try (PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            if (hasSearch) {
                String pattern = "%" + search.trim() + "%";
                statement.setString(1, pattern);
                statement.setString(2, pattern);
                statement.setString(3, pattern);
            }
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? result.getInt(1) : 0;
            }
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to count visible curricula.", exception);
        }
    }

    public List<Map<String, Object>> findVisibleCurriculums(
            String search,
            int page,
            int pageSize
    ) {
        List<Map<String, Object>> curriculums = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                SELECT curriculum.curriculum_id,
                       curriculum.curriculum_code,
                       curriculum.name AS curriculum_name,
                       major.code AS major_code,
                       major.name AS major_name,
                       curriculum.version,
                       curriculum.description,
                       curriculum.decision_no,
                       curriculum.total_credits,
                       curriculum.total_semesters,
                       curriculum.issued_date
                FROM curriculums curriculum
                INNER JOIN majors major ON major.major_id = curriculum.major_id
                WHERE curriculum.deleted_at IS NULL
                  AND curriculum.is_active = 1
                """);
        boolean hasSearch = hasText(search);
        if (hasSearch) {
            sql.append(" AND (curriculum.name LIKE ? OR curriculum.curriculum_code LIKE ? OR major.name LIKE ?) ");
        }
        sql.append(" ORDER BY curriculum.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        try (PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (hasSearch) {
                String pattern = "%" + search.trim() + "%";
                statement.setString(index++, pattern);
                statement.setString(index++, pattern);
                statement.setString(index++, pattern);
            }
            statement.setInt(index++, (page - 1) * pageSize);
            statement.setInt(index, pageSize);

            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    curriculums.add(mapCurriculum(result));
                }
            }
            return curriculums;
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to load visible curricula.", exception);
        }
    }

    public Map<String, Object> findVisibleCurriculum(long curriculumId) {
        String sql = """
                SELECT curriculum.curriculum_id,
                       curriculum.curriculum_code,
                       curriculum.name AS curriculum_name,
                       major.code AS major_code,
                       major.name AS major_name,
                       curriculum.version,
                       curriculum.description,
                       curriculum.decision_no,
                       curriculum.total_credits,
                       curriculum.total_semesters,
                       curriculum.issued_date
                FROM curriculums curriculum
                INNER JOIN majors major ON major.major_id = curriculum.major_id
                WHERE curriculum.curriculum_id = ?
                  AND curriculum.deleted_at IS NULL
                  AND curriculum.is_active = 1
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, curriculumId);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? mapCurriculum(result) : null;
            }
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to load the visible curriculum.", exception);
        }
    }

    public List<Map<String, Object>> findPlos(long curriculumId) {
        String sql = """
                SELECT plo.plo_id, plo.code, plo.description
                FROM curriculum_plos plo
                INNER JOIN curriculums curriculum ON curriculum.curriculum_id = plo.curriculum_id
                WHERE plo.curriculum_id = ?
                  AND curriculum.deleted_at IS NULL
                  AND curriculum.is_active = 1
                ORDER BY plo.plo_id
                """;
        return findOutcomes(sql, curriculumId, "ploId", "plo_id");
    }

    public List<Map<String, Object>> findPos(long curriculumId) {
        String sql = """
                SELECT po.po_id, po.code, po.description
                FROM curriculum_pos po
                INNER JOIN curriculums curriculum ON curriculum.curriculum_id = po.curriculum_id
                WHERE po.curriculum_id = ?
                  AND curriculum.deleted_at IS NULL
                  AND curriculum.is_active = 1
                ORDER BY po.po_id
                """;
        return findOutcomes(sql, curriculumId, "poId", "po_id");
    }

    public List<Map<String, Object>> findSubjects(long curriculumId) {
        List<Map<String, Object>> subjects = new ArrayList<>();
        String sql = """
                SELECT course.code,
                       course.name,
                       curriculumCourse.semester,
                       course.credits,
                       curriculumCourse.knowledge_block,
                       (
                           SELECT STRING_AGG(prerequisite.code, ', ')
                           FROM course_prerequisites relation
                           INNER JOIN courses prerequisite
                               ON prerequisite.course_id = relation.prerequisite_course_id
                           WHERE relation.course_id = course.course_id
                       ) AS prerequisites
                FROM curriculum_courses curriculumCourse
                INNER JOIN curriculums curriculum
                    ON curriculum.curriculum_id = curriculumCourse.curriculum_id
                INNER JOIN courses course ON course.course_id = curriculumCourse.course_id
                WHERE curriculumCourse.curriculum_id = ?
                  AND curriculum.deleted_at IS NULL
                  AND curriculum.is_active = 1
                ORDER BY curriculumCourse.semester, course.code
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, curriculumId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    Map<String, Object> subject = new HashMap<>();
                    subject.put("code", result.getString("code"));
                    subject.put("name", result.getString("name"));
                    subject.put("semester", result.getInt("semester"));
                    subject.put("credits", result.getInt("credits"));
                    subject.put("knowledgeBlock", result.getString("knowledge_block"));
                    subject.put("prerequisites", result.getString("prerequisites"));
                    subjects.add(subject);
                }
            }
            return subjects;
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to load curriculum subjects.", exception);
        }
    }

    public Set<String> findCoursePloMappings(long curriculumId) {
        Set<String> mappings = new HashSet<>();
        String sql = """
                SELECT course.code AS course_code, plo.code AS plo_code
                FROM curriculum_course_plo_mappings mapping
                INNER JOIN curriculums curriculum
                    ON curriculum.curriculum_id = mapping.curriculum_id
                INNER JOIN courses course ON course.course_id = mapping.course_id
                INNER JOIN curriculum_plos plo ON plo.plo_id = mapping.plo_id
                WHERE mapping.curriculum_id = ?
                  AND curriculum.deleted_at IS NULL
                  AND curriculum.is_active = 1
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, curriculumId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    mappings.add(result.getString("course_code") + "|" + result.getString("plo_code"));
                }
            }
            return mappings;
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to load course-PLO mappings.", exception);
        }
    }

    public Set<String> findPloPoMappings(long curriculumId) {
        Set<String> mappings = new HashSet<>();
        String sql = """
                SELECT plo.code AS plo_code, po.code AS po_code
                FROM curriculum_plo_po_mappings mapping
                INNER JOIN curriculum_plos plo ON plo.plo_id = mapping.plo_id
                INNER JOIN curriculum_pos po ON po.po_id = mapping.po_id
                INNER JOIN curriculums curriculum ON curriculum.curriculum_id = plo.curriculum_id
                WHERE plo.curriculum_id = ?
                  AND po.curriculum_id = ?
                  AND curriculum.deleted_at IS NULL
                  AND curriculum.is_active = 1
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, curriculumId);
            statement.setLong(2, curriculumId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    mappings.add(result.getString("plo_code") + "|" + result.getString("po_code"));
                }
            }
            return mappings;
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to load PLO-PO mappings.", exception);
        }
    }

    private List<Map<String, Object>> findOutcomes(
            String sql,
            long curriculumId,
            String idKey,
            String idColumn
    ) {
        List<Map<String, Object>> outcomes = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, curriculumId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    Map<String, Object> outcome = new HashMap<>();
                    outcome.put(idKey, result.getLong(idColumn));
                    outcome.put("code", result.getString("code"));
                    outcome.put("description", result.getString("description"));
                    outcomes.add(outcome);
                }
            }
            return outcomes;
        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to load curriculum outcomes.", exception);
        }
    }

    private Map<String, Object> mapCurriculum(ResultSet result) throws SQLException {
        Map<String, Object> curriculum = new HashMap<>();
        curriculum.put("curriculumId", result.getLong("curriculum_id"));
        curriculum.put("curriculumCode", result.getString("curriculum_code"));
        curriculum.put("curriculumName", result.getString("curriculum_name"));
        curriculum.put("majorCode", result.getString("major_code"));
        curriculum.put("majorName", result.getString("major_name"));
        curriculum.put("version", result.getString("version"));
        curriculum.put("description", result.getString("description"));
        curriculum.put("decisionNo", result.getString("decision_no"));
        curriculum.put("totalCredits", result.getInt("total_credits"));
        curriculum.put("totalSemesters", result.getInt("total_semesters"));
        curriculum.put("issuedDate", result.getTimestamp("issued_date"));
        return curriculum;
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
