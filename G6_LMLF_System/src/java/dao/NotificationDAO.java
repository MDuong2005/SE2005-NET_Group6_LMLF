package dao;


import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import model.Notification;

public class NotificationDAO extends DBContext {

    public static final String TYPE_EXTERNAL_ACCOUNT_APPROVED
            = "EXTERNAL_ACCOUNT_APPROVED";

    public static final String TYPE_EXTERNAL_ACCOUNT_REJECTED
            = "EXTERNAL_ACCOUNT_REJECTED";
    public static final String TYPE_DESIGN_TASK_ASSIGNED
            = "LECTURER_DESIGN_TASK_ASSIGNED";

    public static final String TYPE_REVIEW_TASK_ASSIGNED
            = "LECTURER_REVIEW_TASK_ASSIGNED";

    public static final String TYPE_ALL_REVIEWERS_APPROVED
            = "ALL_REVIEWERS_APPROVED";

    public int backfillMissingApprovedNotifications(
            long academicId
    ) {

        if (connection == null
                || academicId <= 0
                || !recipientHasRole(
                        academicId,
                        "ACADEMIC_OFFICE"
                )) {
            return 0;
        }

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
                    assignmentRow.assigned_by,
                    NULL,
                    ?,
                    'SYLLABUS_VERSION',
                    versionRow.version_id,
                    'All reviewers approved the syllabus',
                    CONCAT(
                        'All assigned reviewers approved ',
                        course.code,
                        ' - ',
                        course.name,
                        ' syllabus version ',
                        versionRow.version_number,
                        '. It is ready for Academic Office processing.'
                    ),
                    'IN_APP',
                    'SENT',
                    COALESCE(
                        versionRow.approved_at,
                        SYSDATETIME()
                    ),
                    0
                FROM syllabus_versions versionRow
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id
                        = versionRow.syllabus_id
                INNER JOIN courses course
                    ON course.course_id = syllabus.course_id
                INNER JOIN syllabus_assignments assignmentRow
                    ON assignmentRow.submitted_version_id
                        = versionRow.version_id
                WHERE versionRow.status = 'APPROVED'
                  AND assignmentRow.assigned_by = ?
                  AND EXISTS (
                        SELECT 1
                        FROM syllabus_version_review_assignments
                            reviewAssignment
                        WHERE reviewAssignment.version_id
                                = versionRow.version_id
                  )
                  AND NOT EXISTS (
                        SELECT 1
                        FROM syllabus_version_review_assignments
                            reviewAssignment
                        WHERE reviewAssignment.version_id
                                = versionRow.version_id
                          AND reviewAssignment.status <> 'COMPLETED'
                  )
                  AND NOT EXISTS (
                        SELECT 1
                        FROM syllabus_reviews reviewRow
                        WHERE reviewRow.version_id
                                = versionRow.version_id
                          AND reviewRow.decision NOT IN (
                                'APPROVED',
                                'APPROVED_WITH_COMMENT'
                          )
                  )
                  AND (
                        SELECT COUNT(*)
                        FROM syllabus_version_review_assignments
                            reviewAssignment
                        WHERE reviewAssignment.version_id
                                = versionRow.version_id
                          AND reviewAssignment.status = 'COMPLETED'
                  ) = (
                        SELECT COUNT(DISTINCT reviewRow.reviewer_id)
                        FROM syllabus_reviews reviewRow
                        WHERE reviewRow.version_id
                                = versionRow.version_id
                          AND reviewRow.decision IN (
                                'APPROVED',
                                'APPROVED_WITH_COMMENT'
                          )
                  )
                  AND NOT EXISTS (
                        SELECT 1
                        FROM notifications existingNotification
                        WHERE existingNotification.recipient_id
                                = assignmentRow.assigned_by
                          AND existingNotification.notification_type
                                = ?
                          AND existingNotification.related_entity_type
                                = 'SYLLABUS_VERSION'
                          AND existingNotification.related_entity_id
                                = versionRow.version_id
                          AND existingNotification.status IN (
                                'PENDING',
                                'SENT'
                          )
                  )
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setString(
                    1,
                    TYPE_ALL_REVIEWERS_APPROVED
            );

            statement.setLong(2, academicId);

            statement.setString(
                    3,
                    TYPE_ALL_REVIEWERS_APPROVED
            );

            return statement.executeUpdate();

        } catch (SQLException exception) {
            exception.printStackTrace();
            return 0;
        }
    }

    public List<Notification> getRecentNotifications(
            long recipientId,
            int limit
    ) {

        List<Notification> notifications = new ArrayList<>();

        if (connection == null || recipientId <= 0) {
            return notifications;
        }

        int safeLimit = Math.max(1, Math.min(limit, 100));

        String sql = """
                SELECT TOP (?)
                    notification_id,
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
                FROM notifications
                WHERE recipient_id = ?
                  AND status = 'SENT'
                ORDER BY
                    is_read ASC,
                    sent_at DESC,
                    notification_id DESC
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setInt(1, safeLimit);
            statement.setLong(2, recipientId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Notification notification = mapNotification(resultSet);
                    notification.setTargetUrl(
                            buildTargetUrl(notification)
                    );
                    notifications.add(notification);
                }
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return notifications;
    }

    public int countUnread(long recipientId) {

        if (connection == null || recipientId <= 0) {
            return 0;
        }

        String sql = """
                SELECT COUNT(*) AS unread_count
                FROM notifications
                WHERE recipient_id = ?
                  AND status = 'SENT'
                  AND is_read = 0
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, recipientId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("unread_count");
                }
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return 0;
    }

    public boolean markAsRead(
            long notificationId,
            long recipientId
    ) {

        if (connection == null
                || notificationId <= 0
                || recipientId <= 0) {
            return false;
        }

        String sql = """
                UPDATE notifications
                SET is_read = 1
                WHERE notification_id = ?
                  AND recipient_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, notificationId);
            statement.setLong(2, recipientId);

            return statement.executeUpdate() == 1;

        } catch (SQLException exception) {
            exception.printStackTrace();
            return false;
        }
    }

    public int markAllAsRead(long recipientId) {

        if (connection == null || recipientId <= 0) {
            return 0;
        }

        String sql = """
                UPDATE notifications
                SET is_read = 1
                WHERE recipient_id = ?
                  AND is_read = 0
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, recipientId);
            return statement.executeUpdate();

        } catch (SQLException exception) {
            exception.printStackTrace();
            return 0;
        }
    }

    public boolean notifyAcademicExternalAccountApproved(
            long academicId,
            long adminId,
            long requestId,
            long externalUserId,
            String externalName,
            String externalEmail
    ) {

        if (!recipientHasRole(academicId, "ACADEMIC_OFFICE")) {
            return false;
        }

        String safeName = trimToNull(externalName);
        String safeEmail = trimToNull(externalEmail);

        String identity;

        if (safeName != null && safeEmail != null) {
            identity = safeName + " (" + safeEmail + ")";
        } else if (safeEmail != null) {
            identity = safeEmail;
        } else if (safeName != null) {
            identity = safeName;
        } else {
            identity = "The requested external reviewer";
        }

        String body = identity
                + " has been approved by Admin and the account is now "
                + "active. You can assign this external reviewer to a "
                + "syllabus review task.";

        return insertIfMissing(
                academicId,
                adminId,
                TYPE_EXTERNAL_ACCOUNT_APPROVED,
                "ACCOUNT_REQUEST",
                requestId,
                "External reviewer account approved",
                body
        );
    }

    public boolean notifyAcademicExternalAccountRejected(
            long academicId,
            long adminId,
            long requestId,
            String externalEmail,
            String rejectReason
    ) {

        if (!recipientHasRole(academicId, "ACADEMIC_OFFICE")) {
            return false;
        }

        String safeEmail = trimToNull(externalEmail);
        String identity = (safeEmail != null) ? safeEmail : "The requested external reviewer";
        String reasonStr = (rejectReason != null && !rejectReason.trim().isEmpty()) ? rejectReason.trim() : "No reason provided.";

        String body = identity
                + " has been REJECTED by Admin. Reason: " + reasonStr;

        return insertIfMissing(
                academicId,
                adminId,
                TYPE_EXTERNAL_ACCOUNT_REJECTED,
                "ACCOUNT_REQUEST",
                requestId,
                "External reviewer account rejected",
                body
        );
    }
    public boolean notifyLecturerTaskAssignments(
            long assignmentId,
            long academicId,
            long designerId,
            List<Long> reviewerIds
    ) {

        AssignmentContext assignment
                = loadAssignmentContext(assignmentId);

        if (assignment == null) {
            return false;
        }

        boolean created = false;

        if (recipientHasRole(designerId, "LECTURER")) {
            String body = "Academic Office assigned you to design the "
                    + assignment.courseLabel()
                    + assignment.termAndDueDate()
                    + ". Open My Tasks to start the syllabus work.";

            created = insertIfMissing(
                    designerId,
                    academicId,
                    TYPE_DESIGN_TASK_ASSIGNED,
                    "SYLLABUS_ASSIGNMENT",
                    assignmentId,
                    "New syllabus design task",
                    body
            ) || created;
        }

        Set<Long> distinctReviewerIds = new LinkedHashSet<>();

        if (reviewerIds != null) {
            for (Long reviewerId : reviewerIds) {
                if (reviewerId != null && reviewerId > 0) {
                    distinctReviewerIds.add(reviewerId);
                }
            }
        }

        for (Long reviewerId : distinctReviewerIds) {
            // A reviewer may be an internal lecturer OR an external expert, so
            // do NOT gate on the LECTURER role here (that silently dropped the
            // notification for external-expert reviewers, leaving them unaware
            // of the task). The reviewer ids were already validated upstream.

            String body = "Academic Office assigned you to review the "
                    + assignment.courseLabel()
                    + assignment.termAndDueDate()
                    + ". The review task will be available in My Tasks.";

            created = insertIfMissing(
                    reviewerId,
                    academicId,
                    TYPE_REVIEW_TASK_ASSIGNED,
                    "SYLLABUS_ASSIGNMENT",
                    assignmentId,
                    "New syllabus review task",
                    body
            ) || created;
        }

        return created;
    }

    public boolean notifyAcademicWhenAllReviewersApproved(
            long versionId,
            long triggeredByReviewerId
    ) {

        ApprovedVersionContext context
                = loadApprovedVersionContext(versionId);

        if (context == null) {
            return false;
        }

        String body = "All assigned reviewers approved "
                + context.courseLabel()
                + " syllabus version "
                + context.versionNumber
                + ". It is ready for Academic Office processing.";

        boolean created = false;

        if (context.assignedBy != null
                && recipientHasRole(
                        context.assignedBy,
                        "ACADEMIC_OFFICE"
                )) {

            return insertIfMissing(
                    context.assignedBy,
                    triggeredByReviewerId,
                    TYPE_ALL_REVIEWERS_APPROVED,
                    "SYLLABUS_VERSION",
                    versionId,
                    "All reviewers approved the syllabus",
                    body
            );
        }

        String academicSql = """
                SELECT DISTINCT userAccount.user_id
                FROM users userAccount
                INNER JOIN user_roles userRole
                    ON userRole.user_id = userAccount.user_id
                INNER JOIN roles roleRow
                    ON roleRow.role_id = userRole.role_id
                WHERE roleRow.role_name = 'ACADEMIC_OFFICE'
                  AND userAccount.status = 'ACTIVE'
                  AND userAccount.deleted_at IS NULL
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(academicSql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                long academicId = resultSet.getLong("user_id");

                created = insertIfMissing(
                        academicId,
                        triggeredByReviewerId,
                        TYPE_ALL_REVIEWERS_APPROVED,
                        "SYLLABUS_VERSION",
                        versionId,
                        "All reviewers approved the syllabus",
                        body
                ) || created;
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return created;
    }

    private Notification mapNotification(
            ResultSet resultSet
    ) throws SQLException {

        Notification notification = new Notification();

        notification.setNotificationId(
                resultSet.getLong("notification_id")
        );

        notification.setRecipientId(
                resultSet.getLong("recipient_id")
        );

        long triggeredBy = resultSet.getLong("triggered_by");
        if (!resultSet.wasNull()) {
            notification.setTriggeredBy(triggeredBy);
        }

        notification.setNotificationType(
                resultSet.getString("notification_type")
        );

        notification.setRelatedEntityType(
                resultSet.getString("related_entity_type")
        );

        long relatedEntityId
                = resultSet.getLong("related_entity_id");

        if (!resultSet.wasNull()) {
            notification.setRelatedEntityId(relatedEntityId);
        }

        notification.setSubject(resultSet.getString("subject"));
        notification.setBody(resultSet.getString("body"));
        notification.setChannel(resultSet.getString("channel"));
        notification.setStatus(resultSet.getString("status"));
        notification.setSentAt(resultSet.getTimestamp("sent_at"));
        notification.setRead(resultSet.getBoolean("is_read"));

        return notification;
    }

    private String buildTargetUrl(Notification notification) {

        if (notification == null
                || notification.getNotificationType() == null) {
            return "/dashboard";
        }

        switch (notification.getNotificationType()) {
            case TYPE_EXTERNAL_ACCOUNT_APPROVED:
            case TYPE_EXTERNAL_ACCOUNT_REJECTED:
            case TYPE_ALL_REVIEWERS_APPROVED:
                return "/role-assignment";

            case TYPE_DESIGN_TASK_ASSIGNED:
            case TYPE_REVIEW_TASK_ASSIGNED:
                return "/assigned-roles";

            default:
                return "/dashboard";
        }
    }

    private boolean insertIfMissing(
            long recipientId,
            long triggeredBy,
            String notificationType,
            String relatedEntityType,
            long relatedEntityId,
            String subject,
            String body
    ) {

        if (connection == null || recipientId <= 0) {
            return false;
        }

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
                    ?,
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
                      AND existingNotification.related_entity_type = ?
                      AND existingNotification.related_entity_id = ?
                      AND existingNotification.status IN (
                            'PENDING',
                            'SENT'
                      )
                )
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, recipientId);

            if (triggeredBy > 0) {
                statement.setLong(2, triggeredBy);
            } else {
                statement.setNull(2, java.sql.Types.BIGINT);
            }

            statement.setString(3, notificationType);
            statement.setString(4, relatedEntityType);
            statement.setLong(5, relatedEntityId);
            statement.setString(6, subject);
            statement.setString(7, body);

            statement.setLong(8, recipientId);
            statement.setString(9, notificationType);
            statement.setString(10, relatedEntityType);
            statement.setLong(11, relatedEntityId);

            return statement.executeUpdate() == 1;

        } catch (SQLException exception) {
            exception.printStackTrace();
            return false;
        }
    }

    private boolean recipientHasRole(
            long userId,
            String roleName
    ) {

        if (connection == null
                || userId <= 0
                || roleName == null) {
            return false;
        }

        String sql = """
                SELECT TOP (1) 1
                FROM users userAccount
                INNER JOIN user_roles userRole
                    ON userRole.user_id = userAccount.user_id
                INNER JOIN roles roleRow
                    ON roleRow.role_id = userRole.role_id
                WHERE userAccount.user_id = ?
                  AND userAccount.status = 'ACTIVE'
                  AND userAccount.deleted_at IS NULL
                  AND roleRow.role_name = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, userId);
            statement.setString(2, roleName);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
            return false;
        }
    }

    private AssignmentContext loadAssignmentContext(
            long assignmentId
    ) {

        String sql = """
                SELECT
                    assignmentRow.assignment_id,
                    assignmentRow.semester,
                    assignmentRow.academic_year,
                    assignmentRow.due_date,
                    course.code AS course_code,
                    course.name AS course_name
                FROM syllabus_assignments assignmentRow
                INNER JOIN courses course
                    ON course.course_id = assignmentRow.course_id
                WHERE assignmentRow.assignment_id = ?
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, assignmentId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return new AssignmentContext(
                            resultSet.getString("course_code"),
                            resultSet.getString("course_name"),
                            resultSet.getString("semester"),
                            resultSet.getInt("academic_year"),
                            resultSet.getTimestamp("due_date")
                    );
                }
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return null;
    }

    private ApprovedVersionContext loadApprovedVersionContext(
            long versionId
    ) {

        String sql = """
                SELECT TOP (1)
                    assignmentRow.assigned_by,
                    course.code AS course_code,
                    course.name AS course_name,
                    versionRow.version_number
                FROM syllabus_versions versionRow
                INNER JOIN syllabuses syllabus
                    ON syllabus.syllabus_id = versionRow.syllabus_id
                INNER JOIN courses course
                    ON course.course_id = syllabus.course_id
                LEFT JOIN syllabus_assignments assignmentRow
                    ON assignmentRow.submitted_version_id
                        = versionRow.version_id
                    OR (
                        assignmentRow.syllabus_id
                            = versionRow.syllabus_id
                        AND assignmentRow.submitted_version_id IS NULL
                    )
                WHERE versionRow.version_id = ?
                ORDER BY
                    CASE
                        WHEN assignmentRow.submitted_version_id
                                = versionRow.version_id
                            THEN 0
                        ELSE 1
                    END,
                    assignmentRow.assignment_id DESC
                """;

        try (PreparedStatement statement
                     = connection.prepareStatement(sql)) {

            statement.setLong(1, versionId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    Long assignedBy = null;
                    long assignedByValue
                            = resultSet.getLong("assigned_by");

                    if (!resultSet.wasNull()) {
                        assignedBy = assignedByValue;
                    }

                    return new ApprovedVersionContext(
                            assignedBy,
                            resultSet.getString("course_code"),
                            resultSet.getString("course_name"),
                            resultSet.getString("version_number")
                    );
                }
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
        }

        return null;
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }

    private static final class AssignmentContext {

        private static final DateTimeFormatter DUE_DATE_FORMAT
                = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        private final String courseCode;
        private final String courseName;
        private final String semester;
        private final int academicYear;
        private final Timestamp dueDate;

        private AssignmentContext(
                String courseCode,
                String courseName,
                String semester,
                int academicYear,
                Timestamp dueDate
        ) {
            this.courseCode = courseCode;
            this.courseName = courseName;
            this.semester = semester;
            this.academicYear = academicYear;
            this.dueDate = dueDate;
        }

        private String courseLabel() {
            String safeCode = courseCode == null
                    ? "course"
                    : courseCode.trim();

            String safeName = courseName == null
                    ? ""
                    : courseName.trim();

            return safeName.isEmpty()
                    ? safeCode
                    : safeCode + " - " + safeName;
        }

        private String termAndDueDate() {
            StringBuilder builder = new StringBuilder();

            if (semester != null && !semester.trim().isEmpty()) {
                builder.append(" for ")
                        .append(semester.trim());

                if (academicYear > 0) {
                    builder.append(" ").append(academicYear);
                }
            } else if (academicYear > 0) {
                builder.append(" for academic year ")
                        .append(academicYear);
            }

            if (dueDate != null) {
                builder.append(", due ")
                        .append(
                                dueDate.toLocalDateTime()
                                        .format(DUE_DATE_FORMAT)
                        );
            }

            return builder.toString();
        }
    }

    private static final class ApprovedVersionContext {

        private final Long assignedBy;
        private final String courseCode;
        private final String courseName;
        private final String versionNumber;

        private ApprovedVersionContext(
                Long assignedBy,
                String courseCode,
                String courseName,
                String versionNumber
        ) {
            this.assignedBy = assignedBy;
            this.courseCode = courseCode;
            this.courseName = courseName;
            this.versionNumber = (
                    versionNumber == null
                    || versionNumber.trim().isEmpty()
            ) ? "unknown" : versionNumber.trim();
        }

        private String courseLabel() {
            String safeCode = courseCode == null
                    ? "the course"
                    : courseCode.trim();

            String safeName = courseName == null
                    ? ""
                    : courseName.trim();

            return safeName.isEmpty()
                    ? safeCode
                    : safeCode + " - " + safeName;
        }
    }
}
