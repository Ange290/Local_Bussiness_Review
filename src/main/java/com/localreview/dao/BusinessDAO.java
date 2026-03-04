package com.localreview.dao;

import com.localreview.model.Business;
import java.sql.SQLException;
import java.util.List;

/**
 * Data Access Object interface for Business operations
 */
public interface BusinessDAO {
    boolean createBusiness(Business business) throws SQLException;
    Business getBusinessById(int businessId) throws SQLException;
    List<Business> getAllBusinesses() throws SQLException;
    List<Business> getApprovedBusinesses() throws SQLException;
    List<Business> getBusinessesByOwner(int ownerId) throws SQLException;
    List<Business> searchBusinesses(String keyword, String location, Integer categoryId) throws SQLException;
    List<Business> getPendingBusinesses() throws SQLException;
    boolean updateBusiness(Business business) throws SQLException;
    boolean updateBusinessStatus(int businessId, String status) throws SQLException;
    boolean deleteBusiness(int businessId) throws SQLException;
    int getTotalBusinessCount() throws SQLException;
    List<Business> getTopRatedBusinesses(int limit) throws SQLException;
    List<Business> getFeaturedBusinesses(int limit) throws SQLException;
}