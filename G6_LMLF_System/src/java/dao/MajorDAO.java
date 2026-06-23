package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Major;

public class MajorDAO extends DBContext {
    
public List<Major> getAllMajors() {

    List<Major> list = new ArrayList<>();

    String sql = """
            SELECT *
            FROM majors
            ORDER BY major_id DESC
            """;

    try {

        PreparedStatement ps =
                connection.prepareStatement(sql);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            Major major = extractMajor(rs);

            list.add(major);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

public Major getMajorById(long id) {

    String sql = """
            SELECT *
            FROM majors
            WHERE major_id = ?
            """;

    try {

        PreparedStatement ps =
                connection.prepareStatement(sql);

        ps.setLong(1, id);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return extractMajor(rs);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}

public boolean addMajor(Major major) {

    String sql = """
            INSERT INTO majors
            (
                code,
                name,
                description,
                created_by,
                created_at
            )
            VALUES
            (
                ?, ?, ?, ?, GETDATE()
            )
            """;

    try {

        PreparedStatement ps =
                connection.prepareStatement(sql);

        ps.setString(1, major.getCode());
        ps.setString(2, major.getName());
        ps.setString(3, major.getDescription());

        if (major.getCreatedBy() == null) {
            ps.setNull(4, java.sql.Types.BIGINT);
        } else {
            ps.setLong(4, major.getCreatedBy());
        }

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }

    return false;
}

public boolean updateMajor(Major major) {

    String sql = """
            UPDATE majors
            SET code = ?,
                name = ?,
                description = ?
            WHERE major_id = ?
            """;

    try {

        PreparedStatement ps =
                connection.prepareStatement(sql);

        ps.setString(1, major.getCode());
        ps.setString(2, major.getName());
        ps.setString(3, major.getDescription());
        ps.setLong(4, major.getMajorId());

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }

    return false;
}

public boolean deleteMajor(long majorId) {

    String sql = """
            DELETE FROM majors
            WHERE major_id = ?
            """;

    try {

        PreparedStatement ps =
                connection.prepareStatement(sql);

        ps.setLong(1, majorId);

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }

    return false;
}

public List<Major> searchMajor(String keyword) {

    List<Major> list = new ArrayList<>();

    String sql = """
            SELECT *
            FROM majors
            WHERE code LIKE ?
               OR name LIKE ?
            ORDER BY major_id DESC
            """;

    try {

        PreparedStatement ps =
                connection.prepareStatement(sql);

        String search =
                "%" + keyword + "%";

        ps.setString(1, search);
        ps.setString(2, search);

        ResultSet rs =
                ps.executeQuery();

        while (rs.next()) {

            Major major =
                    extractMajor(rs);

            list.add(major);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

public boolean isCodeExists(String code) {

    String sql = """
            SELECT 1
            FROM majors
            WHERE code = ?
            """;

    try {

        PreparedStatement ps =
                connection.prepareStatement(sql);

        ps.setString(1, code);

        ResultSet rs =
                ps.executeQuery();

        return rs.next();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return false;
}

public boolean isCodeExists(
        String code,
        long excludeId) {

    String sql = """
            SELECT 1
            FROM majors
            WHERE code = ?
            AND major_id <> ?
            """;

    try {

        PreparedStatement ps =
                connection.prepareStatement(sql);

        ps.setString(1, code);
        ps.setLong(2, excludeId);

        ResultSet rs =
                ps.executeQuery();

        return rs.next();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return false;
}

public boolean isUsedByCurriculum(
        long majorId) {

    String sql = """
            SELECT 1
            FROM curriculums
            WHERE major_id = ?
            """;

    try {

        PreparedStatement ps =
                connection.prepareStatement(sql);

        ps.setLong(1, majorId);

        ResultSet rs =
                ps.executeQuery();

        return rs.next();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return true;
}

private Major extractMajor(
        ResultSet rs) throws Exception {

    Major major = new Major();

    major.setMajorId(
            rs.getLong("major_id"));

    major.setCode(
            rs.getString("code"));

    major.setName(
            rs.getString("name"));

    major.setDescription(
            rs.getString("description"));

    major.setCreatedBy(
            (Long) rs.getObject("created_by"));

    major.setCreatedAt(
            rs.getTimestamp("created_at"));

    return major;
}
}
