package com.localreview.dao;

import com.localreview.model.Business;
import com.localreview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of BusinessDAO interface
 */
public class BusinessDAOImpl implements BusinessDAO {

    @Override
    public boolean createBusiness(Business business) throws SQLException {
        String sql = "INSERT INTO businesses (business_name, category_id, location, address, phone, email, description, owner_id, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, business.getBusinessName());
            pstmt.setInt(2, business.getCategoryId());
            pstmt.setString(3, business.getLocation());
            pstmt.setString(4, business.getAddress());
            pstmt.setString(5, business.getPhone());
            pstmt.setString(6, business.getEmail());
            pstmt.setString(7, business.getDescription());
            pstmt.setInt(8, business.getOwnerId());
            pstmt.setString(9, business.getStatus());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error creating business: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public Business getBusinessById(int businessId) throws SQLException {
        String sql = "SELECT b.*, c.category_name, u.full_name as owner_name, " +
                "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                "FROM businesses b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN users u ON b.owner_id = u.user_id " +
                "LEFT JOIN reviews r ON b.business_id = r.business_id AND r.status = 'approved' " +
                "WHERE b.business_id = ? " +
                "GROUP BY b.business_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, businessId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractBusinessFromResultSet(rs);
            }
            return null;
        } catch (SQLException e) {
            System.err.println("Error getting business by ID: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<Business> getAllBusinesses() throws SQLException {
        String sql = "SELECT b.*, c.category_name, u.full_name as owner_name, " +
                "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                "FROM businesses b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN users u ON b.owner_id = u.user_id " +
                "LEFT JOIN reviews r ON b.business_id = r.business_id AND r.status = 'approved' " +
                "GROUP BY b.business_id " +
                "ORDER BY b.created_at DESC";

        return executeBusinessQuery(sql);
    }

    @Override
    public List<Business> getApprovedBusinesses() throws SQLException {
        String sql = "SELECT b.*, c.category_name, u.full_name as owner_name, " +
                "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                "FROM businesses b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN users u ON b.owner_id = u.user_id " +
                "LEFT JOIN reviews r ON b.business_id = r.business_id AND r.status = 'approved' " +
                "WHERE b.status = 'approved' " +
                "GROUP BY b.business_id " +
                "ORDER BY b.created_at DESC";

        return executeBusinessQuery(sql);
    }

    @Override
    public List<Business> getBusinessesByOwner(int ownerId) throws SQLException {
        String sql = "SELECT b.*, c.category_name, u.full_name as owner_name, " +
                "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                "FROM businesses b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN users u ON b.owner_id = u.user_id " +
                "LEFT JOIN reviews r ON b.business_id = r.business_id AND r.status = 'approved' " +
                "WHERE b.owner_id = ? " +
                "GROUP BY b.business_id " +
                "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, ownerId);
            ResultSet rs = pstmt.executeQuery();

            List<Business> businesses = new ArrayList<>();
            while (rs.next()) {
                businesses.add(extractBusinessFromResultSet(rs));
            }
            return businesses;
        } catch (SQLException e) {
            System.err.println("Error getting businesses by owner: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<Business> searchBusinesses(String keyword, String location, Integer categoryId) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT b.*, c.category_name, u.full_name as owner_name, " +
                        "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                        "FROM businesses b " +
                        "LEFT JOIN categories c ON b.category_id = c.category_id " +
                        "LEFT JOIN users u ON b.owner_id = u.user_id " +
                        "LEFT JOIN reviews r ON b.business_id = r.business_id AND r.status = 'approved' " +
                        "WHERE b.status = 'approved'"
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (b.business_name LIKE ? OR b.description LIKE ?)");
            String keywordPattern = "%" + keyword + "%";
            params.add(keywordPattern);
            params.add(keywordPattern);
        }

        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND b.location LIKE ?");
            params.add("%" + location + "%");
        }

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND b.category_id = ?");
            params.add(categoryId);
        }

