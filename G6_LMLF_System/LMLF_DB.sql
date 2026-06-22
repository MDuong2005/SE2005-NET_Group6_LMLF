-- LMLF Database Schema - FINAL PRODUCTION VERSION (FREEZE V4.1 - LOCKED)

IF DB_ID('LMLF') IS NULL
BEGIN
    CREATE DATABASE LMLF;
END
GO

USE LMLF;
GO

-- =======================================================
-- 1. USERS
-- =======================================================
CREATE TABLE users (
    user_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NULL,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(255) NOT NULL,
    password_hash NVARCHAR(255) NULL,
    auth_provider NVARCHAR(20) NOT NULL DEFAULT 'GOOGLE',
    is_external BIT NOT NULL DEFAULT 0,
    must_change_password BIT NOT NULL DEFAULT 0,
    status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    registered_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    last_login DATETIME2,
    deleted_at DATETIME2 NULL,

    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT uq_users_username UNIQUE (username),
    CONSTRAINT chk_users_status CHECK (status IN ('ACTIVE','INACTIVE','BANNED')),
    CONSTRAINT chk_auth_provider CHECK (auth_provider IN ('LOCAL','GOOGLE','BOTH'))
);

-- =======================================================
-- 2. ROLES
-- =======================================================
CREATE TABLE roles (
    role_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX),
    CONSTRAINT uq_roles_name UNIQUE (role_name)
);

