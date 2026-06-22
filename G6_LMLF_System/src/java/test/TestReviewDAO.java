package test;

import dao.SyllabusVersionDAO;
import dao.SyllabusReviewDAO;

public class TestReviewDAO {

    public static void main(String[] args) {

        SyllabusVersionDAO versionDAO = new SyllabusVersionDAO();
        SyllabusReviewDAO reviewDAO = new SyllabusReviewDAO();

        long reviewerId = 1;

        long approveVersionId = 1;
        long rejectVersionId = 2;

        boolean approveResult =
                versionDAO.approveVersion(approveVersionId, reviewerId);

        System.out.println("Approve result: " + approveResult);

        if (approveResult) {
            boolean insertApproveReview =
                    reviewDAO.insertReview(
                            approveVersionId,
                            reviewerId,
                            "APPROVED",
                            "Looks good"
                    );

            System.out.println("Insert approve review: " + insertApproveReview);
        }

        boolean rejectResult =
                versionDAO.rejectVersion(rejectVersionId, reviewerId);

        System.out.println("Reject result: " + rejectResult);

        if (rejectResult) {
            boolean insertRejectReview =
                    reviewDAO.insertReview(
                            rejectVersionId,
                            reviewerId,
                            "REJECTED",
                            "Need to revise syllabus content"
                    );

            System.out.println("Insert reject review: " + insertRejectReview);
        }
    }
}