package test;

import dao.SyllabusVersionDAO;

public class TestPublishDAO {

    public static void main(String[] args) {

        SyllabusVersionDAO versionDAO = new SyllabusVersionDAO();

        long publisherId = 1;

        long publishVersionId1 = 3;
        long publishVersionId2 = 4;

        boolean publishFirst =
                versionDAO.publishVersion(publishVersionId1, publisherId);

        System.out.println("Publish first version: " + publishFirst);

        boolean publishSecond =
                versionDAO.publishVersion(publishVersionId2, publisherId);

        System.out.println("Publish second version: " + publishSecond);
    }
}