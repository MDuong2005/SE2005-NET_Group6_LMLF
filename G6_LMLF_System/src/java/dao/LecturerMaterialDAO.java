package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.LecturerMaterial;
import context.DBContext;

public class LecturerMaterialDAO extends DBContext {

    public void addMaterial(LecturerMaterial material) {
        String sql = "INSERT INTO lecturer_materials (course_id, lecturer_id, title, file_url, category, material_type) VALUES (?, ?, ?, ?, ?, ?)";
        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setLong(1, material.getCourseId());
                ps.setLong(2, material.getLecturerId());
                ps.setString(3, material.getTitle());
                ps.setString(4, material.getFileUrl());
                ps.setString(5, material.getCategory());
                ps.setString(6, material.getMaterialType());
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<LecturerMaterial> getMyMaterials(long lecturerId) {
        return getMyMaterials(lecturerId, "", "");
    }

    public List<LecturerMaterial> getMyMaterials(
            long lecturerId,
            String search,
            String category) {
        List<LecturerMaterial> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM lecturer_materials WHERE lecturer_id = ?"
        );
        boolean hasSearch = search != null && !search.trim().isEmpty();
        boolean hasCategory = category != null && !category.trim().isEmpty();

        if (hasSearch) {
            sql.append(" AND title LIKE ?");
        }
        if (hasCategory) {
            sql.append(" AND category = ?");
        }
        sql.append(" ORDER BY uploaded_at DESC");

        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
                int paramIndex = 1;
                ps.setLong(paramIndex++, lecturerId);
                if (hasSearch) {
                    ps.setString(paramIndex++, "%" + search.trim() + "%");
                }
                if (hasCategory) {
                    ps.setString(paramIndex, category.trim());
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        LecturerMaterial m = new LecturerMaterial();
                        m.setLecturerMaterialId(rs.getLong("lecturer_material_id"));
                        m.setCourseId(rs.getLong("course_id"));
                        m.setLecturerId(rs.getLong("lecturer_id"));
                        m.setTitle(rs.getString("title"));
                        m.setFileUrl(rs.getString("file_url"));
                        m.setUploadedAt(rs.getTimestamp("uploaded_at"));
                        m.setCategory(rs.getString("category"));
                        m.setMaterialType(rs.getString("material_type"));
                        list.add(m);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    public List<LecturerMaterial> getRecentMaterials(long lecturerId, int limit) {
        List<LecturerMaterial> list = new ArrayList<>();

        if (connection == null || lecturerId <= 0) {
            return list;
        }

        int safeLimit = Math.max(1, Math.min(limit, 20));
        String sql = "SELECT TOP (?) * FROM lecturer_materials "
                + "WHERE lecturer_id = ? ORDER BY uploaded_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, safeLimit);
            ps.setLong(2, lecturerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LecturerMaterial material = new LecturerMaterial();
                    material.setLecturerMaterialId(rs.getLong("lecturer_material_id"));
                    material.setCourseId(rs.getLong("course_id"));
                    material.setLecturerId(rs.getLong("lecturer_id"));
                    material.setTitle(rs.getString("title"));
                    material.setFileUrl(rs.getString("file_url"));
                    material.setUploadedAt(rs.getTimestamp("uploaded_at"));
                    material.setCategory(rs.getString("category"));
                    material.setMaterialType(rs.getString("material_type"));
                    list.add(material);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<LecturerMaterial> getSharedWithMe(String myEmail) {
        return getSharedWithMe(myEmail, "", "");
    }

    public List<LecturerMaterial> getSharedWithMe(
            String myEmail,
            String search,
            String category) {
        List<LecturerMaterial> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT lm.*, u.email as shared_by_email, sm.shared_at "
                + "FROM lecturer_materials lm "
                + "JOIN shared_materials sm ON lm.lecturer_material_id = sm.material_id "
                + "JOIN users u ON lm.lecturer_id = u.user_id "
                + "WHERE sm.shared_with_email = ?"
        );
        boolean hasSearch = search != null && !search.trim().isEmpty();
        boolean hasCategory = category != null && !category.trim().isEmpty();

        if (hasSearch) {
            sql.append(" AND lm.title LIKE ?");
        }
        if (hasCategory) {
            sql.append(" AND lm.category = ?");
        }
        sql.append(" ORDER BY sm.shared_at DESC");

        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
                int paramIndex = 1;
                ps.setString(paramIndex++, myEmail);
                if (hasSearch) {
                    ps.setString(paramIndex++, "%" + search.trim() + "%");
                }
                if (hasCategory) {
                    ps.setString(paramIndex, category.trim());
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        LecturerMaterial m = new LecturerMaterial();
                        m.setLecturerMaterialId(rs.getLong("lecturer_material_id"));
                        m.setCourseId(rs.getLong("course_id"));
                        m.setLecturerId(rs.getLong("lecturer_id"));
                        m.setTitle(rs.getString("title"));
                        m.setFileUrl(rs.getString("file_url"));
                        m.setUploadedAt(rs.getTimestamp("uploaded_at"));
                        m.setCategory(rs.getString("category"));
                        m.setMaterialType(rs.getString("material_type"));
                        m.setSharedByEmail(rs.getString("shared_by_email"));
                        m.setSharedAt(rs.getTimestamp("shared_at"));
                        list.add(m);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    public List<String> getAvailableCategories(
            long lecturerId,
            String email,
            boolean sharedTab) {
        List<String> categories = new ArrayList<>();
        String sql;

        if (sharedTab) {
            sql = """
                SELECT DISTINCT lm.category
                FROM lecturer_materials lm
                JOIN shared_materials sm
                  ON sm.material_id = lm.lecturer_material_id
                WHERE sm.shared_with_email = ?
                  AND lm.category IS NOT NULL
                  AND LTRIM(RTRIM(lm.category)) <> ''
                ORDER BY lm.category
            """;
        } else {
            sql = """
                SELECT DISTINCT category
                FROM lecturer_materials
                WHERE lecturer_id = ?
                  AND category IS NOT NULL
                  AND LTRIM(RTRIM(category)) <> ''
                ORDER BY category
            """;
        }

        if (connection == null) {
            return categories;
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (sharedTab) {
                ps.setString(1, email);
            } else {
                ps.setLong(1, lecturerId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    categories.add(rs.getString(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Courses available to the Lecturer material upload form.
     */
    public List<Map<String, Object>> getAvailableCourses() {
        List<Map<String, Object>> courses = new ArrayList<>();
        String sql = """
                SELECT course_id, code, name
                FROM courses
                WHERE deleted_at IS NULL
                ORDER BY code
                """;

        if (connection == null) {
            return courses;
        }

        try (PreparedStatement statement
                     = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put(
                        "courseId",
                        resultSet.getLong("course_id")
                );
                course.put("code", resultSet.getString("code"));
                course.put("name", resultSet.getString("name"));
                courses.add(course);
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return courses;
    }

    public boolean courseExists(long courseId) {
        String sql = """
                SELECT 1
                FROM courses
                WHERE course_id = ?
                  AND deleted_at IS NULL
                """;

        if (connection == null || courseId <= 0) {
            return false;
        }

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, courseId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
            return false;
        }
    }

    /**
     * Resolves a Lecturer account inside the Lecturer material boundary.
     * Email-or-username matching is retained for parity with the old flow.
     */
    public String findLecturerEmail(String emailOrUsername) {
        String sql = """
                SELECT TOP (1) userAccount.email
                FROM users userAccount
                INNER JOIN user_roles userRole
                    ON userRole.user_id = userAccount.user_id
                INNER JOIN roles roleRow
                    ON roleRow.role_id = userRole.role_id
                WHERE (
                        userAccount.email = ?
                        OR userAccount.username = ?
                      )
                  AND roleRow.role_name = 'LECTURER'
                """;

        if (connection == null
                || emailOrUsername == null
                || emailOrUsername.trim().isEmpty()) {
            return null;
        }

        String normalized = emailOrUsername.trim();

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setString(1, normalized);
            statement.setString(2, normalized);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next()
                        ? resultSet.getString("email")
                        : null;
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
            return null;
        }
    }

    /**
     * Share a material with another lecturer.
     *
     * Ownership is enforced in the same statement: the row is only inserted when
     * the material actually belongs to {@code ownerId}. This closes the IDOR where
     * a lecturer could share another lecturer's material by changing materialId.
     * Returns false if the material is not owned by the caller (nothing inserted).
     */
    public boolean shareMaterial(long materialId, String email, long ownerId) {
        String sql = "INSERT INTO shared_materials (material_id, shared_with_email) "
                   + "SELECT ?, ? WHERE EXISTS ("
                   + "  SELECT 1 FROM lecturer_materials "
                   + "  WHERE lecturer_material_id = ? AND lecturer_id = ?)";
        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setLong(1, materialId);
                ps.setString(2, email);
                ps.setLong(3, materialId);
                ps.setLong(4, ownerId);
                int rows = ps.executeUpdate();
                return rows > 0;
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }
        return false;
    }

    public void deleteMaterial(long materialId, long lecturerId) {
        String sql = "DELETE FROM lecturer_materials WHERE lecturer_material_id = ? AND lecturer_id = ?";
        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setLong(1, materialId);
                ps.setLong(2, lecturerId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public LecturerMaterial getMaterialById(long materialId) {
        if (connection == null || materialId <= 0) {
            return null;
        }
        String sql = "SELECT * FROM lecturer_materials WHERE lecturer_material_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, materialId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LecturerMaterial m = new LecturerMaterial();
                    m.setLecturerMaterialId(rs.getLong("lecturer_material_id"));
                    m.setCourseId(rs.getLong("course_id"));
                    m.setLecturerId(rs.getLong("lecturer_id"));
                    m.setTitle(rs.getString("title"));
                    m.setFileUrl(rs.getString("file_url"));
                    m.setUploadedAt(rs.getTimestamp("uploaded_at"));
                    m.setCategory(rs.getString("category"));
                    m.setMaterialType(rs.getString("material_type"));
                    return m;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
