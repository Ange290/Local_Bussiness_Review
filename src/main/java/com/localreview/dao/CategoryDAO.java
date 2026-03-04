package com.localreview.dao;

import com.localreview.model.Category;
import java.sql.SQLException;
import java.util.List;

/**
 * Data Access Object interface for Category operations
 */
public interface CategoryDAO {
    boolean createCategory(Category category) throws SQLException;
    Category getCategoryById(int categoryId) throws SQLException;
    List<Category> getAllCategories() throws SQLException;
    boolean updateCategory(Category category) throws SQLException;
    boolean deleteCategory(int categoryId) throws SQLException;
    boolean categoryExists(String categoryName) throws SQLException;
}