-- =======================================================
-- 3. USER ROLES
-- =======================================================
CREATE TABLE user_roles (
    user_role_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    assigned_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT uq_user_roles UNIQUE (user_id, role_id),
    CONSTRAINT fk_userroles_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_userroles_role FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- =======================================================
-- 4. MAJORS
-- =======================================================
CREATE TABLE majors (
    major_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(20) NOT NULL,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    created_by BIGINT,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    deleted_at DATETIME2 NULL,

    CONSTRAINT uq_majors_code UNIQUE (code),
    CONSTRAINT fk_majors_user FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- =======================================================
-- 5. CURRICULUMS
-- =======================================================
CREATE TABLE curriculums (
    curriculum_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    major_id BIGINT NOT NULL,
    version NVARCHAR(20) NOT NULL,
    status NVARCHAR(20) NOT NULL,
    total_semesters INT NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_by BIGINT NULL,
    deleted_at DATETIME2 NULL,

    CONSTRAINT chk_curriculums_status CHECK (status IN ('DRAFT','ACTIVE','ARCHIVED')),
    CONSTRAINT uq_curriculum_version UNIQUE (major_id, version),
    CONSTRAINT fk_curriculums_major FOREIGN KEY (major_id) REFERENCES majors(major_id),
    CONSTRAINT fk_curriculum_updated_by FOREIGN KEY (updated_by) REFERENCES users(user_id)
);

-- =======================================================
-- 6. COURSES
-- =======================================================
CREATE TABLE courses (
    course_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(20) NOT NULL,
    name NVARCHAR(255) NOT NULL,
    credits INT NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    deleted_at DATETIME2 NULL,

    CONSTRAINT uq_courses_code UNIQUE (code)
);

-- =======================================================
-- 7. CURRICULUM COURSES
-- =======================================================
CREATE TABLE curriculum_courses (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    curriculum_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    semester INT NOT NULL,
    CONSTRAINT uq_curriculum_courses UNIQUE (curriculum_id, course_id),
    CONSTRAINT fk_currcourses_curriculum FOREIGN KEY (curriculum_id) REFERENCES curriculums(curriculum_id),
    CONSTRAINT fk_currcourses_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- =======================================================
-- 8. COURSE PREREQUISITES
-- =======================================================
CREATE TABLE course_prerequisites (
    course_prerequisite_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    prerequisite_course_id BIGINT NOT NULL,
    
    CONSTRAINT uq_course_prerequisites UNIQUE (course_id, prerequisite_course_id),
    CONSTRAINT chk_course_not_self CHECK (course_id <> prerequisite_course_id),
    CONSTRAINT fk_prereq_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_prereq_prereq FOREIGN KEY (prerequisite_course_id) REFERENCES courses(course_id)
);

-- =======================================================
-- 9. SYLLABUSES
-- =======================================================
CREATE TABLE syllabuses (
    syllabus_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    current_version NVARCHAR(20),
    status NVARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_by BIGINT NULL,
    deleted_at DATETIME2 NULL,

    CONSTRAINT chk_syllabuses_status CHECK (status IN ('DRAFT','PUBLISHED','ARCHIVED')),
    CONSTRAINT fk_syllabuses_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_syllabus_updated_by FOREIGN KEY (updated_by) REFERENCES users(user_id)
);

-- =======================================================
-- 10. SYLLABUS ASSIGNMENTS
-- =======================================================
CREATE TABLE syllabus_assignments (
    assignment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    designer_id BIGINT NULL,  
    reviewer_id BIGINT NULL,  
    semester NVARCHAR(20),
    academic_year INT,
    assignment_status NVARCHAR(20) NOT NULL DEFAULT 'PENDING',
    assigned_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT chk_assignment_status CHECK (assignment_status IN ('PENDING','ACCEPTED','REJECTED','ACTIVE','COMPLETED')),
    CONSTRAINT chk_assignment_diff CHECK (designer_id IS NULL OR reviewer_id IS NULL OR designer_id <> reviewer_id),
    CONSTRAINT fk_assign_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_assign_designer FOREIGN KEY (designer_id) REFERENCES users(user_id),
    CONSTRAINT fk_assign_reviewer FOREIGN KEY (reviewer_id) REFERENCES users(user_id)
);

-- =======================================================
-- 11. SYLLABUS VERSIONS
-- =======================================================
CREATE TABLE syllabus_versions (
version_id BIGINT IDENTITY(1,1) PRIMARY KEY,

syllabus_id BIGINT NOT NULL,

version_number NVARCHAR(20) NOT NULL,

change_type NVARCHAR(10) NULL,

description_of_changes NVARCHAR(MAX) NULL,

status NVARCHAR(20) NOT NULL DEFAULT 'DRAFT',

created_by BIGINT NOT NULL,

updated_by BIGINT NULL,

submitted_at DATETIME2 NULL,

approved_at DATETIME2 NULL,

rejected_at DATETIME2 NULL,

published_at DATETIME2 NULL,

archived_at DATETIME2 NULL,

published_by BIGINT NULL,

CONSTRAINT uq_syllabus_version
    UNIQUE (syllabus_id, version_number),

CONSTRAINT chk_sv_change_type
    CHECK (
        change_type IN ('NEW','MINOR','MAJOR')
        OR change_type IS NULL
    ),

CONSTRAINT chk_sv_status
    CHECK (
        status IN (
            'DRAFT',
            'SUBMITTED',
            'APPROVED',
            'REJECTED',
            'PUBLISHED',
            'ARCHIVED'
        )
    ),

CONSTRAINT fk_sv_syllabus
    FOREIGN KEY (syllabus_id)
    REFERENCES syllabuses(syllabus_id),

CONSTRAINT fk_sv_creator
    FOREIGN KEY (created_by)
    REFERENCES users(user_id),

CONSTRAINT fk_sv_updated_by
    FOREIGN KEY (updated_by)
    REFERENCES users(user_id),

CONSTRAINT fk_sv_published_by
    FOREIGN KEY (published_by)
    REFERENCES users(user_id)

);
GO

/* Query syllabus + status */
CREATE INDEX idx_syllabus_versions_syllabus_status
ON syllabus_versions(syllabus_id, status);
GO

/* Dashboard, review queue, approval queue */
CREATE INDEX idx_syllabus_versions_status
ON syllabus_versions(status);
GO

/* Mỗi syllabus chỉ có 1 version đang PUBLISHED */
CREATE UNIQUE INDEX uq_one_published_per_syllabus
ON syllabus_versions(syllabus_id)
WHERE status = 'PUBLISHED';
GO


-- =======================================================
-- 12. SYLLABUS REVIEWS
-- =======================================================
CREATE TABLE syllabus_reviews (
    review_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    version_id BIGINT NOT NULL,
    reviewer_id BIGINT NOT NULL,
    decision NVARCHAR(20),
    comment NVARCHAR(MAX),
    reviewed_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT uq_reviewer_version UNIQUE(version_id, reviewer_id),
    CONSTRAINT chk_sr_decision CHECK (decision IN ('APPROVED','REJECTED','REVISION_NEEDED')),
    CONSTRAINT fk_sr_version FOREIGN KEY (version_id) REFERENCES syllabus_versions(version_id),
    CONSTRAINT fk_sr_reviewer FOREIGN KEY (reviewer_id) REFERENCES users(user_id)
);

-- =======================================================
-- 13. LEARNING MATERIALS
-- =======================================================
CREATE TABLE learning_materials (
    material_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    version_id BIGINT NOT NULL,
    uploaded_by BIGINT NOT NULL,
    material_type NVARCHAR(20),
    title NVARCHAR(255),
    file_url NVARCHAR(1000),
    file_size BIGINT,
    access_level NVARCHAR(20),
    uploaded_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    deleted_at DATETIME2 NULL,

    CONSTRAINT chk_lm_type CHECK (material_type IN ('SLIDE','DOCUMENT','VIDEO','REFERENCE','OTHER')),
    CONSTRAINT chk_lm_access CHECK (access_level IN ('PUBLIC','STUDENTS_ONLY','LECTURERS_ONLY')),
    CONSTRAINT fk_lm_version FOREIGN KEY (version_id) REFERENCES syllabus_versions(version_id),
    CONSTRAINT fk_lm_uploader FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

-- =======================================================
-- 14. LECTURER MATERIALS
-- =======================================================
CREATE TABLE lecturer_materials (
    lecturer_material_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    lecturer_id BIGINT NOT NULL,
    title NVARCHAR(255),
    file_url NVARCHAR(500),
    uploaded_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT fk_lecmat_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_lecmat_lecturer FOREIGN KEY (lecturer_id) REFERENCES users(user_id)
);

-- =======================================================
-- 15. CLASS SCHEDULES
-- =======================================================
CREATE TABLE class_schedules (
    schedule_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    lecturer_id BIGINT NOT NULL,
    semester NVARCHAR(20),
    academic_year INT,
    class_code NVARCHAR(50),
    status NVARCHAR(20) NOT NULL DEFAULT 'OPEN',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT uq_class_schedules UNIQUE (class_code, academic_year, semester),
    CONSTRAINT chk_cs_status CHECK (status IN ('OPEN','CLOSED','CANCELLED')),
    CONSTRAINT fk_cs_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_cs_lecturer FOREIGN KEY (lecturer_id) REFERENCES users(user_id)
);

-- =======================================================
-- 16. NOTIFICATIONS
-- =======================================================
CREATE TABLE notifications (
    notification_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    recipient_id BIGINT NOT NULL,
    triggered_by BIGINT,
    notification_type NVARCHAR(50),
    related_entity_type NVARCHAR(50),
    related_entity_id BIGINT,
    subject NVARCHAR(255),
    body NVARCHAR(MAX),
    channel NVARCHAR(10) NOT NULL DEFAULT 'IN_APP',
    status NVARCHAR(10) NOT NULL DEFAULT 'PENDING',
    sent_at DATETIME2 DEFAULT SYSDATETIME(),
    is_read BIT NOT NULL DEFAULT 0,

    CONSTRAINT chk_notif_channel CHECK (channel IN ('EMAIL','IN_APP','SMS')),
    CONSTRAINT chk_notif_status CHECK (status IN ('PENDING','SENT','FAILED')),
    CONSTRAINT fk_notif_recipient FOREIGN KEY (recipient_id) REFERENCES users(user_id),
    CONSTRAINT fk_notif_trigger FOREIGN KEY (triggered_by) REFERENCES users(user_id)
);

-- =======================================================
-- 17. AUDIT LOGS
-- =======================================================
CREATE TABLE audit_logs (
    audit_log_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT,
    action NVARCHAR(255),
    entity_type NVARCHAR(100),
    entity_id BIGINT,
    old_value NVARCHAR(MAX),
    new_value NVARCHAR(MAX),
    ip_address NVARCHAR(45),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- =======================================================
-- 18. LEARNING OUTCOMES
-- =======================================================
CREATE TABLE learning_outcomes (
    outcome_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    version_id BIGINT NOT NULL,
    code NVARCHAR(20) NOT NULL,
    description NVARCHAR(MAX),
    bloom_level NVARCHAR(20),

    CONSTRAINT uq_lo_code UNIQUE(version_id, code), 
    CONSTRAINT chk_bloom_level CHECK (bloom_level IN ('Remember', 'Understand', 'Apply', 'Analyze', 'Evaluate', 'Create')),
    CONSTRAINT fk_learning_outcomes_version FOREIGN KEY (version_id) REFERENCES syllabus_versions(version_id)
);

-- =======================================================
-- 19. REVIEW COMMENTS
-- =======================================================
CREATE TABLE review_comments (
    comment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    review_id BIGINT NOT NULL,
    parent_comment_id BIGINT NULL,
    section_ref NVARCHAR(100),
    body NVARCHAR(MAX),
    created_by BIGINT NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    resolved_at DATETIME2 NULL,

    CONSTRAINT fk_review_comments_review FOREIGN KEY (review_id) REFERENCES syllabus_reviews(review_id),
    CONSTRAINT fk_review_comments_creator FOREIGN KEY (created_by) REFERENCES users(user_id),
    CONSTRAINT fk_review_comments_parent FOREIGN KEY (parent_comment_id) REFERENCES review_comments(comment_id)
);

-- =======================================================
-- 20. INDEXES
-- =======================================================
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_provider ON users(auth_provider);
CREATE INDEX idx_assignment_status ON syllabus_assignments(assignment_status);
CREATE INDEX idx_notification_type ON notifications(notification_type);
CREATE INDEX idx_user_roles_user          ON user_roles(user_id);
CREATE INDEX idx_curriculum_courses_cur  ON curriculum_courses(curriculum_id);
CREATE INDEX idx_syllabus_versions_syl   ON syllabus_versions(syllabus_id, status);
CREATE INDEX idx_notifications_recipient ON notifications(recipient_id, status);
CREATE INDEX idx_class_schedules_course  ON class_schedules(course_id, academic_year, semester);
CREATE INDEX idx_audit_logs_entity       ON audit_logs(entity_type, entity_id);

CREATE INDEX idx_reviews_version         ON syllabus_reviews(version_id);
CREATE INDEX idx_lo_version              ON learning_outcomes(version_id);
CREATE INDEX idx_material_version        ON learning_materials(version_id);

CREATE INDEX idx_users_deleted ON users(deleted_at);
CREATE INDEX idx_courses_deleted ON courses(deleted_at);
CREATE INDEX idx_syllabuses_deleted ON syllabuses(deleted_at);
GO

-- =======================================================
-- 21. SEED DATA FOR SYSTEM ROLES
-- =======================================================
INSERT INTO roles(role_name, description)
VALUES
('ADMIN', 'System Administrator'),
('ACADEMIC_OFFICE', 'Academic Office'),
('LECTURER', 'Lecturer'),
('DESIGNER', 'Syllabus Designer'),
('REVIEWER', 'Syllabus Reviewer'),
('STUDENT', 'Student'),
('ALUMNI', 'Alumni');
GO

USE LMLF;
GO
SELECT SCHEMA_NAME(schema_id) AS SchemaName, name AS TableName 
FROM sys.tables;
