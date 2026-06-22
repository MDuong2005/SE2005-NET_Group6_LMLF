package test;

import dao.SyllabusVersionDAO;

public class TestCreateVersionDAO {

    public static void main(String[] args) {

        SyllabusVersionDAO dao = new SyllabusVersionDAO();

        boolean result = dao.createVersion(
                1,
                "3.0",
                "MAJOR",
                "Create new version for testing",
                1
        );

        System.out.println("Create version result: " + result);
    }
}