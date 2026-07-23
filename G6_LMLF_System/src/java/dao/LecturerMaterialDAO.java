package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
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
        List<LecturerMaterial> list = new ArrayList<>();
        String sql = "SELECT * FROM lecturer_materials WHERE lecturer_id = ? ORDER BY uploaded_at DESC";
        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setLong(1, lecturerId);
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
        List<LecturerMaterial> list = new ArrayList<>();
        String sql = "SELECT lm.*, u.email as shared_by_email, sm.shared_at " +
                     "FROM lecturer_materials lm " +
                     "JOIN shared_materials sm ON lm.lecturer_material_id = sm.material_id " +
                     "JOIN users u ON lm.lecturer_id = u.user_id " +
                     "WHERE sm.shared_with_email = ? ORDER BY sm.shared_at DESC";
        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, myEmail);
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

    public boolean shareMaterial(long materialId, String email) {
        String sql = "INSERT INTO shared_materials (material_id, shared_with_email) VALUES (?, ?)";
        if (connection != null) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setLong(1, materialId);
                ps.setString(2, email);
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
}
