package test;
import dao.LecturerCurriculumDAO;
import java.util.Map;
public class TestCurriculum {
    public static void main(String[] args) {
        LecturerCurriculumDAO dao = new LecturerCurriculumDAO();
        Map<String, Object> c = dao.getCurriculumDetail(1L);
        System.out.println("Detail: " + c);
    }
}
