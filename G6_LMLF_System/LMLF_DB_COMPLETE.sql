CREATE DATABASE LMLF;
GO

USE LMLF;
GO

-- =======================================================
-- 1. USERS
-- Mô tả: Lưu trữ thông tin người dùng trong hệ thống (bao gồm tài khoản local và SSO).
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
    last_login DATETIME2 NULL,
    deleted_at DATETIME2 NULL,

    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT chk_users_status CHECK (status IN ('ACTIVE','INACTIVE','BANNED')),
    CONSTRAINT chk_auth_provider CHECK (auth_provider IN ('LOCAL','GOOGLE','BOTH'))
);
GO

CREATE UNIQUE INDEX uq_users_username_not_null
ON users(username)
WHERE username IS NOT NULL;
GO

-- =======================================================
-- 2. ROLES
-- Mô tả: Danh sách các vai trò quyền hạn trong hệ thống (Admin, Lecturer, Designer...).
-- =======================================================
CREATE TABLE roles (
    role_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX) NULL,
    CONSTRAINT uq_roles_name UNIQUE (role_name)
);
GO

-- =======================================================
-- 3. USER_ROLES
-- Mô tả: Bảng phân quyền (map) người dùng với các vai trò tương ứng.
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
GO

-- =======================================================
-- 4. MAJORS
-- Mô tả: Danh sách các chuyên ngành đào tạo của trường.
-- =======================================================
CREATE TABLE majors (
    major_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(20) NOT NULL,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL,
    created_by BIGINT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    deleted_at DATETIME2 NULL,

    CONSTRAINT uq_majors_code UNIQUE (code),
    CONSTRAINT fk_majors_user FOREIGN KEY (created_by) REFERENCES users(user_id)
);
GO

-- =======================================================
-- 5. CURRICULUMS
-- Mô tả: Lưu trữ thông tin Chương trình khung (Khung chương trình đào tạo) của các chuyên ngành.
-- =======================================================
CREATE TABLE curriculums (
    curriculum_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    major_id BIGINT NOT NULL,
    curriculum_code NVARCHAR(50) NOT NULL,
    name NVARCHAR(255) NOT NULL,
    is_active BIT NOT NULL DEFAULT 0,
    description NVARCHAR(MAX) NULL,
    decision_no NVARCHAR(50) NULL,
    issued_date DATE NULL,
    total_credits INT NULL,
    version NVARCHAR(20) NOT NULL,
    total_semesters INT NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_by BIGINT NULL,
    deleted_at DATETIME2 NULL,

    CONSTRAINT uq_curriculum_code_version UNIQUE (major_id, curriculum_code, version),
    CONSTRAINT fk_curriculums_major FOREIGN KEY (major_id) REFERENCES majors(major_id),
    CONSTRAINT fk_curriculum_updated_by FOREIGN KEY (updated_by) REFERENCES users(user_id)
);
GO

-- =======================================================
-- 6. COURSES
-- Mô tả: Danh sách các môn học (học phần) hiện có trong trường.
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
GO

