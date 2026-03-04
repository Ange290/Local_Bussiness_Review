package com.localreview.dao;

import com.localreview.model.Category;
import com.localreview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of CategoryDAO interface
 */
public class CategoryDAOImpl implements CategoryDAO {

    @Override
    public boolean createCategory(Category category) throws SQLException {
        String sql = "INSERT INTO categories (category_name, description) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, category.getCategoryName());
            pstmt.setString(2, category.getDescription());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error creating category: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public Category getCategoryById(int categoryId) throws SQLException {
        String sql = "SELECT c.*, COUNT(b.business_id) as business_count " +
                "FROM categories c " +
                "LEFT JOIN businesses b ON c.category_id = b.category_id " +
                "WHERE c.category_id = ? " +
                "GROUP BY c.category_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractCategoryFromResultSet(rs);
            }
            return null;
        } catch (SQLException e) {
            System.err.println("Error getting category by ID: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<Category> getAllCategories() throws SQLException {
        String sql = "SELECT c.*, COUNT(b.business_id) as business_count " +
                "FROM categories c " +
                "LEFT JOIN businesses b ON c.category_id = b.category_id " +
                "GROUP BY c.category_id " +
                "ORDER BY c.category_name";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            List<Category> categories = new ArrayList<>();
            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
            return categories;
        } catch (SQLException e) {
            System.err.println("Error getting all categories: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean updateCategory(Category category) throws SQLException {
        String sql = "UPDATE categories SET category_name = ?, description = ? WHERE category_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, category.getCategoryName());
            pstmt.setString(2, category.getDescription());
            pstmt.setInt(3, category.getCategoryId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating category: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean deleteCategory(int categoryId) throws SQLException {
        String sql = "DELETE FROM categories WHERE category_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, categoryId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting category: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean categoryExists(String categoryName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM categories WHERE category_name = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, categoryName);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Error checking category existence: " + e.getMessage());
            throw e;
        }
    }

    private Category extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setBusinessCount(rs.getInt("business_count"));
        return category;
    }
}
