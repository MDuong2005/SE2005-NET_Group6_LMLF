package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ReviewerNotificationDAO extends DBContext {

    public Long getDesignerIdByVersionId(
            long versionId
    ) {
        String sql = """
                SELECT TOP 1 assignment.designer_id
                FROM syllabus_versions version
                INNER JOIN syllabus_assignments assignment
                    ON assignment.syllabus_id = version.syllabus_id
                WHERE version.version_id = ?
                  AND assignment.designer_id IS NOT NULL
                ORDER BY
                    CASE
                        WHEN assignment.submitted_version_id = ?
                            THEN 0
                        ELSE 1
                    END,
                    assignment.assignment_id DESC
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, versionId);
            statement.setLong(2, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getLong("designer_id");
                }
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return getDesignerIdFromVersionCreator(versionId);
    }

    public boolean notifyDesignerAfterReview(
            long versionId,
            long reviewerId,
            String finalDecision
    ) {
        Long designerId = getDesignerIdByVersionId(versionId);

        if (designerId == null) {
            System.out.println(
                    "Designer not found for versionId = " + versionId
            );
            return false;
        }

        String decision = finalDecision == null
                ? ""
                : finalDecision.trim().toUpperCase();

        String notificationType;
        String subject;
        String body;

        if ("REJECTED".equals(decision)) {
            notificationType = "SYLLABUS_REJECTED";
            subject = "Syllabus revision required";
            body = "A reviewer rejected at least one syllabus section. "
                    + "Please open the review result, revise the syllabus, "
                    + "and submit a new version.";
        } else {
            notificationType = "REVIEW_COMPLETED";
            subject = "Syllabus review completed";
            body = "A reviewer completed the syllabus review.";
        }

        return insertNotificationIfMissing(
                designerId,
                reviewerId,
                notificationType,
                versionId,
                subject,
                body
        );
    }

    public boolean notifyAcademicWhenAllReviewersApproved(
            long versionId,
            long reviewerId
    ) {
        String academicSql = """
                SELECT DISTINCT userAccount.user_id
                FROM users userAccount
                INNER JOIN user_roles userRole
                    ON userRole.user_id = userAccount.user_id
                INNER JOIN roles role
                    ON role.role_id = userRole.role_id
                WHERE role.role_name = 'ACADEMIC_OFFICE'
                  AND userAccount.status = 'ACTIVE'
                """;

        boolean created = false;

        try (PreparedStatement statement
                     = connection.prepareStatement(academicSql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                long academicId = resultSet.getLong("user_id");

                boolean inserted = insertNotificationIfMissing(
                        academicId,
                        reviewerId,
                        "SYLLABUS_READY_FOR_ACADEMIC",
                        versionId,
                        "Syllabus ready for Academic review",
                        "All assigned reviewers approved this syllabus "
                        + "version. It is now ready for Academic Office "
                        + "processing."
                );

                created = inserted || created;
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return created;
    }

    /*
     * Compatibility method for older controller code. Do not call this method
     * together with notifyDesignerAfterReview(), because both represent the
     * same Designer notification.
     */
    public boolean createReviewCompletedNotification(
            long versionId,
            long reviewerId,
            String decision
    ) {
        return notifyDesignerAfterReview(
                versionId,
                reviewerId,
                decision
        );
    }

    private Long getDesignerIdFromVersionCreator(
            long versionId
    ) {
        String sql = """
                SELECT created_by
                FROM syllabus_versions
                WHERE version_id = ?
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getLong("created_by");
                }
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return null;
    }

    private boolean insertNotificationIfMissing(
            long recipientId,
            long triggeredBy,
            String notificationType,
            long versionId,
            String subject,
            String body
    ) {
        String sql = """
                INSERT INTO notifications (
                    recipient_id,
                    triggered_by,
                    notification_type,
                    related_entity_type,
                    related_entity_id,
                    subject,
                    body,
                    channel,
                    status,
                    sent_at,
                    is_read
                )
                SELECT
                    ?,
                    ?,
                    ?,
                    'SYLLABUS_VERSION',
                    ?,
                    ?,
                    ?,
                    'IN_APP',
                    'SENT',
                    SYSDATETIME(),
                    0
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM notifications existingNotification
                    WHERE existingNotification.recipient_id = ?
                      AND existingNotification.notification_type = ?
                      AND existingNotification.related_entity_type
                            = 'SYLLABUS_VERSION'
                      AND existingNotification.related_entity_id = ?
                      AND existingNotification.status IN (
                            'PENDING',
                            'SENT'
                      )
                )
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, recipientId);
            statement.setLong(2, triggeredBy);
            statement.setString(3, notificationType);
            statement.setLong(4, versionId);
            statement.setString(5, subject);
            statement.setString(6, body);
            statement.setLong(7, recipientId);
            statement.setString(8, notificationType);
            statement.setLong(9, versionId);

            return statement.executeUpdate() == 1;

        } catch (SQLException exception) {
            exception.printStackTrace();
            return false;
        }
    }
}