-- =======================================================
-- 7. CURRICULUM_COURSES
-- Mô tả: Bảng ánh xạ môn học thuộc chương trình khung nào và học ở kỳ mấy.
-- =======================================================
CREATE TABLE curriculum_courses (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    curriculum_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    semester INT NOT NULL,
    knowledge_block NVARCHAR(255) NULL,
    CONSTRAINT uq_curriculum_courses UNIQUE (curriculum_id, course_id),
    CONSTRAINT fk_currcourses_curriculum FOREIGN KEY (curriculum_id) REFERENCES curriculums(curriculum_id),
    CONSTRAINT fk_currcourses_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
GO

-- =======================================================
-- 8. COURSE_PREREQUISITES
-- Mô tả: Định nghĩa các môn học tiên quyết (môn nào phải học trước môn nào).
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
GO

-- =======================================================
-- 9. SYLLABUSES
-- Mô tả: Lưu trữ thông tin tổng quan của các đề cương môn học (Syllabus).
-- =======================================================
CREATE TABLE syllabuses (
    syllabus_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    current_version NVARCHAR(20) NULL,
    status NVARCHAR(30) NOT NULL DEFAULT 'DRAFT',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_by BIGINT NULL,
    deleted_at DATETIME2 NULL,

    CONSTRAINT chk_syllabuses_status CHECK (status IN ('DRAFT','SUBMITTED','PUBLISHED','REVISION_REQUIRED','ARCHIVED')),
    CONSTRAINT fk_syllabuses_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_syllabus_updated_by FOREIGN KEY (updated_by) REFERENCES users(user_id)
);
GO
-- =======================================================
-- 10. SYLLABUS_ASSIGNMENTS
-- Mô tả: Phân công nhiệm vụ soạn thảo và kiểm duyệt đề cương cho Designer và Reviewer.
-- =======================================================
CREATE TABLE syllabus_assignments (
    assignment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    syllabus_id BIGINT NULL,

    designer_id BIGINT NULL,
    reviewer_id BIGINT NULL,
    assigned_by BIGINT NULL,

    template_file_id BIGINT NULL,
    submitted_version_id BIGINT NULL,

    semester NVARCHAR(20) NULL,
    academic_year INT NULL,
    assignment_status NVARCHAR(30) NOT NULL DEFAULT 'PENDING',

    assigned_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    due_date DATETIME2 NULL,
    accepted_at DATETIME2 NULL,
    submitted_at DATETIME2 NULL,
    completed_at DATETIME2 NULL,

    CONSTRAINT chk_assignment_status CHECK (assignment_status IN ('PENDING','ACCEPTED','REJECTED','ACTIVE','IN_PROGRESS','SUBMITTED','COMPLETED','CANCELLED')),
    CONSTRAINT chk_assignment_diff CHECK (designer_id IS NULL OR reviewer_id IS NULL OR designer_id <> reviewer_id),
    CONSTRAINT fk_assign_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_assign_syllabus FOREIGN KEY (syllabus_id) REFERENCES syllabuses(syllabus_id),
    CONSTRAINT fk_assign_designer FOREIGN KEY (designer_id) REFERENCES users(user_id),
    CONSTRAINT fk_assign_reviewer FOREIGN KEY (reviewer_id) REFERENCES users(user_id),
    CONSTRAINT fk_assign_assigned_by FOREIGN KEY (assigned_by) REFERENCES users(user_id)
);
GO

-- =======================================================
-- 11. SYLLABUS_ASSIGNMENT_REVIEWERS
-- Mô tả: Danh sách các Reviewer được phân công duyệt cho một nhiệm vụ cụ thể.
-- =======================================================
CREATE TABLE syllabus_assignment_reviewers (
    assignment_reviewer_id BIGINT IDENTITY(1,1) NOT NULL,
    assignment_id BIGINT NOT NULL,
    reviewer_id BIGINT NOT NULL,
    assigned_by BIGINT NULL,
    assigned_at DATETIME2 NOT NULL
        CONSTRAINT df_sar_assigned_at
        DEFAULT SYSDATETIME(),

    CONSTRAINT pk_syllabus_assignment_reviewers
        PRIMARY KEY (assignment_reviewer_id),

    CONSTRAINT uq_sar_assignment_reviewer
        UNIQUE (assignment_id, reviewer_id),

    CONSTRAINT fk_sar_assignment
        FOREIGN KEY (assignment_id)
        REFERENCES syllabus_assignments(assignment_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_sar_reviewer
        FOREIGN KEY (reviewer_id)
        REFERENCES users(user_id),

    CONSTRAINT fk_sar_assigned_by
        FOREIGN KEY (assigned_by)
        REFERENCES users(user_id),

    CONSTRAINT chk_sar_reviewer_not_assigner
        CHECK (
            assigned_by IS NULL
            OR assigned_by <> reviewer_id
        )
);
GO

CREATE INDEX idx_sar_assignment
ON syllabus_assignment_reviewers(
    assignment_id,
    reviewer_id
);
GO

CREATE INDEX idx_sar_reviewer
ON syllabus_assignment_reviewers(
    reviewer_id,
    assignment_id
);
GO


-- =======================================================
-- 12. SYLLABUS_VERSIONS
-- Mô tả: Quản lý các phiên bản (version) khác nhau của một đề cương môn học.
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

    CONSTRAINT uq_syllabus_version UNIQUE (syllabus_id, version_number),
    CONSTRAINT chk_sv_change_type CHECK (change_type IN ('NEW','MINOR','MAJOR') OR change_type IS NULL),
    CONSTRAINT chk_sv_status CHECK (
        status IN (
            'DRAFT',
            'SUBMITTED',
            'APPROVED',
            'REJECTED',
            'PUBLISHED',
            'ARCHIVED'
        )
    ),
    CONSTRAINT fk_sv_syllabus FOREIGN KEY (syllabus_id) REFERENCES syllabuses(syllabus_id),
    CONSTRAINT fk_sv_creator FOREIGN KEY (created_by) REFERENCES users(user_id),
    CONSTRAINT fk_sv_updated_by FOREIGN KEY (updated_by) REFERENCES users(user_id),
    CONSTRAINT fk_sv_published_by FOREIGN KEY (published_by) REFERENCES users(user_id)
);
GO

ALTER TABLE syllabus_assignments
ADD CONSTRAINT fk_assign_submitted_version
FOREIGN KEY (submitted_version_id) REFERENCES syllabus_versions(version_id);
GO

-- =======================================================
-- 13. SYLLABUS_VERSION_FILES
-- Mô tả: Lưu trữ các file đính kèm (template, báo cáo) của từng phiên bản đề cương.
-- =======================================================
CREATE TABLE syllabus_version_files (
    file_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    assignment_id BIGINT NULL,
    syllabus_id BIGINT NULL,
    version_id BIGINT NULL,

    file_type NVARCHAR(50) NOT NULL,
    original_file_name NVARCHAR(255) NOT NULL,
    stored_file_path NVARCHAR(500) NOT NULL,
    file_size BIGINT NULL,
    mime_type NVARCHAR(100) NULL,

    uploaded_by BIGINT NULL,
    uploaded_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    is_active BIT NOT NULL DEFAULT 1,

    CONSTRAINT chk_svf_file_type CHECK (file_type IN ('TEMPLATE','DESIGNER_SUBMISSION','REVIEW_ATTACHMENT','OTHER')),
    CONSTRAINT fk_svf_assignment FOREIGN KEY (assignment_id) REFERENCES syllabus_assignments(assignment_id),
    CONSTRAINT fk_svf_syllabus FOREIGN KEY (syllabus_id) REFERENCES syllabuses(syllabus_id),
    CONSTRAINT fk_svf_version FOREIGN KEY (version_id) REFERENCES syllabus_versions(version_id),
    CONSTRAINT fk_svf_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);
GO

ALTER TABLE syllabus_assignments
ADD CONSTRAINT fk_assign_template_file
FOREIGN KEY (template_file_id) REFERENCES syllabus_version_files(file_id);
GO
-- =======================================================
-- 14. SYLLABUS_VERSION_SECTIONS
-- Mô tả: Lưu nội dung chi tiết của đề cương dưới dạng JSON (đã tối ưu hóa).
-- =======================================================
CREATE TABLE syllabus_version_sections (
    section_id BIGINT IDENTITY(1,1) NOT NULL,
    version_id BIGINT NOT NULL,
    section_code NVARCHAR(100) NOT NULL,
    section_name NVARCHAR(255) NOT NULL,

    content_text NVARCHAR(MAX) NULL,
    content_format NVARCHAR(20) NOT NULL
        CONSTRAINT df_svs_content_format DEFAULT N'JSON',
    schema_version INT NOT NULL
        CONSTRAINT df_svs_schema_version DEFAULT 1,

    display_order INT NOT NULL,
    imported_at DATETIME2 NOT NULL
        CONSTRAINT df_svs_imported_at DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL
        CONSTRAINT df_svs_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT pk_syllabus_version_sections
        PRIMARY KEY (section_id),

    CONSTRAINT uq_version_section
        UNIQUE (version_id, section_code),

    CONSTRAINT chk_svs_display_order
        CHECK (display_order >= 0),

    CONSTRAINT chk_svs_content_format
        CHECK (content_format IN (N'JSON', N'TEXT', N'HTML')),

    CONSTRAINT chk_svs_schema_version
        CHECK (schema_version > 0),

    CONSTRAINT chk_svs_json_content
        CHECK (
            content_format <> N'JSON'
            OR content_text IS NULL
            OR ISJSON(content_text) = 1
        ),

    CONSTRAINT fk_svs_version
        FOREIGN KEY (version_id)
        REFERENCES syllabus_versions(version_id)
        ON DELETE CASCADE
);
GO

-- =======================================================
-- 15. REVIEW_CRITERIA
-- Mô tả: Danh sách các tiêu chí dùng để đánh giá/kiểm duyệt đề cương môn học.
-- =======================================================
CREATE TABLE review_criteria (
    criteria_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    criteria_code NVARCHAR(100) NOT NULL UNIQUE,
    criteria_name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL,
    display_order INT NOT NULL,
    is_required BIT NOT NULL DEFAULT 1,
    is_active BIT NOT NULL DEFAULT 1
);
GO

-- =======================================================
-- 16. SYLLABUS_VERSION_REVIEW_ASSIGNMENTS
-- Mô tả: Phân công chi tiết ai sẽ review phiên bản đề cương nào.
-- =======================================================
CREATE TABLE syllabus_version_review_assignments (
    assignment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    version_id BIGINT NOT NULL,
    reviewer_id BIGINT NOT NULL,
    assigned_by BIGINT NULL,
    status NVARCHAR(30) NOT NULL DEFAULT 'PENDING',
    assigned_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    completed_at DATETIME2 NULL,

    CONSTRAINT uq_version_reviewer UNIQUE(version_id, reviewer_id),
    CONSTRAINT chk_svra_status CHECK (status IN ('PENDING','IN_PROGRESS','COMPLETED','CANCELLED')),
    CONSTRAINT fk_svra_version FOREIGN KEY (version_id) REFERENCES syllabus_versions(version_id),
    CONSTRAINT fk_svra_reviewer FOREIGN KEY (reviewer_id) REFERENCES users(user_id),
    CONSTRAINT fk_svra_assigned_by FOREIGN KEY (assigned_by) REFERENCES users(user_id)
);
GO

-- =======================================================
-- 17. SYLLABUS_REVIEWS
-- Mô tả: Lưu trữ kết quả kiểm duyệt tổng thể của một Reviewer cho một phiên bản.
-- =======================================================
CREATE TABLE syllabus_reviews (
    review_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    review_assignment_id BIGINT NULL,
    version_id BIGINT NOT NULL,
    reviewer_id BIGINT NOT NULL,
    decision NVARCHAR(30) NOT NULL,
    comment NVARCHAR(MAX) NULL,
    reviewed_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT uq_reviewer_version UNIQUE(version_id, reviewer_id),
    CONSTRAINT chk_sr_decision CHECK (decision IN ('APPROVED','APPROVED_WITH_COMMENT','REJECTED','REVISION_NEEDED')),
    CONSTRAINT fk_sr_review_assignment FOREIGN KEY (review_assignment_id) REFERENCES syllabus_version_review_assignments(assignment_id),
    CONSTRAINT fk_sr_version FOREIGN KEY (version_id) REFERENCES syllabus_versions(version_id),
    CONSTRAINT fk_sr_reviewer FOREIGN KEY (reviewer_id) REFERENCES users(user_id)
);
GO

-- =======================================================
-- 18. SYLLABUS_REVIEW_SECTIONS
-- Mô tả: Nhận xét và đánh giá chi tiết của Reviewer cho từng phần (section) của đề cương.
-- =======================================================
CREATE TABLE syllabus_review_sections (
    section_review_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    review_id BIGINT NOT NULL,
    criteria_id BIGINT NOT NULL,
    decision NVARCHAR(30) NOT NULL,
    comment NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT uq_review_criteria UNIQUE(review_id, criteria_id),
    CONSTRAINT chk_srs_decision CHECK (decision IN ('APPROVED','REJECTED','REVISION_NEEDED')),
    CONSTRAINT fk_srs_review FOREIGN KEY (review_id) REFERENCES syllabus_reviews(review_id),
    CONSTRAINT fk_srs_criteria FOREIGN KEY (criteria_id) REFERENCES review_criteria(criteria_id)
);
GO

-- =======================================================
-- 19. LEARNING_MATERIALS
-- Mô tả: Lưu trữ tài liệu học tập chuẩn đính kèm theo đề cương môn học.
-- =======================================================
CREATE TABLE learning_materials (
    material_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    version_id BIGINT NOT NULL,
    uploaded_by BIGINT NOT NULL,
    material_type NVARCHAR(20) NULL,
    title NVARCHAR(255) NULL,
    file_url NVARCHAR(1000) NULL,
    file_size BIGINT NULL,
    access_level NVARCHAR(20) NULL,
    uploaded_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    deleted_at DATETIME2 NULL,

    CONSTRAINT chk_lm_type CHECK (material_type IN ('SLIDE','DOCUMENT','VIDEO','REFERENCE','OTHER') OR material_type IS NULL),
    CONSTRAINT chk_lm_access CHECK (access_level IN ('PUBLIC','STUDENTS_ONLY','LECTURERS_ONLY') OR access_level IS NULL),
    CONSTRAINT fk_lm_version FOREIGN KEY (version_id) REFERENCES syllabus_versions(version_id),
    CONSTRAINT fk_lm_uploader FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);
GO

-- =======================================================
-- 20. LECTURER_MATERIALS
-- Mô tả: Kho lưu trữ tài liệu giảng dạy cá nhân của riêng từng giảng viên.
-- =======================================================
CREATE TABLE lecturer_materials (
    lecturer_material_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    lecturer_id BIGINT NOT NULL,
    title NVARCHAR(255) NULL,
    file_url NVARCHAR(500) NULL,
    category NVARCHAR(100) NULL,
    material_type NVARCHAR(50) NULL,
    uploaded_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT fk_lecmat_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_lecmat_lecturer FOREIGN KEY (lecturer_id) REFERENCES users(user_id)
);
GO

-- =======================================================
-- 21. NOTIFICATIONS
-- Mô tả: Hệ thống thông báo (in-app, email) gửi đến người dùng.
-- =======================================================
CREATE TABLE notifications (
    notification_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    recipient_id BIGINT NOT NULL,
    triggered_by BIGINT NULL,
    notification_type NVARCHAR(50) NULL,
    related_entity_type NVARCHAR(50) NULL,
    related_entity_id BIGINT NULL,
    subject NVARCHAR(255) NULL,
    body NVARCHAR(MAX) NULL,
    channel NVARCHAR(10) NOT NULL DEFAULT 'IN_APP',
    status NVARCHAR(10) NOT NULL DEFAULT 'PENDING',
    sent_at DATETIME2 DEFAULT SYSDATETIME(),
    is_read BIT NOT NULL DEFAULT 0,

    CONSTRAINT chk_notif_channel CHECK (channel IN ('EMAIL','IN_APP','SMS')),
    CONSTRAINT chk_notif_status CHECK (status IN ('PENDING','SENT','FAILED')),
    CONSTRAINT fk_notif_recipient FOREIGN KEY (recipient_id) REFERENCES users(user_id),
    CONSTRAINT fk_notif_trigger FOREIGN KEY (triggered_by) REFERENCES users(user_id)
);
GO
-- =======================================================
-- 22. AUDIT_LOGS
-- Mô tả: Lưu lịch sử các thao tác của người dùng để Admin quản lý và truy vết.
-- =======================================================
CREATE TABLE audit_logs (
    audit_log_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NULL,
    action NVARCHAR(255) NULL,
    entity_type NVARCHAR(100) NULL,
    entity_id BIGINT NULL,
    old_value NVARCHAR(MAX) NULL,
    new_value NVARCHAR(MAX) NULL,
    ip_address NVARCHAR(45) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO

-- =======================================================
-- 23. LEARNING_OUTCOMES
-- Mô tả: Danh sách các Chuẩn đầu ra môn học (CLO - Course Learning Outcomes).
-- =======================================================
CREATE TABLE learning_outcomes (
    outcome_id BIGINT IDENTITY(1,1) NOT NULL,
    version_id BIGINT NOT NULL,
    code NVARCHAR(20) NOT NULL,
    description NVARCHAR(MAX) NULL,
    bloom_level NVARCHAR(20) NULL,
    display_order INT NULL,

    created_at DATETIME2 NOT NULL
        CONSTRAINT df_learning_outcomes_created_at DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NOT NULL
        CONSTRAINT df_learning_outcomes_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT pk_learning_outcomes
        PRIMARY KEY (outcome_id),

    CONSTRAINT uq_lo_code
        UNIQUE (version_id, code),

    CONSTRAINT chk_bloom_level
        CHECK (
            bloom_level IN (
                N'Remember',
                N'Understand',
                N'Apply',
                N'Analyze',
                N'Evaluate',
                N'Create'
            )
            OR bloom_level IS NULL
        ),

    CONSTRAINT chk_lo_display_order
        CHECK (display_order IS NULL OR display_order > 0),

    CONSTRAINT fk_learning_outcomes_version
        FOREIGN KEY (version_id)
        REFERENCES syllabus_versions(version_id)
        ON DELETE CASCADE
);
GO

-- =======================================================
-- 24. REVIEW_COMMENTS
-- Mô tả: Các bình luận và trao đổi qua lại trong quá trình review đề cương.
-- =======================================================
CREATE TABLE review_comments (
    comment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    review_id BIGINT NOT NULL,
    parent_comment_id BIGINT NULL,
    section_ref NVARCHAR(100) NULL,
    body NVARCHAR(MAX) NULL,
    created_by BIGINT NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    resolved_at DATETIME2 NULL,

    CONSTRAINT fk_review_comments_review FOREIGN KEY (review_id) REFERENCES syllabus_reviews(review_id),
    CONSTRAINT fk_review_comments_creator FOREIGN KEY (created_by) REFERENCES users(user_id),
    CONSTRAINT fk_review_comments_parent FOREIGN KEY (parent_comment_id) REFERENCES review_comments(comment_id)
);
GO

-- =======================================================
-- 25. CURRICULUM_POS
-- Mô tả: Chuẩn đầu ra của Chương trình đào tạo (PO - Program Outcomes).
-- =======================================================
CREATE TABLE curriculum_pos (
    po_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    curriculum_id BIGINT NOT NULL,
    code NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT uq_curriculum_po UNIQUE (curriculum_id, code),
    CONSTRAINT fk_curriculum_pos_curriculum FOREIGN KEY (curriculum_id) REFERENCES curriculums(curriculum_id)
);
GO

-- =======================================================
-- 26. CURRICULUM_PLOS
-- Mô tả: Chuẩn đầu ra cấp chương trình (PLO - Program Learning Outcomes).
-- =======================================================
CREATE TABLE curriculum_plos (
    plo_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    curriculum_id BIGINT NOT NULL,
    code NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT uq_curriculum_plo UNIQUE (curriculum_id, code),
    CONSTRAINT fk_curriculum_plos_curriculum FOREIGN KEY (curriculum_id) REFERENCES curriculums(curriculum_id)
);
GO

-- =======================================================
-- 27. CURRICULUM_PLO_PO_MAPPINGS
-- Mô tả: Bảng ánh xạ ma trận giữa PLO và PO của chương trình đào tạo.
-- =======================================================
CREATE TABLE curriculum_plo_po_mappings (
    plo_id BIGINT NOT NULL,
    po_id BIGINT NOT NULL,
    mapped_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT pk_curriculum_plo_po_mappings PRIMARY KEY (plo_id, po_id),
    CONSTRAINT fk_curriculum_plo_po_mappings_plo FOREIGN KEY (plo_id) REFERENCES curriculum_plos(plo_id),
    CONSTRAINT fk_curriculum_plo_po_mappings_po FOREIGN KEY (po_id) REFERENCES curriculum_pos(po_id)
);
GO

-- =======================================================
-- 28. CURRICULUM_COURSE_PLO_MAPPINGS
-- Mô tả: Bảng ánh xạ môn học đóng góp vào PLO nào của chương trình khung.
-- =======================================================
CREATE TABLE curriculum_course_plo_mappings (
    curriculum_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    plo_id BIGINT NOT NULL,
    mapped_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT pk_curriculum_course_plo_mappings PRIMARY KEY (curriculum_id, course_id, plo_id),
    CONSTRAINT fk_ccpm_curriculum_course FOREIGN KEY (curriculum_id, course_id) REFERENCES curriculum_courses(curriculum_id, course_id) ON DELETE CASCADE,
    CONSTRAINT fk_ccpm_plo FOREIGN KEY (plo_id) REFERENCES curriculum_plos(plo_id) ON DELETE CASCADE
);
GO

-- =======================================================
-- 29. ACCOUNT_REQUESTS
-- Mô tả: Lưu trữ các yêu cầu tạo tài khoản từ Guest để Admin phê duyệt.
-- =======================================================
CREATE TABLE account_requests (
	[request_id] [bigint] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[first_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[requested_by] [bigint] NOT NULL,
	[status] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[requested_at] [datetime2](7) NOT NULL,
	[resolved_at] [datetime2](7) NULL,
	[resolved_by] [bigint] NULL,
	[note] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [uq_account_requests_email] UNIQUE NONCLUSTERED 
(
	[email] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================
-- 30. SHARED_MATERIALS
-- Mô tả: Lưu thông tin các tài liệu mà giảng viên chia sẻ với nhau.
-- =======================================================
CREATE TABLE shared_materials (
	[material_id] [bigint] NOT NULL,
	[shared_with_email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[shared_at] [datetime2](7) NOT NULL,
 CONSTRAINT [pk_shared_materials] PRIMARY KEY CLUSTERED 
(
	[material_id] ASC,
	[shared_with_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[account_requests] ADD  DEFAULT ('PENDING') FOR [status]
GO
ALTER TABLE [dbo].[account_requests] ADD  DEFAULT (sysdatetime()) FOR [requested_at]
GO
ALTER TABLE [dbo].[shared_materials] ADD  DEFAULT (sysdatetime()) FOR [shared_at]
GO
ALTER TABLE [dbo].[account_requests]  WITH CHECK ADD  CONSTRAINT [fk_ar_requested_by] FOREIGN KEY([requested_by])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[account_requests] CHECK CONSTRAINT [fk_ar_requested_by]
GO
ALTER TABLE [dbo].[shared_materials]  WITH CHECK ADD  CONSTRAINT [fk_sm_material] FOREIGN KEY([material_id])
REFERENCES [dbo].[lecturer_materials] ([lecturer_material_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[shared_materials] CHECK CONSTRAINT [fk_sm_material]
GO
ALTER TABLE [dbo].[account_requests]  WITH CHECK ADD  CONSTRAINT [chk_account_requests_status] CHECK  (([status]='REJECTED' OR [status]='APPROVED' OR [status]='PENDING'))
GO
ALTER TABLE [dbo].[account_requests] CHECK CONSTRAINT [chk_account_requests_status]
GO

-- =======================================================
-- 31. SYLLABUS_IMPORT_LOGS
-- Mô tả: Lưu trữ lịch sử import Excel (Designer).
-- =======================================================
CREATE TABLE dbo.syllabus_import_logs (
    import_log_id BIGINT IDENTITY(1,1) NOT NULL,
    assignment_id BIGINT NULL,
    version_id BIGINT NULL,
    file_id BIGINT NULL,

    import_status NVARCHAR(30) NOT NULL,

    total_sheets INT NOT NULL
        CONSTRAINT df_sil_total_sheets DEFAULT 0,
    successful_sheets INT NOT NULL
        CONSTRAINT df_sil_successful_sheets DEFAULT 0,
    empty_sheets INT NOT NULL
        CONSTRAINT df_sil_empty_sheets DEFAULT 0,
    failed_sheets INT NOT NULL
        CONSTRAINT df_sil_failed_sheets DEFAULT 0,

    error_message NVARCHAR(MAX) NULL,

    sheet_result_json NVARCHAR(MAX) NULL,

    imported_by BIGINT NULL,
    imported_at DATETIME2 NOT NULL
        CONSTRAINT df_sil_imported_at DEFAULT SYSDATETIME(),

    CONSTRAINT pk_syllabus_import_logs
        PRIMARY KEY (import_log_id),

    CONSTRAINT chk_sil_import_status
        CHECK (
            import_status IN (
                N'PROCESSING',
                N'SUCCESS',
                N'PARTIAL_SUCCESS',
                N'FAILED'
            )
        ),

    CONSTRAINT chk_sil_sheet_counts
        CHECK (
            total_sheets >= 0
            AND successful_sheets >= 0
            AND empty_sheets >= 0
            AND failed_sheets >= 0
            AND successful_sheets
                + empty_sheets
                + failed_sheets <= total_sheets
        ),

    CONSTRAINT chk_sil_sheet_result_json
        CHECK (
            sheet_result_json IS NULL
            OR ISJSON(sheet_result_json) = 1
        ),

    CONSTRAINT fk_sil_assignment
        FOREIGN KEY (assignment_id)
        REFERENCES dbo.syllabus_assignments(assignment_id),

    CONSTRAINT fk_sil_version
        FOREIGN KEY (version_id)
        REFERENCES dbo.syllabus_versions(version_id),

    CONSTRAINT fk_sil_file
        FOREIGN KEY (file_id)
        REFERENCES dbo.syllabus_version_files(file_id),

    CONSTRAINT fk_sil_imported_by
        FOREIGN KEY (imported_by)
        REFERENCES dbo.users(user_id)
);
GO

CREATE INDEX idx_sil_assignment_imported
ON dbo.syllabus_import_logs(
    assignment_id,
    imported_at DESC
);
GO

CREATE INDEX idx_sil_version_imported
ON dbo.syllabus_import_logs(
    version_id,
    imported_at DESC
);
GO

CREATE INDEX idx_svs_version_order
ON dbo.syllabus_version_sections(
    version_id,
    display_order
);
GO

-- =======================================================
-- 32. SYLLABUS_VERSION_PLO_OPTIONS
-- Mô tả: Snapshot tùy chọn PLO cho từng version (Designer).
-- =======================================================
CREATE TABLE dbo.syllabus_version_plo_options (
    plo_option_id BIGINT IDENTITY(1,1) NOT NULL,
    version_id BIGINT NOT NULL,

    academic_curriculum_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    academic_plo_id BIGINT NOT NULL,

    curriculum_code_snapshot NVARCHAR(100) NULL,
    curriculum_name_snapshot NVARCHAR(255) NULL,
    curriculum_version_snapshot NVARCHAR(20) NULL,
    major_code_snapshot NVARCHAR(50) NULL,
    major_name_snapshot NVARCHAR(255) NULL,
    course_code_snapshot NVARCHAR(20) NULL,
    course_name_snapshot NVARCHAR(255) NULL,
    semester_snapshot INT NULL,

    plo_code_snapshot NVARCHAR(50) NOT NULL,
    plo_description_snapshot NVARCHAR(MAX) NULL,

    curriculum_display_order INT NULL,
    plo_display_order INT NULL,

    captured_at DATETIME2 NOT NULL
        CONSTRAINT df_svpo_captured_at DEFAULT SYSDATETIME(),

    CONSTRAINT pk_syllabus_version_plo_options
        PRIMARY KEY (plo_option_id),

    CONSTRAINT uq_svpo_version_curriculum_course_plo
        UNIQUE (
            version_id,
            academic_curriculum_id,
            course_id,
            academic_plo_id
        ),

    CONSTRAINT chk_svpo_semester
        CHECK (
            semester_snapshot IS NULL
            OR semester_snapshot > 0
        ),

    CONSTRAINT chk_svpo_curriculum_display_order
        CHECK (
            curriculum_display_order IS NULL
            OR curriculum_display_order >= 0
        ),

    CONSTRAINT chk_svpo_plo_display_order
        CHECK (
            plo_display_order IS NULL
            OR plo_display_order >= 0
        ),

    CONSTRAINT fk_svpo_version
        FOREIGN KEY (version_id)
        REFERENCES dbo.syllabus_versions(version_id)
        ON DELETE CASCADE
);
GO

-- =======================================================
-- 33. SYLLABUS_CLO_PLO_MAPPINGS
-- Mô tả: Ánh xạ CLO-PLO theo chuẩn tối ưu hóa (Designer).
-- =======================================================
CREATE TABLE dbo.syllabus_clo_plo_mappings (
    mapping_id BIGINT IDENTITY(1,1) NOT NULL,
    version_id BIGINT NOT NULL,
    outcome_id BIGINT NOT NULL,
    plo_option_id BIGINT NOT NULL,

    contribution_level NVARCHAR(20) NULL,

    created_by BIGINT NULL,
    created_at DATETIME2 NOT NULL
        CONSTRAINT df_scpm_created_at DEFAULT SYSDATETIME(),

    updated_by BIGINT NULL,
    updated_at DATETIME2 NOT NULL
        CONSTRAINT df_scpm_updated_at DEFAULT SYSDATETIME(),

    CONSTRAINT pk_syllabus_clo_plo_mappings
        PRIMARY KEY (mapping_id),

    CONSTRAINT uq_scpm_outcome_option
        UNIQUE (outcome_id, plo_option_id),

    CONSTRAINT chk_scpm_contribution_level
        CHECK (
            contribution_level IS NULL
            OR contribution_level IN (
                N'INTRODUCE',
                N'REINFORCE',
                N'MASTER'
            )
        ),

    CONSTRAINT fk_scpm_version
        FOREIGN KEY (version_id)
        REFERENCES dbo.syllabus_versions(version_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_scpm_outcome
        FOREIGN KEY (outcome_id)
        REFERENCES dbo.learning_outcomes(outcome_id),

    CONSTRAINT fk_scpm_option
        FOREIGN KEY (plo_option_id)
        REFERENCES dbo.syllabus_version_plo_options(plo_option_id),

    CONSTRAINT fk_scpm_created_by
        FOREIGN KEY (created_by)
        REFERENCES dbo.users(user_id),

    CONSTRAINT fk_scpm_updated_by
        FOREIGN KEY (updated_by)
        REFERENCES dbo.users(user_id)
);
GO

CREATE INDEX idx_svpo_version_curriculum
ON dbo.syllabus_version_plo_options(
    version_id,
    academic_curriculum_id,
    course_id,
    plo_code_snapshot
);
GO

CREATE INDEX idx_svpo_academic_plo
ON dbo.syllabus_version_plo_options(
    academic_plo_id,
    version_id
);
GO

CREATE INDEX idx_scpm_version_outcome
ON dbo.syllabus_clo_plo_mappings(
    version_id,
    outcome_id
);
GO

CREATE INDEX idx_scpm_option
ON dbo.syllabus_clo_plo_mappings(
    plo_option_id
);
GO

-- =======================================================
-- COMPATIBILITY READ VIEWS
-- =======================================================
CREATE VIEW dbo.syllabus_general_information
AS
SELECT
    sectionRow.section_id AS general_info_id,
    sectionRow.version_id,

    generalInfo.course_code,
    generalInfo.course_name,
    CAST(NULL AS NVARCHAR(255)) AS english_name,
    generalInfo.credits,
    generalInfo.degree_level,
    generalInfo.time_allocation,
    generalInfo.prerequisite_text,
    generalInfo.course_description,
    CAST(NULL AS NVARCHAR(MAX)) AS tools_required,
    CAST(NULL AS NVARCHAR(MAX)) AS note,

    sectionRow.imported_at AS created_at,
    sectionRow.updated_at
FROM dbo.syllabus_version_sections sectionRow
OUTER APPLY OPENJSON(
    CASE
        WHEN ISJSON(sectionRow.content_text) = 1
        THEN sectionRow.content_text
        ELSE N'{}'
    END
)
WITH (
    course_code NVARCHAR(20) '$.courseCode',
    course_name NVARCHAR(255) '$.courseName',
    credits INT '$.credits',
    degree_level NVARCHAR(100) '$.degreeLevel',
    time_allocation NVARCHAR(500) '$.timeAllocation',
    prerequisite_text NVARCHAR(1000) '$.prerequisiteText',
    course_description NVARCHAR(MAX) '$.courseDescription'
) generalInfo
WHERE sectionRow.section_code = N'GENERAL_INFORMATION';
GO

CREATE VIEW dbo.syllabus_student_tasks
AS
SELECT
    sectionRow.section_id * CAST(100000 AS BIGINT)
        + TRY_CONVERT(BIGINT, taskJson.[key])
        + 1 AS student_task_id,

    sectionRow.version_id,
    TRY_CONVERT(INT, taskJson.[key]) + 1 AS task_order,
    taskData.task_content,

    sectionRow.imported_at AS created_at,
    sectionRow.updated_at
FROM dbo.syllabus_version_sections sectionRow
CROSS APPLY OPENJSON(
    CASE
        WHEN ISJSON(sectionRow.content_text) = 1
        THEN sectionRow.content_text
        ELSE N'[]'
    END
) taskJson
OUTER APPLY OPENJSON(taskJson.[value])
WITH (
    task_content NVARCHAR(MAX) '$.content'
) taskData
WHERE sectionRow.section_code = N'STUDENT_TASKS';
GO

-- =======================================================
-- SEED DATA: ROLES
-- =======================================================
INSERT INTO roles(role_name, description)
VALUES
('ADMIN', 'System Administrator'),
('ACADEMIC_OFFICE', 'Academic Office'),
('LECTURER', 'Lecturer'),
('DESIGNER', 'Syllabus Designer'),
('REVIEWER', 'Syllabus Reviewer'),
('STUDENT', 'Student'),
('EXTERNAL_EXPERT', 'External Expert');
GO

-- =======================================================
-- SEED DATA: REVIEW CRITERIA
-- =======================================================
INSERT INTO review_criteria(
    criteria_code,
    criteria_name,
    description,
    display_order,
    is_required,
    is_active
)
VALUES
(
    'GENERAL_INFORMATION',
    'General Information',
    'Review the general course and syllabus information.',
    1,
    1,
    1
),
(
    'COURSE_LEARNING_OUTCOMES',
    'Course Learning Outcomes',
    'Review the Course Learning Outcomes (CLO).',
    2,
    1,
    1
),
(
    'STUDENT_TASKS',
    'Student Tasks',
    'Review the student tasks and learning responsibilities.',
    3,
    1,
    1
),
(
    'LEARNING_MATERIALS',
    'Learning Materials',
    'Review textbooks, references, and learning resources.',
    4,
    1,
    1
),
(
    'COURSE_SCHEDULE',
    'Course Schedule',
    'Review sessions, topics, activities, CLOs, and ITU terms.',
    5,
    1,
    1
),
(
    'COURSE_ASSESSMENT',
    'Course Assessment',
    'Review assessment components, weights, methods, and CLO coverage.',
    6,
    1,
    1
),
(
    'CLO_PLO_MAPPING',
    'CLO-PLO Mapping',
    'Review CLO-PLO mappings separately for every Curriculum containing the Course.',
    7,
    1,
    1
);
GO

-- =======================================================
-- SEED DATA: MAJORS
-- =======================================================
INSERT INTO majors (code, name, description)
VALUES
-- 1. Nhóm ngành Công nghệ thông tin
('IT', N'Công nghệ thông tin', N'Chuyên ngành Công nghệ thông tin'),
('RAI', N'Robot và Trí tuệ nhân tạo (Định hướng UAV và Humanoid)', N'Chuyên ngành Robot và Trí tuệ nhân tạo'),
('SE', N'Kỹ thuật phần mềm', N'Chuyên ngành Kỹ thuật phần mềm (Software Engineering)'),
('AI', N'Trí tuệ nhân tạo', N'Chuyên ngành Trí tuệ nhân tạo (Artificial Intelligence)'),
('ADS', N'Khoa học dữ liệu ứng dụng', N'Chuyên ngành Khoa học dữ liệu ứng dụng'),
('IA', N'An toàn thông tin', N'Chuyên ngành An toàn thông tin (Information Assurance)'),
('ICD', N'Thiết kế vi mạch bán dẫn', N'Chuyên ngành Thiết kế vi mạch bán dẫn'),
('DAV', N'Công nghệ ô tô số', N'Chuyên ngành Công nghệ ô tô số'),
('IS', N'Hệ thống thông tin', N'Chuyên ngành Hệ thống thông tin'),
('GD', N'Thiết kế đồ họa và mỹ thuật số', N'Chuyên ngành Thiết kế đồ họa và mỹ thuật số (Graphic Design)'),

-- 2. Nhóm ngành Khoa học máy tính
('AIDS', N'Trí tuệ nhân tạo và Khoa học dữ liệu', N'Chuyên ngành Trí tuệ nhân tạo và Khoa học dữ liệu'),
('CNS', N'An ninh mạng và an toàn số', N'Chuyên ngành An ninh mạng và an toàn số'),

-- 3. Nhóm ngành Quản trị kinh doanh
('MKT', N'Marketing', N'Chuyên ngành Marketing'),
('IB', N'Kinh doanh quốc tế', N'Chuyên ngành Kinh doanh quốc tế (International Business)'),
('EC', N'Thương mại điện tử', N'Chuyên ngành Thương mại điện tử (E-Commerce)'),
('BA', N'Quản trị kinh doanh', N'Chuyên ngành Quản trị kinh doanh'),
('EEM', N'Quản trị giải trí và sự kiện', N'Chuyên ngành Quản trị giải trí và sự kiện'),
('CXM', N'Quản trị trải nghiệm khách hàng', N'Chuyên ngành Quản trị trải nghiệm khách hàng'),
('PM', N'Quản trị thu mua', N'Chuyên ngành Quản trị thu mua'),
('BAN', N'Phân tích kinh doanh (Business Analytics)', N'Chuyên ngành Phân tích kinh doanh'),
('LSCM', N'Logistics và Quản lý chuỗi cung ứng toàn cầu', N'Chuyên ngành Logistics và Quản lý chuỗi cung ứng toàn cầu'),
('FT', N'Công nghệ tài chính (Fintech)', N'Chuyên ngành Công nghệ tài chính (Fintech)'),
('CF', N'Tài chính doanh nghiệp', N'Chuyên ngành Tài chính doanh nghiệp'),
('SF', N'Tài chính thông minh', N'Chuyên ngành Tài chính thông minh'),
('BF', N'Tài chính ngân hàng', N'Chuyên ngành Tài chính ngân hàng'),

-- 4. Nhóm ngành Công nghệ truyền thông
('MC', N'Truyền thông đa phương tiện', N'Chuyên ngành Truyền thông đa phương tiện (Multimedia Communications)'),
('PR', N'Quan hệ công chúng', N'Chuyên ngành Quan hệ công chúng (Public Relations)'),
('IMC', N'Truyền thông Marketing tích hợp', N'Chuyên ngành Truyền thông Marketing tích hợp'),
('BM', N'Truyền thông thương hiệu', N'Chuyên ngành Truyền thông thương hiệu'),

-- 5. Nhóm ngành Luật
('LAW', N'Luật', N'Chuyên ngành Luật'),
('ELAW', N'Luật kinh tế', N'Chuyên ngành Luật kinh tế'),

-- 6. Nhóm ngành Ngôn ngữ Anh
('EL', N'Ngôn ngữ Anh', N'Chuyên ngành Ngôn ngữ Anh'),
('BEL', N'Tiếng Anh thương mại', N'Chuyên ngành Tiếng Anh thương mại'),

-- 7. Nhóm ngành Ngôn ngữ Hàn Quốc
('KL', N'Ngôn ngữ Hàn Quốc', N'Chuyên ngành Ngôn ngữ Hàn Quốc'),
('BKL', N'Tiếng Hàn thương mại', N'Chuyên ngành Tiếng Hàn thương mại'),

-- 8. Nhóm ngành Ngôn ngữ Trung Quốc
('CL', N'Ngôn ngữ Trung Quốc', N'Chuyên ngành Ngôn ngữ Trung Quốc'),
('BCL', N'Tiếng Trung thương mại', N'Chuyên ngành Tiếng Trung thương mại');
GO

-- =======================================================
-- SEED DATA: COURSES
-- =======================================================
INSERT INTO courses (code, name, credits, created_at)
VALUES
('VOV124', 'vovinam 2', 2, GETDATE()),
('VOV134', 'vovinam 3', 2, GETDATE()),
('VOV114', 'vovinam 1', 2, GETDATE()),

('TRS601', 'English 6 (University Success)', 2, GETDATE()),
('TMI101', 'Traditional musical instrument', 3, GETDATE()),
('SSL101c', 'Academic Skills for University Success', 3, GETDATE()),

('CSI101', 'Introduction to Computer Science', 3, GETDATE()),
('PRF192', 'Programming Fundamentals', 3, GETDATE()),
('MAE101', 'Mathematics for Engineering', 3, GETDATE()),
('CEA201', 'Computer Organization and Architecture', 3, GETDATE()),
('PRO192', 'C# and .NET Programming', 3, GETDATE()),
('MAD101', 'Discrete Mathematics', 3, GETDATE()),
('OSG202', 'Operating Systems', 3, GETDATE()),
('SSG104', 'Communication and In-Group Working Skills', 3, GETDATE()),

('NWC204', 'Computer Networking', 3, GETDATE()),
('JPD113', 'Elementary Japanese 1-A.1', 3, GETDATE()),
('CSS201', 'Data Structure and Algorithms', 3, GETDATE()),
('DBI202', 'Introduction to Databases', 3, GETDATE()),
('LAB211', 'OOP with Java Lab', 1, GETDATE()),
('WED201c', 'Web Design', 3, GETDATE()),

('MAS291', 'Statistics and Probability', 3, GETDATE()),
('JPD123', 'Elementary Japanese 1-A.2', 3, GETDATE()),
('SWE201c', 'Introduction to Software Engineering', 3, GETDATE()),
('IOT102', 'Internet of Things', 3, GETDATE()),
('PRJ301', 'Java Web Application Development', 3, GETDATE()),
('ITE302c', 'Ethics in IT', 3, GETDATE()),
('SWP391', 'AI-Driven Development project', 3, GETDATE()),

('JPD133', 'Elementary Japanese 1-A.3', 3, GETDATE()),
('SWR302', 'Software Requirements', 3, GETDATE()),
('SWT301', 'Software Testing', 3, GETDATE()),
('UIT202', 'On-job training', 3, GETDATE()),
('ENW492', 'Research Methods & Academic Writing Skills', 3, GETDATE()),

('SWD392', 'SW Architecture and Design', 3, GETDATE()),
('SYB302c', 'Entrepreneurship', 3, GETDATE()),
('JPD316', 'Intermediate Japanese 1-B.1', 6, GETDATE()),
('PMG201c', 'Project Management', 3, GETDATE()),

('MLN111', 'Philosophy of Marxism-Leninism', 3, GETDATE()),
('JFE301', 'Japanese IT Fundamentals', 3, GETDATE()),
('MLN122', 'Political Economics of Marxism-Leninism', 2, GETDATE()),
('WDU203c', 'UI/UX Design', 3, GETDATE()),
('JIT401', 'Information Technology Japanese', 3, GETDATE()),
('PRM392', 'Mobile Programming', 3, GETDATE()),

('HCM202', 'Ho Chi Minh Ideology', 2, GETDATE()),
('MLN131', 'Scientific Socialism', 2, GETDATE()),
('VNR302', 'History of Viet Nam Communist Party', 2, GETDATE());
GO

-- =======================================================
-- SEED DATA: COURSE_PREREQUISITES
-- =======================================================
INSERT INTO course_prerequisites(course_id, prerequisite_course_id)
SELECT c.course_id, p.course_id
FROM (
    VALUES
    ('VOV124','VOV114'),
    ('VOV134','VOV124'),
    ('JPD123','JPD113'),
    ('JPD133','JPD123'),
    ('JPD316','JPD133'),
    ('JIT401','JFE301'),
    ('PRO192','PRF192'),
    ('LAB211','PRO192'),
    ('CSS201','PRO192'),
    ('DBI202','PRF192'),
    ('PRJ301','LAB211'),
    ('PRJ301','DBI202'),
    ('OSG202','CEA201'),
    ('NWC204','CEA201'),
    ('IOT102','NWC204'),
    ('SWE201c','CSS201'),
    ('SWR302','SWE201c'),
    ('SWT301','SWE201c'),
    ('PMG201c','SWE201c'),
    ('SWP391','SWE201c'),
    ('SWD392','SWE201c'),
    ('SWD392','PRJ301'),
    ('PRM392','PRJ301'),
    ('UIT202','SWP391'),
    ('ENW492','SWR302'),
    ('MLN122','MLN111'),
    ('MLN131','MLN122'),
    ('HCM202','MLN131'),
    ('VNR302','HCM202')
) AS cp(course_code, prereq_code)
JOIN courses c ON c.code = cp.course_code
JOIN courses p ON p.code = cp.prereq_code;
GO

-- =======================================================
-- SEED DATA: CURRICULUM (BIT_SE_K19)
-- =======================================================
DECLARE @MajorId BIGINT;
SELECT @MajorId = major_id FROM majors WHERE code = 'SE';

IF @MajorId IS NOT NULL
BEGIN
    INSERT INTO curriculums (
        major_id, 
        curriculum_code,
        name, 
        is_active, 
        description, 
        decision_no, 
        issued_date, 
        total_credits, 
        version, 
        total_semesters
    )
    VALUES (
        @MajorId, 
        'BIT_SE_K19',
        N'Bachelor Program of Information Technology, Software Engineering Major (Chương trình cử nhân ngành CNTT, chuyên ngành Kỹ thuật phần mềm)', 
        1, 
        N'Training Information Technology (IT)/Software Engineering (SE) specialty engineers with personality and capacity to meet the needs of society, mastering professional knowledge and practice, being able to organize, implement and promote the creativity in jobs related to the trained specialty as well as pursue further education and research. Volume of learning: 141 credits, excluding Preparation English, Military Training, compulsory and elective training activities.', 
        '669/QĐ-ĐHFPT', 
        '2023-12-12', 
        141, 
        '1.0', 
        9
    );

    DECLARE @CurriculumId BIGINT = SCOPE_IDENTITY();

    -- POs
    INSERT INTO curriculum_pos (curriculum_id, code, description) VALUES
    (@CurriculumId, 'PO1', N'Having basic knowledge of social sciences, politics and law, security and defense, foundational knowledge of the IT industry & in-depth knowledge of the specialized training: techniques, methods, technologies, in-depth application areas; development trends in the world; at the same time understand the overall market, context, functions and tasks of the professions in the specialized training.'),
    (@CurriculumId, 'PO2', N'Be able to work as a full member of a professional team in the field of training: participate in designing, selecting techniques and technologies in line with development trends, solving technical problems; understand technology trends and user requirements; can do the complete solution development plan; performance management and change management in his or her part of the job; understand state policies in specialized fields.'),
    (@CurriculumId, 'PO3', N'Mastering professional skills and soft skills of 21st century citizens (thinking skills, work skills, skills in using work tools, life skills in a global society); at the same time, equip knowledge and sharpen the entrepreneurship mindset and entrepreneurial experience.'),
    (@CurriculumId, 'PO4', N'Can use English well in study and work and a second foreign language in normal communication.'),
    (@CurriculumId, 'PO5', N'Honesty, high discipline in study and work; dynamic, creative, and possessing a continuous learning mindset. Capable of learning and improving skills after graduation. Demonstrates a professional attitude and behavior with the ability to generate ideas, design, implement, and operate systems within the context of business and society.');

    -- PLOs
    INSERT INTO curriculum_plos (curriculum_id, code, description) VALUES
    (@CurriculumId, 'PLO1', N'Demonstrate basic knowledge of social sciences, politics and law, national security and defense, contributing to the formation of worldview and scientific methodology.'),
    (@CurriculumId, 'PLO2', N'Demonstrate the mindset and ability to implement start-up projects, creative spirits, critical thinking and problem-solving skills.'),
    (@CurriculumId, 'PLO3', N'Communicating and working in groups effectively in academic and practical environments.'),
    (@CurriculumId, 'PLO4', N'Use English proficiently in communication and learning (equivalent to level 4 according to the 6-level Foreign Language Proficiency Framework for Vietnam, IELTS 6.0 or TOEFL (paper) 575-600 or TOEFL (iBT) 90 -100); and be able to communicate simply in Japanese.'),
    (@CurriculumId, 'PLO5', N'Demonstrate professional behaviors, morality, social responsibilities and a sense of dedication to community.'),
    (@CurriculumId, 'PLO6', N'Be mentally and physically strong, be capable of expressing national identity and integrating confidently into the world.'),
    (@CurriculumId, 'PLO7', N'Develop self-study and lifelong learning spirit and capabilities to adapt to the constant change of technology and society.'),
    (@CurriculumId, 'PLO8', N'Be able to explain and apply essential mathematical knowledge related to information technology: Calculus, discrete math, linear algebra.'),
    (@CurriculumId, 'PLO9', N'Be able to explain at a basic level the concepts related to computer architecture, operating systems, computer networks, databases...'),
    (@CurriculumId, 'PLO10', N'Be able to apply knowledge of programming, software development (including data structures and algorithms, programming techniques, object-oriented programming...) to develop applications'),
    (@CurriculumId, 'PLO11', N'Be able to explain different viewpoints on professional ethics, the role of careers in the IT field and related skills to choose the right major in the later stage.'),
    (@CurriculumId, 'PLO12', N'Be able to apply knowledge of business, society, knowledge of management (especially project management) in professional work.'),
    (@CurriculumId, 'PLO13', N'Be able to explain the roles and responsibilities of a software engineering specialist.'),
    (@CurriculumId, 'PLO14', N'Be able to explain the software development and production process; apply relevant theories, models, and techniques to various issues such as problem identification and analysis, design, development, testing, and implementation of software.'),
    (@CurriculumId, 'PLO15', N'Be able to build software systems: web applications, mobile applications, open source applications that meet requirements.'),
    (@CurriculumId, 'PLO16', N'Be able to evaluate techniques and technologies related to software engineering, highlighting strengths and weaknesses of techniques and technologies.'),
    (@CurriculumId, 'PLO17', N'Be able to update and utilize advanced tools and techniques in the field of software engineering in particular and IT in general.'),
    (@CurriculumId, 'PLO18', N'Have in-depth knowledge and skills in the persuited major or extensive knowledge and skills in the major close to the persuited major.');

    -- Mapping PLO - PO
    INSERT INTO curriculum_plo_po_mappings (plo_id, po_id)
    SELECT plo.plo_id, po.po_id
    FROM (
        VALUES
        ('PLO1', 'PO1'),
        ('PLO2', 'PO1'), ('PLO2', 'PO3'), ('PLO2', 'PO5'),
        ('PLO3', 'PO3'), ('PLO3', 'PO5'),
        ('PLO4', 'PO2'), ('PLO4', 'PO4'),
        ('PLO5', 'PO5'),
        ('PLO6', 'PO2'),
        ('PLO7', 'PO4'), ('PLO7', 'PO5'),
        ('PLO8', 'PO1'),
        ('PLO9', 'PO1'),
        ('PLO10', 'PO1'),
        ('PLO12', 'PO3'), ('PLO12', 'PO5'),
        ('PLO14', 'PO3'),
        ('PLO15', 'PO3'),
        ('PLO16', 'PO3'),
        ('PLO17', 'PO1'), ('PLO17', 'PO2'), ('PLO17', 'PO3'), ('PLO17', 'PO4'),
        ('PLO18', 'PO1'), ('PLO18', 'PO2'), ('PLO18', 'PO4')
    ) AS mapping(plo_code, po_code)
    JOIN curriculum_plos plo ON plo.code = mapping.plo_code AND plo.curriculum_id = @CurriculumId
    JOIN curriculum_pos po ON po.code = mapping.po_code AND po.curriculum_id = @CurriculumId;

    -- Curriculum Courses Mapping
    INSERT INTO curriculum_courses (curriculum_id, course_id, semester, knowledge_block)
    SELECT @CurriculumId, c.course_id, t.semester, t.knowledge_block
    FROM (
        VALUES
        ('VOV114', 1, N'General knowledge and skills_Khối Kiến thức chung'),
        ('TRS601', 1, N'General knowledge and skills_Khối Kiến thức chung'),
        ('SSL101c', 1, N'General knowledge and skills_Khối Kiến thức chung'),
        ('CSI101', 1, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('PRF192', 1, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('MAE101', 1, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('MLN111', 1, N'General knowledge and skills_Khối Kiến thức chung'),
        ('SSG104', 1, N'General knowledge and skills_Khối Kiến thức chung'),

        ('VOV124', 2, N'General knowledge and skills_Khối Kiến thức chung'),
        ('TMI101', 2, N'General knowledge and skills_Khối Kiến thức chung'),
        ('CEA201', 2, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('PRO192', 2, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('MAD101', 2, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('DBI202', 2, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('MLN122', 2, N'General knowledge and skills_Khối Kiến thức chung'),

        ('VOV134', 3, N'General knowledge and skills_Khối Kiến thức chung'),
        ('OSG202', 3, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('NWC204', 3, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('JPD113', 3, N'General knowledge and skills_Khối Kiến thức chung'),
        ('CSS201', 3, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('LAB211', 3, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('WED201c', 3, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('MLN131', 3, N'General knowledge and skills_Khối Kiến thức chung'),

        ('JPD123', 4, N'General knowledge and skills_Khối Kiến thức chung'),
        ('MAS291', 4, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('PRJ301', 4, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),
        ('SWE201c', 4, N'Major knowledge and skills_Khối kiến thức ngành'),
        ('HCM202', 4, N'General knowledge and skills_Khối Kiến thức chung'),
        ('WDU203c', 4, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),

        ('JPD133', 5, N'General knowledge and skills_Khối Kiến thức chung'),
        ('IOT102', 5, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),
        ('SWR302', 5, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),
        ('SWT301', 5, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),
        ('PMG201c', 5, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),
        ('SWP391', 5, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),
        ('VNR302', 5, N'General knowledge and skills_Khối Kiến thức chung'),

        ('UIT202', 6, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),
        ('ENW492', 6, N'General knowledge and skills_Khối Kiến thức chung'),
        ('ITE302c', 6, N'Major knowledge and skills_Khối kiến thức ngành'),

        ('SWD392', 7, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),
        ('SYB302c', 7, N'General knowledge and skills_Khối Kiến thức chung'),
        ('JPD316', 7, N'General knowledge and skills_Khối Kiến thức chung'),
        ('JFE301', 7, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),
        ('PRM392', 7, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành'),

        ('JIT401', 8, N'Specialized knowledge and skills _Khối kiến thức chuyên ngành')
    ) AS t(course_code, semester, knowledge_block)
    JOIN courses c ON c.code = t.course_code;

    -- Curriculum Course PLO Mappings
    INSERT INTO curriculum_course_plo_mappings (curriculum_id, course_id, plo_id)
    SELECT @CurriculumId, c.course_id, plo.plo_id
    FROM (
        VALUES
        ('VOV114', 'PLO6'), ('VOV124', 'PLO6'), ('VOV134', 'PLO6'),
        ('TRS601', 'PLO4'),
        ('SSL101c', 'PLO3'), ('SSL101c', 'PLO7'),
        ('CSI101', 'PLO9'),
        ('PRF192', 'PLO10'),
        ('MAE101', 'PLO8'),
        ('MLN111', 'PLO1'),
        ('SSG104', 'PLO3'),
        ('TMI101', 'PLO6'),
        ('CEA201', 'PLO9'),
        ('PRO192', 'PLO10'),
        ('MAD101', 'PLO8'),
        ('DBI202', 'PLO9'), ('DBI202', 'PLO10'),
        ('MLN122', 'PLO1'),
        ('OSG202', 'PLO9'),
        ('NWC204', 'PLO9'),
        ('JPD113', 'PLO4'), ('JPD123', 'PLO4'), ('JPD133', 'PLO4'), ('JPD316', 'PLO4'),
        ('CSS201', 'PLO10'),
        ('LAB211', 'PLO10'),
        ('WED201c', 'PLO10'), ('WED201c', 'PLO15'),
        ('MLN131', 'PLO1'),
        ('MAS291', 'PLO8'),
        ('PRJ301', 'PLO10'), ('PRJ301', 'PLO15'),
        ('SWE201c', 'PLO14'),
        ('HCM202', 'PLO1'),
        ('WDU203c', 'PLO14'),
        ('IOT102', 'PLO17'),
        ('SWR302', 'PLO14'),
        ('SWT301', 'PLO14'),
        ('PMG201c', 'PLO12'),
        ('SWP391', 'PLO2'), ('SWP391', 'PLO3'), ('SWP391', 'PLO15'),
        ('VNR302', 'PLO1'),
        ('UIT202', 'PLO12'), ('UIT202', 'PLO13'),
        ('ENW492', 'PLO2'),
        ('ITE302c', 'PLO5'), ('ITE302c', 'PLO11'),
        ('SWD392', 'PLO14'), ('SWD392', 'PLO16'),
        ('SYB302c', 'PLO2'),
        ('JFE301', 'PLO4'), ('JFE301', 'PLO18'),
        ('PRM392', 'PLO15'),
        ('JIT401', 'PLO4'), ('JIT401', 'PLO18')
    ) AS cp_map(course_code, plo_code)
    JOIN courses c ON c.code = cp_map.course_code
    JOIN curriculum_plos plo ON plo.code = cp_map.plo_code AND plo.curriculum_id = @CurriculumId;
END
GO

-- =======================================================
-- SEED DATA: USERS AND USER ROLES
-- =======================================================
DECLARE @CurrentUserId BIGINT;
DECLARE @RoleId BIGINT;

-- 1. ADMIN (Account)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin.local')
BEGIN
    INSERT INTO users (username, first_name, last_name, email, password_hash, auth_provider, is_external, must_change_password, status)
    VALUES (N'admin.local', N'Quản Trị', N'Nguyễn', N'admin.local@lmlf.edu.vn', N'$2a$12$hTZK.nYKr3LDGQGHqjIxLugnX5wTFZuRcknKS79w0XmkCn.VZesZ2', 'LOCAL', 0, 1, 'ACTIVE');
    SET @CurrentUserId = SCOPE_IDENTITY();
    SELECT @RoleId = role_id FROM roles WHERE role_name = 'ADMIN';
    INSERT INTO user_roles (user_id, role_id) VALUES (@CurrentUserId, @RoleId);
END

-- 2. ACADEMIC_OFFICE (Account)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'daotao.local')
BEGIN
    INSERT INTO users (username, first_name, last_name, email, password_hash, auth_provider, is_external, must_change_password, status)
    VALUES (N'daotao.local', N'Phòng', N'Đào Tạo', N'daotao.local@lmlf.edu.vn', N'$2a$12$hTZK.nYKr3LDGQGHqjIxLugnX5wTFZuRcknKS79w0XmkCn.VZesZ2', 'LOCAL', 0, 0, 'ACTIVE');
    SET @CurrentUserId = SCOPE_IDENTITY();
    SELECT @RoleId = role_id FROM roles WHERE role_name = 'ACADEMIC_OFFICE';
    INSERT INTO user_roles (user_id, role_id) VALUES (@CurrentUserId, @RoleId);
END

-- 3. LECTURER (Account)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'giangvien.local')
BEGIN
    INSERT INTO users (username, first_name, last_name, email, password_hash, auth_provider, is_external, must_change_password, status)
    VALUES (N'giangvien.local', N'Văn Giảng', N'Lê', N'giangvien.local@lmlf.edu.vn', N'$2a$12$hTZK.nYKr3LDGQGHqjIxLugnX5wTFZuRcknKS79w0XmkCn.VZesZ2', 'LOCAL', 0, 0, 'ACTIVE');
    SET @CurrentUserId = SCOPE_IDENTITY();
    SELECT @RoleId = role_id FROM roles WHERE role_name = 'LECTURER';
    INSERT INTO user_roles (user_id, role_id) VALUES (@CurrentUserId, @RoleId);
END

-- 4. DESIGNER (Account)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'designer.local')
BEGIN
    INSERT INTO users (username, first_name, last_name, email, password_hash, auth_provider, is_external, must_change_password, status)
    VALUES (N'designer.local', N'Thiết Kế', N'Trần', N'designer.local@lmlf.edu.vn', N'$2a$12$hTZK.nYKr3LDGQGHqjIxLugnX5wTFZuRcknKS79w0XmkCn.VZesZ2', 'LOCAL', 0, 0, 'ACTIVE');
    SET @CurrentUserId = SCOPE_IDENTITY();
    SELECT @RoleId = role_id FROM roles WHERE role_name = 'DESIGNER';
    INSERT INTO user_roles (user_id, role_id) VALUES (@CurrentUserId, @RoleId);
END

-- 5. REVIEWER (Account)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'reviewer.local')
BEGIN
    INSERT INTO users (username, first_name, last_name, email, password_hash, auth_provider, is_external, must_change_password, status)
    VALUES (N'reviewer.local', N'Kiểm Duyệt', N'Phạm', N'reviewer.local@lmlf.edu.vn', N'$2a$12$hTZK.nYKr3LDGQGHqjIxLugnX5wTFZuRcknKS79w0XmkCn.VZesZ2', 'LOCAL', 0, 0, 'ACTIVE');
    SET @CurrentUserId = SCOPE_IDENTITY();
    SELECT @RoleId = role_id FROM roles WHERE role_name = 'REVIEWER';
    INSERT INTO user_roles (user_id, role_id) VALUES (@CurrentUserId, @RoleId);
END

-- 6. STUDENT (Account)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'sinhvien.local')
BEGIN
    INSERT INTO users (username, first_name, last_name, email, password_hash, auth_provider, is_external, must_change_password, status)
    VALUES (N'sinhvien.local', N'Văn Học', N'Hoàng', N'sinhvien.local@lmlf.edu.vn', N'$2a$12$hTZK.nYKr3LDGQGHqjIxLugnX5wTFZuRcknKS79w0XmkCn.VZesZ2', 'LOCAL', 0, 0, 'ACTIVE');
    SET @CurrentUserId = SCOPE_IDENTITY();
    SELECT @RoleId = role_id FROM roles WHERE role_name = 'STUDENT';
    INSERT INTO user_roles (user_id, role_id) VALUES (@CurrentUserId, @RoleId);
END

-- 7. Additional LECTURERS (Lecture accounts)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'giangvien1.local')
BEGIN
    INSERT INTO users (username, first_name, last_name, email, password_hash, auth_provider, is_external, must_change_password, status)
    VALUES (N'giangvien1.local', N'Ngọc Anh', N'Phạm', N'giangvien1.local@lmlf.edu.vn', N'$2a$12$hTZK.nYKr3LDGQGHqjIxLugnX5wTFZuRcknKS79w0XmkCn.VZesZ2', 'LOCAL', 0, 0, 'ACTIVE');
    SET @CurrentUserId = SCOPE_IDENTITY();
    SELECT @RoleId = role_id FROM roles WHERE role_name = 'LECTURER';
    INSERT INTO user_roles (user_id, role_id) VALUES (@CurrentUserId, @RoleId);
END

IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'giangvien2.local')
BEGIN
    INSERT INTO users (username, first_name, last_name, email, password_hash, auth_provider, is_external, must_change_password, status)
    VALUES (N'giangvien2.local', N'Thị Bình', N'Nguyễn', N'giangvien2.local@lmlf.edu.vn', N'$2a$12$hTZK.nYKr3LDGQGHqjIxLugnX5wTFZuRcknKS79w0XmkCn.VZesZ2', 'LOCAL', 0, 0, 'ACTIVE');
    SET @CurrentUserId = SCOPE_IDENTITY();
    SELECT @RoleId = role_id FROM roles WHERE role_name = 'LECTURER';
    INSERT INTO user_roles (user_id, role_id) VALUES (@CurrentUserId, @RoleId);
END

IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'giangvien3.local')
BEGIN
    INSERT INTO users (username, first_name, last_name, email, password_hash, auth_provider, is_external, must_change_password, status)
    VALUES (N'giangvien3.local', N'Minh Đức', N'Trần', N'giangvien3.local@lmlf.edu.vn', N'$2a$12$hTZK.nYKr3LDGQGHqjIxLugnX5wTFZuRcknKS79w0XmkCn.VZesZ2', 'LOCAL', 0, 0, 'ACTIVE');
    SET @CurrentUserId = SCOPE_IDENTITY();
    SELECT @RoleId = role_id FROM roles WHERE role_name = 'LECTURER';
    INSERT INTO user_roles (user_id, role_id) VALUES (@CurrentUserId, @RoleId);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.syllabus_versions')
      AND name = 'uq_one_published_per_syllabus'
)
BEGIN
    CREATE UNIQUE INDEX uq_one_published_per_syllabus
    ON dbo.syllabus_versions(syllabus_id)
    WHERE status = 'PUBLISHED';
END;
GO

-- =======================================================
-- READY-TO-USE TEST ACCOUNTS
-- Password for every account below: Test@123
-- =======================================================
DECLARE @TestPasswordHash NVARCHAR(255)
    = N'$2a$10$fqsbT4Bymk2P8gAnZ/50COAguJ4DKzQfo5Z/.jz53iTVN4xlOXpWy';

DECLARE @TestUsers TABLE (
    username NVARCHAR(50),
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    email NVARCHAR(255),
    role_name NVARCHAR(50)
);

INSERT INTO @TestUsers (
    username,
    first_name,
    last_name,
    email,
    role_name
)
VALUES
(
    N'academic.test',
    N'Academic',
    N'Office',
    N'academic.test@lmlf.local',
    N'ACADEMIC_OFFICE'
),
(
    N'designer.test',
    N'Designer',
    N'Test',
    N'designer.test@lmlf.local',
    N'DESIGNER'
),
(
    N'reviewer1.test',
    N'Reviewer',
    N'One',
    N'reviewer1.test@lmlf.local',
    N'REVIEWER'
),
(
    N'reviewer2.test',
    N'Reviewer',
    N'Two',
    N'reviewer2.test@lmlf.local',
    N'REVIEWER'
);

DECLARE
    @SeedUsername NVARCHAR(50),
    @SeedFirstName NVARCHAR(100),
    @SeedLastName NVARCHAR(100),
    @SeedEmail NVARCHAR(255),
    @SeedRoleName NVARCHAR(50),
    @SeedUserId BIGINT,
    @SeedRoleId BIGINT;

DECLARE TestUserCursor CURSOR LOCAL FAST_FORWARD FOR
SELECT
    username,
    first_name,
    last_name,
    email,
    role_name
FROM @TestUsers;

OPEN TestUserCursor;

FETCH NEXT FROM TestUserCursor INTO
    @SeedUsername,
    @SeedFirstName,
    @SeedLastName,
    @SeedEmail,
    @SeedRoleName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @SeedUserId = user_id
    FROM dbo.users
    WHERE email = @SeedEmail;

    IF @SeedUserId IS NULL
    BEGIN
        INSERT INTO dbo.users (
            username,
            first_name,
            last_name,
            email,
            password_hash,
            auth_provider,
            is_external,
            must_change_password,
            status,
            deleted_at
        )
        VALUES (
            @SeedUsername,
            @SeedFirstName,
            @SeedLastName,
            @SeedEmail,
            @TestPasswordHash,
            N'LOCAL',
            0,
            0,
            N'ACTIVE',
            NULL
        );

        SET @SeedUserId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.users
        SET username = @SeedUsername,
            first_name = @SeedFirstName,
            last_name = @SeedLastName,
            password_hash = @TestPasswordHash,
            auth_provider = N'LOCAL',
            is_external = 0,
            must_change_password = 0,
            status = N'ACTIVE',
            deleted_at = NULL
        WHERE user_id = @SeedUserId;
    END;

    SELECT @SeedRoleId = role_id
    FROM dbo.roles
    WHERE role_name = @SeedRoleName;

    IF @SeedRoleId IS NULL
    BEGIN
        THROW 52001, 'Required system role is missing.', 1;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.user_roles
        WHERE user_id = @SeedUserId
          AND role_id = @SeedRoleId
    )
    BEGIN
        INSERT INTO dbo.user_roles (
            user_id,
            role_id
        )
        VALUES (
            @SeedUserId,
            @SeedRoleId
        );
    END;

    SET @SeedUserId = NULL;
    SET @SeedRoleId = NULL;

    FETCH NEXT FROM TestUserCursor INTO
        @SeedUsername,
        @SeedFirstName,
        @SeedLastName,
        @SeedEmail,
        @SeedRoleName;
END;

CLOSE TestUserCursor;
DEALLOCATE TestUserCursor;
GO

-- =======================================================
-- FINAL DATABASE VERIFICATION
-- =======================================================
DECLARE @ExpectedTables TABLE (
    table_name SYSNAME PRIMARY KEY
);

INSERT INTO @ExpectedTables (table_name)
VALUES
        (N'users'),
        (N'roles'),
        (N'user_roles'),
        (N'majors'),
        (N'curriculums'),
        (N'courses'),
        (N'curriculum_courses'),
        (N'course_prerequisites'),
        (N'curriculum_pos'),
        (N'curriculum_plos'),
        (N'curriculum_plo_po_mappings'),
        (N'curriculum_course_plo_mappings'),
        (N'syllabuses'),
        (N'syllabus_assignments'),
        (N'syllabus_assignment_reviewers'),
        (N'syllabus_versions'),
        (N'syllabus_version_files'),
        (N'syllabus_version_sections'),
        (N'learning_outcomes'),
        (N'syllabus_import_logs'),
        (N'syllabus_version_plo_options'),
        (N'syllabus_clo_plo_mappings'),
        (N'review_criteria'),
        (N'syllabus_version_review_assignments'),
        (N'syllabus_reviews'),
        (N'syllabus_review_sections'),
        (N'review_comments'),
        (N'learning_materials'),
        (N'lecturer_materials'),
        (N'account_requests'),
        (N'shared_materials'),
        (N'notifications'),
        (N'audit_logs');

SELECT
    expected.table_name,
    CASE
        WHEN OBJECT_ID(N'dbo.' + expected.table_name, N'U') IS NOT NULL
        THEN N'PASS'
        ELSE N'FAIL'
    END AS verification_result
FROM @ExpectedTables expected
ORDER BY
    CASE
        WHEN OBJECT_ID(N'dbo.' + expected.table_name, N'U') IS NULL
        THEN 0
        ELSE 1
    END,
    expected.table_name;

SELECT
    COUNT(*) AS expected_table_count,
    SUM(
        CASE
            WHEN OBJECT_ID(N'dbo.' + table_name, N'U') IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS existing_table_count
FROM @ExpectedTables;

DECLARE @ExpectedViews TABLE (
    view_name SYSNAME PRIMARY KEY
);

INSERT INTO @ExpectedViews (view_name)
VALUES
    (N'syllabus_general_information'),
    (N'syllabus_student_tasks');

SELECT
    expected.view_name,
    CASE
        WHEN OBJECT_ID(N'dbo.' + expected.view_name, N'V') IS NOT NULL
        THEN N'PASS'
        ELSE N'FAIL'
    END AS verification_result
FROM @ExpectedViews expected
ORDER BY expected.view_name;

SELECT
    COUNT(*) AS expected_view_count,
    SUM(
        CASE
            WHEN OBJECT_ID(N'dbo.' + view_name, N'V') IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS existing_view_count
FROM @ExpectedViews;

SELECT
    criteria_code,
    criteria_name,
    display_order,
    is_required,
    is_active
FROM dbo.review_criteria
ORDER BY display_order;

SELECT
    userAccount.email,
    roleRow.role_name,
    userAccount.status
FROM dbo.users userAccount
INNER JOIN dbo.user_roles userRole
    ON userRole.user_id = userAccount.user_id
INNER JOIN dbo.roles roleRow
    ON roleRow.role_id = userRole.role_id
WHERE userAccount.email IN (
    N'academic.test@lmlf.local',
    N'designer.test@lmlf.local',
    N'reviewer1.test@lmlf.local',
    N'reviewer2.test@lmlf.local'
)
ORDER BY roleRow.role_name, userAccount.email;

PRINT 'LMLF OPTIMIZED FULL DATABASE BUILD COMPLETED: 33 TABLES + 2 VIEWS.';
GO
