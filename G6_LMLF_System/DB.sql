-- LMLF Database Schema
-- SQL Server (T-SQL)

IF DB_ID('LMLF') IS NULL
BEGIN
    CREATE DATABASE LMLF;
END
GO


USE LMLF;
GO

CREATE TABLE users (
    user_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    status NVARCHAR(20) DEFAULT 'ACTIVE',
    registered_at DATETIME2 NOT NULL,
    last_login DATETIME2,
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT chk_users_status CHECK (status IN ('ACTIVE','INACTIVE','BANNED'))
);

CREATE TABLE roles (
    role_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX),
    CONSTRAINT uq_roles_name UNIQUE (role_name)
);

CREATE TABLE user_roles (
    user_role_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    assigned_at DATETIME2 NOT NULL,
    CONSTRAINT uq_user_roles UNIQUE (user_id, role_id),
    CONSTRAINT fk_userroles_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_userroles_role FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE majors (
    major_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(20) NOT NULL,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    created_by BIGINT,
    created_at DATETIME2 NOT NULL,
    CONSTRAINT uq_majors_code UNIQUE (code),
    CONSTRAINT fk_majors_user FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE curriculums (
    curriculum_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    major_id BIGINT NOT NULL,
    version NVARCHAR(20) NOT NULL,
    status NVARCHAR(20) NOT NULL,
    total_semesters INT NOT NULL,
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,
    CONSTRAINT chk_curriculums_status CHECK (status IN ('DRAFT','ACTIVE','ARCHIVED')),
    CONSTRAINT fk_curriculums_major FOREIGN KEY (major_id) REFERENCES majors(major_id)
);

CREATE TABLE courses (
    course_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(20) NOT NULL,
    name NVARCHAR(255) NOT NULL,
    credits INT NOT NULL,
    created_at DATETIME2 NOT NULL,
    CONSTRAINT uq_courses_code UNIQUE (code)
);

CREATE TABLE curriculum_courses (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    curriculum_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    semester INT NOT NULL,
    CONSTRAINT uq_curriculum_courses UNIQUE (curriculum_id, course_id),
    CONSTRAINT fk_currcourses_curriculum FOREIGN KEY (curriculum_id) REFERENCES curriculums(curriculum_id),
    CONSTRAINT fk_currcourses_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE course_prerequisites (
    course_prerequisite_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    prerequisite_course_id BIGINT NOT NULL,
    CONSTRAINT uq_course_prerequisites UNIQUE (course_id, prerequisite_course_id),
    CONSTRAINT fk_prereq_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_prereq_prereq FOREIGN KEY (prerequisite_course_id) REFERENCES courses(course_id)
);

CREATE TABLE syllabuses (
    syllabus_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    current_version NVARCHAR(20),
    status NVARCHAR(20),
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,
    CONSTRAINT chk_syllabuses_status CHECK (status IN ('DRAFT','PUBLISHED','ARCHIVED')),
    CONSTRAINT fk_syllabuses_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE syllabus_assignments (
    assignment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    designer_id BIGINT NOT NULL,
    reviewer_id BIGINT NOT NULL,
    semester NVARCHAR(20),
    academic_year INT,
    assigned_at DATETIME2 NOT NULL,
    CONSTRAINT chk_assignment_diff CHECK (designer_id <> reviewer_id),
    CONSTRAINT fk_assign_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_assign_designer FOREIGN KEY (designer_id) REFERENCES users(user_id),
    CONSTRAINT fk_assign_reviewer FOREIGN KEY (reviewer_id) REFERENCES users(user_id)
);

CREATE TABLE syllabus_versions (
    version_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    syllabus_id BIGINT NOT NULL,
    version_number NVARCHAR(20) NOT NULL,
    change_type NVARCHAR(10),
    description_of_changes NVARCHAR(MAX),
    status NVARCHAR(20),
    submitted_at DATETIME2,
    approved_at DATETIME2,
    created_by BIGINT NOT NULL,
    CONSTRAINT uq_syllabus_version UNIQUE (syllabus_id, version_number),
    CONSTRAINT chk_sv_change_type CHECK (change_type IN ('NEW','MINOR','MAJOR')),
    CONSTRAINT chk_sv_status CHECK (status IN ('DRAFT','SUBMITTED','APPROVED','REJECTED')),
    CONSTRAINT fk_sv_syllabus FOREIGN KEY (syllabus_id) REFERENCES syllabuses(syllabus_id),
    CONSTRAINT fk_sv_creator FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE syllabus_reviews (
    review_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    version_id BIGINT NOT NULL,
    reviewer_id BIGINT NOT NULL,
    decision NVARCHAR(20),
    comment NVARCHAR(MAX),
    reviewed_at DATETIME2 NOT NULL,
    CONSTRAINT chk_sr_decision CHECK (decision IN ('APPROVED','REJECTED','REVISION_NEEDED')),
    CONSTRAINT fk_sr_version FOREIGN KEY (version_id) REFERENCES syllabus_versions(version_id),
    CONSTRAINT fk_sr_reviewer FOREIGN KEY (reviewer_id) REFERENCES users(user_id)
);

CREATE TABLE learning_materials (
    material_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    version_id BIGINT NOT NULL,
    uploaded_by BIGINT NOT NULL,
    material_type NVARCHAR(20),
    title NVARCHAR(255),
    file_url NVARCHAR(500),
    file_size BIGINT,
    access_level NVARCHAR(20),
    uploaded_at DATETIME2 NOT NULL,
    CONSTRAINT chk_lm_type CHECK (material_type IN ('SLIDE','DOCUMENT','VIDEO','REFERENCE','OTHER')),
    CONSTRAINT chk_lm_access CHECK (access_level IN ('PUBLIC','STUDENTS_ONLY','LECTURERS_ONLY')),
    CONSTRAINT fk_lm_version FOREIGN KEY (version_id) REFERENCES syllabus_versions(version_id),
    CONSTRAINT fk_lm_uploader FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

CREATE TABLE lecturer_materials (
    lecturer_material_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    lecturer_id BIGINT NOT NULL,
    title NVARCHAR(255),
    file_url NVARCHAR(500),
    uploaded_at DATETIME2 NOT NULL,
    CONSTRAINT fk_lecmat_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_lecmat_lecturer FOREIGN KEY (lecturer_id) REFERENCES users(user_id)
);

CREATE TABLE class_schedules (
    schedule_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    course_id BIGINT NOT NULL,
    lecturer_id BIGINT NOT NULL,
    semester NVARCHAR(20),
    academic_year INT,
    class_code NVARCHAR(50),
    status NVARCHAR(20),
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,
    CONSTRAINT uq_class_schedules UNIQUE (class_code, academic_year, semester),
    CONSTRAINT chk_cs_status CHECK (status IN ('OPEN','CLOSED','CANCELLED')),
    CONSTRAINT fk_cs_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_cs_lecturer FOREIGN KEY (lecturer_id) REFERENCES users(user_id)
);

CREATE TABLE notifications (
    notification_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    recipient_id BIGINT NOT NULL,
    triggered_by BIGINT,
    subject NVARCHAR(255),
    body NVARCHAR(MAX),
    channel NVARCHAR(10),
    status NVARCHAR(10),
    sent_at DATETIME2,
    CONSTRAINT chk_notif_channel CHECK (channel IN ('EMAIL','IN_APP','SMS')),
    CONSTRAINT chk_notif_status CHECK (status IN ('PENDING','SENT','FAILED')),
    CONSTRAINT fk_notif_recipient FOREIGN KEY (recipient_id) REFERENCES users(user_id),
    CONSTRAINT fk_notif_trigger FOREIGN KEY (triggered_by) REFERENCES users(user_id)
);

CREATE TABLE audit_logs (
    audit_log_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT,
    action NVARCHAR(255),
    entity_type NVARCHAR(100),
    entity_id BIGINT,
    old_value NVARCHAR(MAX),
    new_value NVARCHAR(MAX),
    ip_address NVARCHAR(45),
    created_at DATETIME2 NOT NULL,
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE INDEX idx_user_roles_user         ON user_roles(user_id);
CREATE INDEX idx_curriculum_courses_cur  ON curriculum_courses(curriculum_id);
CREATE INDEX idx_syllabus_versions_syl   ON syllabus_versions(syllabus_id, status);
CREATE INDEX idx_notifications_recipient ON notifications(recipient_id, status);
CREATE INDEX idx_class_schedules_course  ON class_schedules(course_id, academic_year, semester);
CREATE INDEX idx_audit_logs_entity       ON audit_logs(entity_type, entity_id);



-- Insert Courses
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
('OJT202', 'On-job training', 3, GETDATE()),
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