        sql.append(" GROUP BY b.business_id ORDER BY avg_rating DESC, review_count DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = pstmt.executeQuery();
            List<Business> businesses = new ArrayList<>();

            while (rs.next()) {
                businesses.add(extractBusinessFromResultSet(rs));
            }
            return businesses;
        } catch (SQLException e) {
            System.err.println("Error searching businesses: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<Business> getPendingBusinesses() throws SQLException {
        String sql = "SELECT b.*, c.category_name, u.full_name as owner_name, " +
                "0 as avg_rating, 0 as review_count " +
                "FROM businesses b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN users u ON b.owner_id = u.user_id " +
                "WHERE b.status = 'pending' " +
                "ORDER BY b.created_at DESC";

        return executeBusinessQuery(sql);
    }

    @Override
    public boolean updateBusiness(Business business) throws SQLException {
        String sql = "UPDATE businesses SET business_name = ?, category_id = ?, location = ?, " +
                "address = ?, phone = ?, email = ?, description = ? WHERE business_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, business.getBusinessName());
            pstmt.setInt(2, business.getCategoryId());
            pstmt.setString(3, business.getLocation());
            pstmt.setString(4, business.getAddress());
            pstmt.setString(5, business.getPhone());
            pstmt.setString(6, business.getEmail());
            pstmt.setString(7, business.getDescription());
            pstmt.setInt(8, business.getBusinessId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating business: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean updateBusinessStatus(int businessId, String status) throws SQLException {
        String sql = "UPDATE businesses SET status = ? WHERE business_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, businessId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating business status: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean deleteBusiness(int businessId) throws SQLException {
        String sql = "DELETE FROM businesses WHERE business_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, businessId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting business: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public int getTotalBusinessCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM businesses WHERE status = 'approved'";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.err.println("Error getting business count: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<Business> getTopRatedBusinesses(int limit) throws SQLException {
        String sql = "SELECT b.*, c.category_name, u.full_name as owner_name, " +
                "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                "FROM businesses b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN users u ON b.owner_id = u.user_id " +
                "LEFT JOIN reviews r ON b.business_id = r.business_id AND r.status = 'approved' " +
                "WHERE b.status = 'approved' " +
                "GROUP BY b.business_id " +
                "HAVING review_count > 0 " +
                "ORDER BY avg_rating DESC, review_count DESC " +
                "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            List<Business> businesses = new ArrayList<>();
            while (rs.next()) {
                businesses.add(extractBusinessFromResultSet(rs));
            }
            return businesses;
        } catch (SQLException e) {
            System.err.println("Error getting top rated businesses: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<Business> getFeaturedBusinesses(int limit) throws SQLException {
        String sql = "SELECT b.*, c.category_name, u.full_name as owner_name, " +
                "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                "FROM businesses b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN users u ON b.owner_id = u.user_id " +
                "LEFT JOIN reviews r ON b.business_id = r.business_id AND r.status = 'approved' " +
                "WHERE b.status = 'approved' " +
                "GROUP BY b.business_id " +
                "ORDER BY b.created_at DESC " +
                "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            List<Business> businesses = new ArrayList<>();
            while (rs.next()) {
                businesses.add(extractBusinessFromResultSet(rs));
            }
            return businesses;
        } catch (SQLException e) {
            System.err.println("Error getting featured businesses: " + e.getMessage());
            throw e;
        }
    }

    private List<Business> executeBusinessQuery(String sql) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            List<Business> businesses = new ArrayList<>();
            while (rs.next()) {
                businesses.add(extractBusinessFromResultSet(rs));
            }
            return businesses;
        } catch (SQLException e) {
            System.err.println("Error executing business query: " + e.getMessage());
            throw e;
        }
    }

    private Business extractBusinessFromResultSet(ResultSet rs) throws SQLException {
        Business business = new Business();
        business.setBusinessId(rs.getInt("business_id"));
        business.setBusinessName(rs.getString("business_name"));
        business.setCategoryId(rs.getInt("category_id"));
        business.setCategoryName(rs.getString("category_name"));
        business.setLocation(rs.getString("location"));
        business.setAddress(rs.getString("address"));
        business.setPhone(rs.getString("phone"));
        business.setEmail(rs.getString("email"));
        business.setDescription(rs.getString("description"));
        business.setOwnerId(rs.getInt("owner_id"));
        business.setOwnerName(rs.getString("owner_name"));
        business.setStatus(rs.getString("status"));
        business.setCreatedAt(rs.getTimestamp("created_at"));
        business.setAverageRating(rs.getDouble("avg_rating"));
        business.setReviewCount(rs.getInt("review_count"));
        return business;
    }
}