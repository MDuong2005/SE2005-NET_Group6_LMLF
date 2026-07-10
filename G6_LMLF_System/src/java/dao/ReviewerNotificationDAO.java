package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ReviewerNotificationDAO extends DBContext {

    public Long getDesignerIdByVersionId(long versionId) {
        String sql
                = "SELECT TOP 1 sa.designer_id "
                + "FROM syllabus_assignments sa "
                + "JOIN syllabus_versions sv ON sa.syllabus_id = sv.syllabus_id "
                + "WHERE sv.version_id = ? "
                + "  AND sa.designer_id IS NOT NULL "
                + "ORDER BY "
                + "  CASE WHEN sa.submitted_version_id = ? THEN 0 ELSE 1 END, "
                + "  sa.assignment_id DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);
            ps.setLong(2, versionId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getLong("designer_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return getDesignerIdFromVersionCreator(versionId);
    }

    private Long getDesignerIdFromVersionCreator(long versionId) {
        String sql
                = "SELECT created_by "
                + "FROM syllabus_versions "
                + "WHERE version_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, versionId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getLong("created_by");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean createReviewCompletedNotification(long versionId,
            long reviewerId,
            String decision) {
        Long designerId = getDesignerIdByVersionId(versionId);

        if (designerId == null) {
            System.out.println("Cannot create notification. Designer not found for versionId = " + versionId);
            return false;
        }

        String subject = "Syllabus review completed";
        String body = "Your submitted syllabus version has been reviewed. Please check reviewer comments.";

        if ("REJECTED".equalsIgnoreCase(decision)) {
            subject = "Syllabus rejected";
            body = "Your submitted syllabus version was rejected. Please check reviewer comments and revise it.";
        } else if ("APPROVED".equalsIgnoreCase(decision)) {
            subject = "Syllabus approved";
            body = "Your submitted syllabus version was approved by reviewer.";
        } else if ("APPROVED_WITH_COMMENT".equalsIgnoreCase(decision)) {
            subject = "Syllabus approved with comments";
            body = "Your submitted syllabus version was approved with comments. Please check reviewer feedback.";
        }

        String sql
                = "INSERT INTO notifications "
                + "(recipient_id, triggered_by, notification_type, related_entity_type, related_entity_id, "
                + " subject, body, channel, status, sent_at, is_read) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 'IN_APP', 'SENT', SYSDATETIME(), 0)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setLong(1, designerId);
            ps.setLong(2, reviewerId);
            ps.setString(3, "REVIEW_COMPLETED");
            ps.setString(4, "SYLLABUS_VERSION");
            ps.setLong(5, versionId);
            ps.setString(6, subject);
            ps.setString(7, body);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean notifyAcademicWhenAllReviewersApproved(long versionId, long reviewerId) {
        String findAcademicSql
                = "SELECT DISTINCT u.user_id "
                + "FROM users u "
                + "JOIN user_roles ur ON u.user_id = ur.user_id "
                + "JOIN roles r ON ur.role_id = r.role_id "
                + "WHERE r.role_name = 'ACADEMIC_OFFICE' "
                + "  AND u.status = 'ACTIVE'";

        String insertSql
                = "INSERT INTO notifications "
                + "(recipient_id, triggered_by, notification_type, related_entity_type, related_entity_id, "
                + " subject, body, channel, status, sent_at, is_read) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 'IN_APP', 'SENT', SYSDATETIME(), 0)";

        boolean created = false;

        try {
            PreparedStatement psFind = connection.prepareStatement(findAcademicSql);
            ResultSet rs = psFind.executeQuery();

            while (rs.next()) {
                long academicId = rs.getLong("user_id");

                PreparedStatement psInsert = connection.prepareStatement(insertSql);
                psInsert.setLong(1, academicId);
                psInsert.setLong(2, reviewerId);
                psInsert.setString(3, "SYLLABUS_READY_FOR_ACADEMIC");
                psInsert.setString(4, "SYLLABUS_VERSION");
                psInsert.setLong(5, versionId);
                psInsert.setString(6, "Syllabus ready for Academic submission");
                psInsert.setString(7, "All assigned reviewers have approved this syllabus version. Please check and submit or publish it.");
                psInsert.executeUpdate();
                psInsert.close();

                created = true;
            }

            rs.close();
            psFind.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return created;
    }

    public boolean notifyDesignerAfterReview(Long versionId, Long reviewerId, String finalDecision) {
        Long designerId = getDesignerIdByVersionId(versionId);

        if (designerId == null) {
            System.out.println("Cannot notify designer. Designer not found for versionId = " + versionId);
            return false;
        }

        String subject = "Syllabus review completed";
        String body = "Your submitted syllabus version has been reviewed. Please check reviewer comments.";

        if ("REJECTED".equalsIgnoreCase(finalDecision)) {
            subject = "Syllabus rejected";
            body = "Your submitted syllabus version was rejected. Please check reviewer comments and revise it.";
        } else if ("APPROVED".equalsIgnoreCase(finalDecision)) {
            subject = "Syllabus approved";
            body = "Your submitted syllabus version was approved.";
        } else if ("APPROVED_WITH_COMMENT".equalsIgnoreCase(finalDecision)) {
            subject = "Syllabus approved with comments";
            body = "Your submitted syllabus version was approved with comments. Please check reviewer feedback.";
        }

        String sql
                = "INSERT INTO notifications "
                + "(recipient_id, triggered_by, notification_type, related_entity_type, related_entity_id, "
                + " subject, body, channel, status, sent_at, is_read) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 'IN_APP', 'SENT', SYSDATETIME(), 0)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setLong(1, designerId);
            ps.setLong(2, reviewerId);
            ps.setString(3, "REVIEW_COMPLETED");
            ps.setString(4, "SYLLABUS_VERSION");
            ps.setLong(5, versionId);
            ps.setString(6, subject);
            ps.setString(7, body);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
