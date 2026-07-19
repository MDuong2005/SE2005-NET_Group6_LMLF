package dao;

import context.DBContext;
import model.Curriculum;
import model.CurriculumCourse;
import model.Course;
import model.Major;
import model.CurriculumPO;
import model.CurriculumPLO;
import model.CurriculumPloPoMapping;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CurriculumDAO extends DBContext {

    private MajorDAO majorDAO = new MajorDAO();
    private CourseDAO courseDAO = new CourseDAO();

    public CurriculumDAO() {
        super();
        // Auto-migrate database: add knowledge_block to curriculum_courses if not present
        try {
            DatabaseMetaData md = connection.getMetaData();
            try (ResultSet rs = md.getColumns(null, null, "curriculum_courses", "knowledge_block")) {
                if (!rs.next()) {
                    try (ResultSet rs2 = md.getColumns(null, null, "CURRICULUM_COURSES", "KNOWLEDGE_BLOCK")) {
                        if (!rs2.next()) {
                            try (Statement stmt = connection.createStatement()) {
                                stmt.execute("ALTER TABLE curriculum_courses ADD knowledge_block NVARCHAR(255) NULL");
                                System.out.println("Auto-migrated curriculum_courses: added knowledge_block column.");
                            }
                        }
                    }
                }
            }
            
            // Auto-migrate: create curriculum_course_plo_mappings table if not exists
            try (ResultSet rs = md.getTables(null, null, "curriculum_course_plo_mappings", null)) {
                if (!rs.next()) {
                    try (ResultSet rs2 = md.getTables(null, null, "CURRICULUM_COURSE_PLO_MAPPINGS", null)) {
                        if (!rs2.next()) {
                            try (Statement stmt = connection.createStatement()) {
                                String sql = "CREATE TABLE curriculum_course_plo_mappings (" +
                                             "  curriculum_id BIGINT NOT NULL," +
                                             "  course_id BIGINT NOT NULL," +
                                             "  plo_id BIGINT NOT NULL," +
                                             "  mapped_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()," +
                                             "  CONSTRAINT pk_curriculum_course_plo_mappings PRIMARY KEY (curriculum_id, course_id, plo_id)," +
                                             "  CONSTRAINT fk_ccpm_curriculum_course FOREIGN KEY (curriculum_id, course_id) REFERENCES curriculum_courses(curriculum_id, course_id) ON DELETE CASCADE," +
                                             "  CONSTRAINT fk_ccpm_plo FOREIGN KEY (plo_id) REFERENCES curriculum_plos(plo_id) ON DELETE CASCADE" +
                                             ")";
                                stmt.execute(sql);
                                System.out.println("Auto-migrated: created curriculum_course_plo_mappings table.");
                            }
                        }
                    }
                }
            }
            
            // Auto-migrate: drop unique constraint uq_curriculum_version if it exists
            try (Statement stmt = connection.createStatement()) {
                String checkSql = "IF EXISTS (SELECT * FROM sys.objects WHERE name = 'uq_curriculum_version' AND parent_object_id = OBJECT_ID('curriculums')) " +
                                  "ALTER TABLE curriculums DROP CONSTRAINT uq_curriculum_version;";
                stmt.execute(checkSql);
            }
        } catch (Exception e) {
            System.err.println("Migration warning (knowledge_block / mapping table / uq constraint): " + e.getMessage());
        }
    }

    // Lấy tất cả curriculums (chưa bị xóa mềm)
    public List<Curriculum> getAll() {
        List<Curriculum> curriculums = new ArrayList<>();
        String sql = "SELECT * FROM curriculums WHERE deleted_at IS NULL ORDER BY created_at DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Curriculum curriculum = mapResultSetToCurriculum(rs);
                curriculum.setMajor(majorDAO.getMajorById(curriculum.getMajorId()));
                curriculum.setCourses(getCurriculumCourses(curriculum.getCurriculumId()));
                curriculums.add(curriculum);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return curriculums;
    }

    // Lấy curriculum theo ID
    public Curriculum getById(Long curriculumId) {
        String sql = "SELECT * FROM curriculums WHERE curriculum_id = ? AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Curriculum curriculum = mapResultSetToCurriculum(rs);
                    curriculum.setMajor(majorDAO.getMajorById(curriculum.getMajorId()));
                    curriculum.setCourses(getCurriculumCourses(curriculumId));
                    curriculum.setPos(getPosByCurriculumId(curriculumId));
                    curriculum.setPlos(getPlosByCurriculumId(curriculumId));
                    curriculum.setMappings(getMappingsByCurriculumId(curriculumId));
                    curriculum.setCoursePloMappings(getCurriculumCoursePloMappings(curriculumId));
                    return curriculum;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Check if curriculum code already exists (including soft-deleted to avoid DB unique constraint error)
    public boolean checkCodeExists(String curriculumCode) {
        String sql = "SELECT COUNT(*) FROM curriculums WHERE curriculum_code = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, curriculumCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    // Lấy curriculums theo major
    public List<Curriculum> getByMajorId(Long majorId) {
        List<Curriculum> curriculums = new ArrayList<>();
        String sql = "SELECT * FROM curriculums WHERE major_id = ? AND deleted_at IS NULL ORDER BY created_at DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, majorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Curriculum curriculum = mapResultSetToCurriculum(rs);
                    curriculum.setMajor(majorDAO.getMajorById(majorId));
                    curriculum.setCourses(getCurriculumCourses(curriculum.getCurriculumId()));
                    curriculums.add(curriculum);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return curriculums;
    }

    // Tạo mới curriculum
    public boolean create(Curriculum curriculum) {
        String sql = "INSERT INTO curriculums (major_id, curriculum_code, name, is_active, description, decision_no, issued_date, total_credits, version, total_semesters, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, curriculum.getMajorId());
            ps.setString(2, curriculum.getCurriculumCode());
            ps.setString(3, curriculum.getName());
            ps.setBoolean(4, curriculum.getIsActive());
            ps.setString(5, curriculum.getDescription());
            ps.setString(6, curriculum.getDecisionNo());
            ps.setDate(7, curriculum.getIssuedDate());
            if (curriculum.getTotalCredits() == null) {
                ps.setNull(8, Types.INTEGER);
            } else {
                ps.setInt(8, curriculum.getTotalCredits());
            }
            ps.setString(9, curriculum.getVersion());
            ps.setInt(10, curriculum.getTotalSemesters());
            ps.setTimestamp(11, new Timestamp(System.currentTimeMillis()));
            ps.setTimestamp(12, new Timestamp(System.currentTimeMillis()));
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        curriculum.setCurriculumId(rs.getLong(1));
                    }
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật curriculum
    public boolean update(Curriculum curriculum) {
        String sql = "UPDATE curriculums SET curriculum_code = ?, name = ?, is_active = ?, description = ?, decision_no = ?, issued_date = ?, total_credits = ?, version = ?, total_semesters = ?, updated_at = ?, updated_by = ? " +
                     "WHERE curriculum_id = ? AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, curriculum.getCurriculumCode());
            ps.setString(2, curriculum.getName());
            ps.setBoolean(3, curriculum.getIsActive());
            ps.setString(4, curriculum.getDescription());
            ps.setString(5, curriculum.getDecisionNo());
            ps.setDate(6, curriculum.getIssuedDate());
            if (curriculum.getTotalCredits() == null) {
                ps.setNull(7, Types.INTEGER);
            } else {
                ps.setInt(7, curriculum.getTotalCredits());
            }
            ps.setString(8, curriculum.getVersion());
            ps.setInt(9, curriculum.getTotalSemesters());
            ps.setTimestamp(10, new Timestamp(System.currentTimeMillis()));
            ps.setLong(11, curriculum.getUpdatedBy() != null ? curriculum.getUpdatedBy() : 1L);
            ps.setLong(12, curriculum.getCurriculumId());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa mềm curriculum
    public boolean softDelete(Long curriculumId) {
        String sql = "UPDATE curriculums SET deleted_at = ?, is_active = ? WHERE curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setBoolean(2, false);
            ps.setLong(3, curriculumId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Khôi phục curriculum
    public boolean restore(Long curriculumId) {
        String sql = "UPDATE curriculums SET deleted_at = NULL WHERE curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy courses của curriculum
    public List<CurriculumCourse> getCurriculumCourses(Long curriculumId) {
        List<CurriculumCourse> curriculumCourses = new ArrayList<>();
        String sql = "SELECT cc.*, c.code, c.name, c.credits FROM curriculum_courses cc " +
                     "JOIN courses c ON cc.course_id = c.course_id " +
                     "WHERE cc.curriculum_id = ? " +
                     "ORDER BY cc.semester, c.code";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CurriculumCourse cc = new CurriculumCourse();
                    cc.setId(rs.getLong("id"));
                    cc.setCurriculumId(rs.getLong("curriculum_id"));
                    cc.setCourseId(rs.getLong("course_id"));
                    cc.setSemester(rs.getInt("semester"));
                    cc.setKnowledgeBlock(rs.getString("knowledge_block"));
                    
                    Course course = new Course();
                    course.setCourseId(rs.getLong("course_id"));
                    course.setCode(rs.getString("code"));
                    course.setName(rs.getString("name"));
                    course.setCredits(rs.getInt("credits"));
                    cc.setCourse(course);
                    
                    curriculumCourses.add(cc);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return curriculumCourses;
    }

    // Thêm course vào curriculum
    public boolean addCourseToCurriculum(Long curriculumId, Long courseId, Integer semester) {
        // Kiểm tra course đã tồn tại trong curriculum chưa
        String checkSql = "SELECT COUNT(*) FROM curriculum_courses WHERE curriculum_id = ? AND course_id = ?";
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setLong(1, curriculumId);
            checkPs.setLong(2, courseId);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; // Course đã tồn tại
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        String sql = "INSERT INTO curriculum_courses (curriculum_id, course_id, semester) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            ps.setLong(2, courseId);
            ps.setInt(3, semester);
            
            int affected = ps.executeUpdate();
            
            // Cập nhật updated_at của curriculum
            if (affected > 0) {
                updateCurriculumTimestamp(curriculumId);
            }
            
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa course khỏi curriculum
    public boolean removeCourseFromCurriculum(Long curriculumId, Long courseId) {
        String sql = "DELETE FROM curriculum_courses WHERE curriculum_id = ? AND course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            ps.setLong(2, courseId);
            
            int affected = ps.executeUpdate();
            
            // Cập nhật updated_at của curriculum
            if (affected > 0) {
                updateCurriculumTimestamp(curriculumId);
            }
            
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật semester của course trong curriculum
    public boolean updateCourseSemester(Long curriculumId, Long courseId, Integer semester) {
        String sql = "UPDATE curriculum_courses SET semester = ? WHERE curriculum_id = ? AND course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, semester);
            ps.setLong(2, curriculumId);
            ps.setLong(3, courseId);
            
            int affected = ps.executeUpdate();
            
            // Cập nhật updated_at của curriculum
            if (affected > 0) {
                updateCurriculumTimestamp(curriculumId);
            }
            
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật timestamp của curriculum
    private void updateCurriculumTimestamp(Long curriculumId) {
        String sql = "UPDATE curriculums SET updated_at = ? WHERE curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setLong(2, curriculumId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách courses chưa có trong curriculum
    public List<Course> getAvailableCoursesForCurriculum(Long curriculumId) {
        List<Course> availableCourses = new ArrayList<>();
        String sql = "SELECT c.* FROM courses c " +
                     "WHERE c.deleted_at IS NULL " +
                     "AND c.course_id NOT IN (SELECT course_id FROM curriculum_courses WHERE curriculum_id = ?) " +
                     "ORDER BY c.code";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getLong("course_id"));
                    course.setCode(rs.getString("code"));
                    course.setName(rs.getString("name"));
                    course.setCredits(rs.getInt("credits"));
                    availableCourses.add(course);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availableCourses;
    }

    // Kiểm tra curriculum có tồn tại không
    public boolean exists(Long curriculumId) {
        String sql = "SELECT COUNT(*) FROM curriculums WHERE curriculum_id = ? AND deleted_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đếm số curriculum
    public int getCount() {
        String sql = "SELECT COUNT(*) FROM curriculums WHERE deleted_at IS NULL";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy POs
    public List<CurriculumPO> getPosByCurriculumId(Long curriculumId) {
        List<CurriculumPO> pos = new ArrayList<>();
        String sql = "SELECT * FROM curriculum_pos WHERE curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CurriculumPO po = new CurriculumPO();
                    po.setPoId(rs.getLong("po_id"));
                    po.setCurriculumId(rs.getLong("curriculum_id"));
                    po.setCode(rs.getString("code"));
                    po.setDescription(rs.getString("description"));
                    po.setCreatedAt(rs.getTimestamp("created_at"));
                    pos.add(po);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        pos.sort((a, b) -> {
            try {
                int numA = Integer.parseInt(a.getCode().replaceAll("\\D+", ""));
                int numB = Integer.parseInt(b.getCode().replaceAll("\\D+", ""));
                return Integer.compare(numA, numB);
            } catch (Exception e) {
                return a.getCode().compareTo(b.getCode());
            }
        });
        return pos;
    }

    // Lấy PLOs
    public List<CurriculumPLO> getPlosByCurriculumId(Long curriculumId) {
        List<CurriculumPLO> plos = new ArrayList<>();
        String sql = "SELECT * FROM curriculum_plos WHERE curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CurriculumPLO plo = new CurriculumPLO();
                    plo.setPloId(rs.getLong("plo_id"));
                    plo.setCurriculumId(rs.getLong("curriculum_id"));
                    plo.setCode(rs.getString("code"));
                    plo.setDescription(rs.getString("description"));
                    plo.setCreatedAt(rs.getTimestamp("created_at"));
                    plos.add(plo);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        plos.sort((a, b) -> {
            try {
                int numA = Integer.parseInt(a.getCode().replaceAll("\\D+", ""));
                int numB = Integer.parseInt(b.getCode().replaceAll("\\D+", ""));
                return Integer.compare(numA, numB);
            } catch (Exception e) {
                return a.getCode().compareTo(b.getCode());
            }
        });
        return plos;
    }

    // Lấy Mappings
    public List<CurriculumPloPoMapping> getMappingsByCurriculumId(Long curriculumId) {
        List<CurriculumPloPoMapping> mappings = new ArrayList<>();
        String sql = "SELECT m.* FROM curriculum_plo_po_mappings m " +
                     "JOIN curriculum_plos plo ON m.plo_id = plo.plo_id " +
                     "WHERE plo.curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CurriculumPloPoMapping mapping = new CurriculumPloPoMapping();
                    mapping.setPloId(rs.getLong("plo_id"));
                    mapping.setPoId(rs.getLong("po_id"));
                    mapping.setMappedAt(rs.getTimestamp("mapped_at"));
                    mappings.add(mapping);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mappings;
    }

    // Thêm PO
    public boolean addPO(CurriculumPO po) {
        String sql = "INSERT INTO curriculum_pos (curriculum_id, code, description, created_at) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, po.getCurriculumId());
            ps.setString(2, po.getCode());
            ps.setString(3, po.getDescription());
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        po.setPoId(rs.getLong(1));
                    }
                }
                updateCurriculumTimestamp(po.getCurriculumId());
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa PO
    public boolean deletePO(Long curriculumId, String code) {
        String sqlMap = "DELETE FROM curriculum_plo_po_mappings WHERE po_id = (SELECT po_id FROM curriculum_pos WHERE curriculum_id = ? AND code = ?)";
        String sqlPo = "DELETE FROM curriculum_pos WHERE curriculum_id = ? AND code = ?";
        try {
            boolean originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try (PreparedStatement psMap = connection.prepareStatement(sqlMap);
                 PreparedStatement psPo = connection.prepareStatement(sqlPo)) {
                
                psMap.setLong(1, curriculumId);
                psMap.setString(2, code);
                psMap.executeUpdate();
                
                psPo.setLong(1, curriculumId);
                psPo.setString(2, code);
                int affected = psPo.executeUpdate();
                
                connection.commit();
                if (affected > 0) {
                    updateCurriculumTimestamp(curriculumId);
                    return true;
                }
            } catch (Exception e) {
                connection.rollback();
                e.printStackTrace();
            } finally {
                connection.setAutoCommit(originalAutoCommit);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm PLO
    public boolean addPLO(CurriculumPLO plo) {
        String sql = "INSERT INTO curriculum_plos (curriculum_id, code, description, created_at) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, plo.getCurriculumId());
            ps.setString(2, plo.getCode());
            ps.setString(3, plo.getDescription());
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        plo.setPloId(rs.getLong(1));
                    }
                }
                updateCurriculumTimestamp(plo.getCurriculumId());
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa PLO
    public boolean deletePLO(Long curriculumId, String code) {
        String sqlMap = "DELETE FROM curriculum_plo_po_mappings WHERE plo_id = (SELECT plo_id FROM curriculum_plos WHERE curriculum_id = ? AND code = ?)";
        String sqlPlo = "DELETE FROM curriculum_plos WHERE curriculum_id = ? AND code = ?";
        try {
            boolean originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try (PreparedStatement psMap = connection.prepareStatement(sqlMap);
                 PreparedStatement psPlo = connection.prepareStatement(sqlPlo)) {
                
                psMap.setLong(1, curriculumId);
                psMap.setString(2, code);
                psMap.executeUpdate();
                
                psPlo.setLong(1, curriculumId);
                psPlo.setString(2, code);
                int affected = psPlo.executeUpdate();
                
                connection.commit();
                if (affected > 0) {
                    updateCurriculumTimestamp(curriculumId);
                    return true;
                }
            } catch (Exception e) {
                connection.rollback();
                e.printStackTrace();
            } finally {
                connection.setAutoCommit(originalAutoCommit);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Toggle Matrix Mapping
    public boolean toggleMapping(Long curriculumId, String ploCode, String poCode) {
        String queryIds = "SELECT plo.plo_id, po.po_id FROM " +
                          "(SELECT plo_id FROM curriculum_plos WHERE curriculum_id = ? AND code = ?) plo, " +
                          "(SELECT po_id FROM curriculum_pos WHERE curriculum_id = ? AND code = ?) po";
        
        try (PreparedStatement psIds = connection.prepareStatement(queryIds)) {
            psIds.setLong(1, curriculumId);
            psIds.setString(2, ploCode);
            psIds.setLong(3, curriculumId);
            psIds.setString(4, poCode);
            
            Long ploId = null;
            Long poId = null;
            try (ResultSet rs = psIds.executeQuery()) {
                if (rs.next()) {
                    ploId = rs.getLong("plo_id");
                    poId = rs.getLong("po_id");
                }
            }
            
            if (ploId == null || poId == null) {
                return false;
            }
            
            // Check if mapping exists
            String checkSql = "SELECT COUNT(*) FROM curriculum_plo_po_mappings WHERE plo_id = ? AND po_id = ?";
            boolean exists = false;
            try (PreparedStatement psCheck = connection.prepareStatement(checkSql)) {
                psCheck.setLong(1, ploId);
                psCheck.setLong(2, poId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        exists = true;
                    }
                }
            }
            
            boolean originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try {
                if (exists) {
                    // Delete mapping
                    String deleteSql = "DELETE FROM curriculum_plo_po_mappings WHERE plo_id = ? AND po_id = ?";
                    try (PreparedStatement psDel = connection.prepareStatement(deleteSql)) {
                        psDel.setLong(1, ploId);
                        psDel.setLong(2, poId);
                        psDel.executeUpdate();
                    }
                } else {
                    // Insert mapping
                    String insertSql = "INSERT INTO curriculum_plo_po_mappings (plo_id, po_id, mapped_at) VALUES (?, ?, ?)";
                    try (PreparedStatement psIns = connection.prepareStatement(insertSql)) {
                        psIns.setLong(1, ploId);
                        psIns.setLong(2, poId);
                        psIns.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                        psIns.executeUpdate();
                    }
                }
                connection.commit();
                updateCurriculumTimestamp(curriculumId);
                return true;
            } catch (Exception e) {
                connection.rollback();
                e.printStackTrace();
            } finally {
                connection.setAutoCommit(originalAutoCommit);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tạo mới curriculum qua Wizard (Transaction-safe)
    public boolean createWizardCurriculum(Curriculum curriculum, 
                                          List<CurriculumPO> pos, 
                                          List<CurriculumPLO> plos, 
                                          List<CurriculumCourse> courses, 
                                          List<String[]> mappingCodes,
                                          List<String[]> coursePloMappings) throws Exception {
        Connection conn = connection;
        boolean originalAutoCommit = true;
        try {
            originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            
            // 1. Insert Curriculum
            String insertCurrSql = "INSERT INTO curriculums (major_id, curriculum_code, name, is_active, description, decision_no, issued_date, total_credits, version, total_semesters, created_at, updated_at) " +
                                   "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            Long curriculumId = null;
            try (PreparedStatement ps = conn.prepareStatement(insertCurrSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setLong(1, curriculum.getMajorId());
                ps.setString(2, curriculum.getCurriculumCode());
                ps.setString(3, curriculum.getName());
                ps.setBoolean(4, curriculum.getIsActive());
                ps.setString(5, curriculum.getDescription());
                ps.setString(6, curriculum.getDecisionNo());
                ps.setDate(7, curriculum.getIssuedDate());
                if (curriculum.getTotalCredits() == null) {
                    ps.setNull(8, Types.INTEGER);
                } else {
                    ps.setInt(8, curriculum.getTotalCredits());
                }
                ps.setString(9, curriculum.getVersion());
                ps.setInt(10, curriculum.getTotalSemesters());
                ps.setTimestamp(11, new Timestamp(System.currentTimeMillis()));
                ps.setTimestamp(12, new Timestamp(System.currentTimeMillis()));
                
                int affected = ps.executeUpdate();
                if (affected == 0) {
                    throw new SQLException("Creating curriculum failed, no rows affected.");
                }
                
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        curriculumId = rs.getLong(1);
                        curriculum.setCurriculumId(curriculumId);
                    } else {
                        throw new SQLException("Creating curriculum failed, no ID obtained.");
                    }
                }
            }
            
            // 2. Insert POs
            String insertPoSql = "INSERT INTO curriculum_pos (curriculum_id, code, description, created_at) VALUES (?, ?, ?, ?)";
            java.util.Map<String, Long> poCodeToId = new java.util.HashMap<>();
            try (PreparedStatement ps = conn.prepareStatement(insertPoSql, Statement.RETURN_GENERATED_KEYS)) {
                for (CurriculumPO po : pos) {
                    ps.setLong(1, curriculumId);
                    ps.setString(2, po.getCode());
                    ps.setString(3, po.getDescription());
                    ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                    ps.executeUpdate();
                    
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            Long poId = rs.getLong(1);
                            poCodeToId.put(po.getCode(), poId);
                        } else {
                            throw new SQLException("Inserting PO failed, no ID obtained.");
                        }
                    }
                }
            }
            
            // 3. Insert PLOs
            String insertPloSql = "INSERT INTO curriculum_plos (curriculum_id, code, description, created_at) VALUES (?, ?, ?, ?)";
            java.util.Map<String, Long> ploCodeToId = new java.util.HashMap<>();
            try (PreparedStatement ps = conn.prepareStatement(insertPloSql, Statement.RETURN_GENERATED_KEYS)) {
                for (CurriculumPLO plo : plos) {
                    ps.setLong(1, curriculumId);
                    ps.setString(2, plo.getCode());
                    ps.setString(3, plo.getDescription());
                    ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                    ps.executeUpdate();
                    
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            Long ploId = rs.getLong(1);
                            ploCodeToId.put(plo.getCode(), ploId);
                        } else {
                            throw new SQLException("Inserting PLO failed, no ID obtained.");
                        }
                    }
                }
            }
            
            // 4. Insert Courses
            String insertCourseSql = "INSERT INTO curriculum_courses (curriculum_id, course_id, semester, knowledge_block) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertCourseSql)) {
                for (CurriculumCourse cc : courses) {
                    ps.setLong(1, curriculumId);
                    ps.setLong(2, cc.getCourseId());
                    ps.setInt(3, cc.getSemester());
                    ps.setString(4, cc.getKnowledgeBlock());
                    ps.addBatch();
                }
                if (!courses.isEmpty()) {
                    ps.executeBatch();
                }
            }
            
            // 5. Insert PO-PLO Mappings
            String insertMapSql = "INSERT INTO curriculum_plo_po_mappings (plo_id, po_id, mapped_at) VALUES (?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertMapSql)) {
                for (String[] mapping : mappingCodes) {
                    Long ploId = ploCodeToId.get(mapping[0].trim());
                    Long poId = poCodeToId.get(mapping[1].trim());
                    if (ploId != null && poId != null) {
                        ps.setLong(1, ploId);
                        ps.setLong(2, poId);
                        ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                        ps.addBatch();
                    }
                }
                if (!mappingCodes.isEmpty()) {
                    ps.executeBatch();
                }
            }

            // 6. Insert Course-PLO Mappings
            System.out.println("[DEBUG] Inserting Course-PLO mappings. Size: " + coursePloMappings.size());
            String insertCoursePloSql = "INSERT INTO curriculum_course_plo_mappings (curriculum_id, course_id, plo_id, mapped_at) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertCoursePloSql)) {
                for (String[] mapping : coursePloMappings) {
                    Course course = courseDAO.getByCode(mapping[0].trim());
                    Long ploId = ploCodeToId.get(mapping[1].trim());
                    System.out.println("[DEBUG] CourseCode: " + mapping[0].trim() + " -> Course: " + (course == null ? "null" : course.getCourseId()) +
                                       " | PLO: " + mapping[1].trim() + " -> ploId: " + ploId);
                    if (course != null && ploId != null) {
                        ps.setLong(1, curriculumId);
                        ps.setLong(2, course.getCourseId());
                        ps.setLong(3, ploId);
                        ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                        ps.addBatch();
                    }
                }
                if (!coursePloMappings.isEmpty()) {
                    int[] results = ps.executeBatch();
                    System.out.println("[DEBUG] Batch execute results size: " + results.length);
                }
            }
            
            conn.commit();
            return true;
        } catch (Exception e) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            throw e;
        } finally {
            try {
                conn.setAutoCommit(originalAutoCommit);
            } catch (SQLException autoCommitEx) {
                autoCommitEx.printStackTrace();
            }
        }
    }

    public boolean updateActiveStatus(Long curriculumId, boolean isActive) {
        String sql = "UPDATE curriculums SET is_active = ?, updated_at = ? WHERE curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setLong(3, curriculumId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Curriculum mapResultSetToCurriculum(ResultSet rs) throws SQLException {
        Curriculum curriculum = new Curriculum();
        curriculum.setCurriculumId(rs.getLong("curriculum_id"));
        curriculum.setMajorId(rs.getLong("major_id"));
        curriculum.setCurriculumCode(rs.getString("curriculum_code"));
        curriculum.setName(rs.getString("name"));
        curriculum.setIsActive(rs.getBoolean("is_active"));
        curriculum.setDescription(rs.getString("description"));
        curriculum.setDecisionNo(rs.getString("decision_no"));
        curriculum.setIssuedDate(rs.getDate("issued_date"));
        curriculum.setTotalCredits(rs.getObject("total_credits") != null ? rs.getInt("total_credits") : null);
        curriculum.setVersion(rs.getString("version"));
        curriculum.setTotalSemesters(rs.getInt("total_semesters"));
        curriculum.setCreatedAt(rs.getTimestamp("created_at"));
        curriculum.setUpdatedAt(rs.getTimestamp("updated_at"));
        curriculum.setUpdatedBy(rs.getObject("updated_by") != null ? rs.getLong("updated_by") : null);
        curriculum.setDeletedAt(rs.getTimestamp("deleted_at"));
        return curriculum;
    }

    public List<String[]> getCurriculumCoursePloMappings(Long curriculumId) {
        List<String[]> mappings = new ArrayList<>();
        String sql = "SELECT c.code AS course_code, p.code AS plo_code FROM curriculum_course_plo_mappings ccpm " +
                     "JOIN courses c ON ccpm.course_id = c.course_id " +
                     "JOIN curriculum_plos p ON ccpm.plo_id = p.plo_id " +
                     "WHERE ccpm.curriculum_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    mappings.add(new String[]{ rs.getString("course_code"), rs.getString("plo_code") });
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mappings;
    }

    public boolean toggleCoursePloMapping(Long curriculumId, String courseCode, String ploCode) {
        // Find course_id and plo_id
        String findCourseSql = "SELECT course_id FROM courses WHERE code = ?";
        String findPloSql = "SELECT plo_id FROM curriculum_plos WHERE curriculum_id = ? AND code = ?";
        Long courseId = null;
        Long ploId = null;
        
        try (PreparedStatement ps = connection.prepareStatement(findCourseSql)) {
            ps.setString(1, courseCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) courseId = rs.getLong("course_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        try (PreparedStatement ps = connection.prepareStatement(findPloSql)) {
            ps.setLong(1, curriculumId);
            ps.setString(2, ploCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) ploId = rs.getLong("plo_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (courseId == null || ploId == null) return false;
        
        // Check if exists
        String checkSql = "SELECT COUNT(*) FROM curriculum_course_plo_mappings WHERE curriculum_id = ? AND course_id = ? AND plo_id = ?";
        boolean exists = false;
        try (PreparedStatement ps = connection.prepareStatement(checkSql)) {
            ps.setLong(1, curriculumId);
            ps.setLong(2, courseId);
            ps.setLong(3, ploId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) exists = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        try {
            boolean originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try {
                if (exists) {
                    // Delete
                    String delSql = "DELETE FROM curriculum_course_plo_mappings WHERE curriculum_id = ? AND course_id = ? AND plo_id = ?";
                    try (PreparedStatement ps = connection.prepareStatement(delSql)) {
                        ps.setLong(1, curriculumId);
                        ps.setLong(2, courseId);
                        ps.setLong(3, ploId);
                        ps.executeUpdate();
                    }
                } else {
                    // Insert
                    String insSql = "INSERT INTO curriculum_course_plo_mappings (curriculum_id, course_id, plo_id) VALUES (?, ?, ?)";
                    try (PreparedStatement ps = connection.prepareStatement(insSql)) {
                        ps.setLong(1, curriculumId);
                        ps.setLong(2, courseId);
                        ps.setLong(3, ploId);
                        ps.executeUpdate();
                    }
                }
                connection.commit();
                updateCurriculumTimestamp(curriculumId);
                return true;
            } catch (Exception e) {
                connection.rollback();
                e.printStackTrace();
            } finally {
                connection.setAutoCommit(originalAutoCommit);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}