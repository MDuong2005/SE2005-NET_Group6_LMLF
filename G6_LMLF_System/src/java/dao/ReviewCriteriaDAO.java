package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReviewCriteriaDAO extends DBContext {

    public List<Map<String, Object>> getActiveCriteria() {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT criteria_id, criteria_code, criteria_name, description, display_order " +
                "FROM review_criteria " +
                "WHERE is_active = 1 " +
                "ORDER BY display_order ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("criteria_id", rs.getLong("criteria_id"));
                row.put("criteria_code", rs.getString("criteria_code"));
                row.put("criteria_name", rs.getString("criteria_name"));
                row.put("description", rs.getString("description"));
                row.put("display_order", rs.getInt("display_order"));

                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
