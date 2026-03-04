# Local Business Review Website

A comprehensive Java EE MVC web application for discovering, reviewing, and managing local businesses. Built with JSP, Servlets, JDBC, MySQL, and Bootstrap 5.

![Java](https://img.shields.io/badge/Java-17-orange)
![Tomcat](https://img.shields.io/badge/Tomcat-11-yellow)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Database Configuration](#database-configuration)
- [Running the Application](#running-the-application)
- [User Roles & Permissions](#user-roles--permissions)
- [Screenshots](#screenshots)
- [Testing Credentials](#testing-credentials)
- [API Endpoints](#api-endpoints)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

### Core Functionality
- ✅ **User Authentication & Authorization**
    - Secure login/logout with session management
    - Role-based access control (Admin, Business Owner, Regular User)
    - Password encryption using SHA-256
    - Session timeout handling

- ✅ **Business Management (CRUD)**
    - Add, view, update, and delete businesses
    - Business approval workflow (pending → approved by admin)
    - Category-based organization
    - Search and filter functionality
    - Average rating calculation

- ✅ **Review System (CRUD)**
    - Add, edit, and delete reviews
    - 5-star rating system
    - Prevent duplicate reviews (one per user per business)
    - Review moderation (optional admin approval)
    - Display average ratings and review counts

- ✅ **Category Management**
    - Admin can create, update, and delete categories
    - Category-based business filtering
    - Business count per category

- ✅ **Admin Dashboard**
    - Comprehensive statistics overview
    - Manage users (activate/deactivate, change roles)
    - Manage businesses (approve/reject/delete)
    - Manage reviews and categories
    - Pending approvals queue

- ✅ **Search & Discovery**
    - Search by business name, location, and category
    - Featured and top-rated businesses
    - Recent reviews display

### Technical Features
- ✅ Server-side validations (email, password, phone, etc.)
- ✅ SQL injection prevention (prepared statements)
- ✅ Exception handling and error pages (404, 500)
- ✅ Responsive design (mobile, tablet, desktop)
- ✅ Clean MVC architecture
- ✅ Reusable components (navbar, footer)

## 🛠 Technologies Used

### Backend
- **Java 17** - Core programming language
- **Jakarta Servlet 6.0** - Server-side request handling
- **JSP (JavaServer Pages)** - Dynamic page generation
- **JDBC** - Database connectivity
- **Apache Tomcat 11** - Application server

### Frontend
- **HTML5 & CSS3** - Structure and styling
- **Bootstrap 5.3** - Responsive UI framework
- **JavaScript (ES6+)** - Client-side functionality
- **Font Awesome 6.4** - Icons
- **Google Fonts (Outfit)** - Typography

### Database
- **MySQL 8.0+** - Relational database

### Build Tools
- **Apache Maven** - Dependency management and build automation

## 📁 Project Structure

```
local-business-review/
├── src/main/java/com/localreview/
│   ├── model/              # JavaBeans (User, Business, Review, Category)
│   ├── dao/                # Data Access Objects (interfaces & implementations)
│   ├── controller/         # Servlets (LoginServlet, BusinessServlet, etc.)
│   ├── util/               # Utility classes (DBConnection, ValidationUtil, PasswordUtil)
│   └── filter/             # Filters (AuthenticationFilter, AuthorizationFilter)
├── src/main/webapp/
│   ├── WEB-INF/
│   │   └── web.xml         # Deployment descriptor
│   ├── css/
│   │   └── style.css       # Custom styles
│   ├── js/
│   │   └── script.js       # JavaScript functionality
│   ├── images/             # Image assets
│   ├── components/         # Reusable JSP components (navbar, footer)
│   ├── admin/              # Admin dashboard pages
│   ├── owner/              # Business owner pages
│   ├── user/               # Regular user pages
│   ├── index.jsp           # Landing page
│   ├── login.jsp           # Login page
│   ├── register.jsp        # Registration page
│   ├── businesses.jsp      # Business listing
│   ├── business-detail.jsp # Business details
│   ├── search.jsp          # Search page
│   └── error pages         # 404, 500, access-denied
├── database/
│   └── schema.sql          # Database schema with sample data
├── pom.xml                 # Maven configuration
└── README.md               # This file
```

## 📦 Prerequisites

Before running this application, ensure you have:

- **Java Development Kit (JDK) 17 or higher**
    - Download from: https://www.oracle.com/java/technologies/downloads/

- **Apache Tomcat 11**
    - Download from: https://tomcat.apache.org/download-11.cgi

- **MySQL Server 8.0 or higher**
    - Download from: https://dev.mysql.com/downloads/mysql/

- **IntelliJ IDEA** (or any Java IDE)
    - Download from: https://www.jetbrains.com/idea/download/

- **Apache Maven** (optional if using IDE's built-in Maven)
    - Download from: https://maven.apache.org/download.cgi

## 🚀 Installation & Setup

### 1. Clone or Download the Project

```bash
git clone <repository-url>
cd local-business-review
```

### 2. Set Up MySQL Database

#### Start MySQL Server
```bash
# Windows
net start MySQL80

# macOS/Linux
sudo systemctl start mysql
```

#### Create Database and Import Schema
```bash
# Login to MySQL
mysql -u root -p

# Create database
CREATE DATABASE local_business_review;
USE local_business_review;

# Import schema
source /path/to/schema.sql;

# Or from command line
mysql -u root -p local_business_review < database/schema.sql
```

### 3. Configure Database Connection

Edit the database connection settings in:
`src/main/java/com/localreview/util/DBConnection.java`

```java
private static final String URL = "jdbc:mysql://localhost:3306/local_business_review";
private static final String USERNAME = "root";
private static final String PASSWORD = "your_password_here"; // Change this!
```

### 4. Build the Project with Maven

```bash
# Clean and build
mvn clean package

# This will create a WAR file in target/ directory
```

### 5. Configure IntelliJ IDEA

#### Add Tomcat Configuration
1. Go to **Run → Edit Configurations**
2. Click **+** → **Tomcat Server → Local**
3. Click **Configure** next to Application Server
4. Browse to your Tomcat 11 installation directory
5. Click **OK**
6. In **Deployment** tab, click **+** → **Artifact**
7. Select **local-business-review:war exploded**
8. Set Application context to `/` or `/local-business-review`
9. Click **Apply** and **OK**

#### Add MySQL JDBC Driver
1. Download MySQL Connector/J from: https://dev.mysql.com/downloads/connector/j/
2. Add JAR to project libraries or ensure it's in `WEB-INF/lib/`
3. Or use Maven dependency (already in pom.xml)

## 💾 Database Configuration

### Database Schema Overview

The application uses 4 main tables:

1. **users** - User accounts and authentication
2. **businesses** - Business listings
3. **reviews** - User reviews for businesses
4. **categories** - Business categories

### Sample Data Included

The schema includes sample data with test accounts:

| Username | Password | Role | Purpose |
|----------|----------|------|---------|
| admin | Admin123 | Admin | Full system access |
| john_doe | 12345678 | Business Owner | Manage businesses |
| jane_smith | 12345678 | Regular User | Write reviews |
| bob_wilson | 12345678 | Business Owner | Manage businesses |
| alice_brown | 12345678 | Regular User | Write reviews |

**Note:** Passwords are SHA-256 hashed in the database.

### Database Relationships

```
users (1) ──── (N) businesses
users (1) ──── (N) reviews
businesses (N) ──── (1) categories
businesses (1) ──── (N) reviews
```

## ▶️ Running the Application

### Method 1: Using IntelliJ IDEA

1. Open the project in IntelliJ IDEA
2. Configure Tomcat (see Installation step 5)
3. Click the **Run** button (green triangle) or press **Shift + F10**
4. Wait for Tomcat to start
5. Browser will automatically open to: `http://localhost:8080/`

### Method 2: Using Maven

```bash
# Build the WAR file
mvn clean package

# Copy WAR to Tomcat webapps directory
cp target/local-business-review.war /path/to/tomcat/webapps/

# Start Tomcat
# Windows
cd /path/to/tomcat/bin
startup.bat

# macOS/Linux
cd /path/to/tomcat/bin
./startup.sh

# Access application at:
http://localhost:8080/local-business-review/
```

### Method 3: Using Embedded Tomcat (Maven Plugin)

```bash
mvn tomcat7:run

# Access at: http://localhost:8080/local-business-review/
```

### Verify Installation

1. Open browser to `http://localhost:8080/`
2. You should see the landing page
3. Try logging in with test credentials
4. Test CRUD operations

## 👥 User Roles & Permissions

### Admin
- Full system access
- Manage all users (activate/deactivate, change roles, delete)
- Approve/reject business submissions
- Manage all businesses (edit, delete)
- Manage all reviews (approve, delete)
- Manage categories (create, update, delete)
- View comprehensive statistics

### Business Owner
- Register and manage own businesses
- View business statistics
- Edit own business details
- View reviews for own businesses
- Business submissions require admin approval

### Regular User
- Browse all approved businesses
- Search and filter businesses
- Write reviews (one per business)
- Edit and delete own reviews
- View own review history
- Rate businesses (1-5 stars)

### Guest (Not Logged In)
- View landing page
- Browse businesses
- View business details and reviews
- Search businesses
- Cannot write reviews or manage businesses

## 📸 Screenshots

### Landing Page
- Hero section with search
- Featured businesses
- Top-rated businesses
- Category cards
- Statistics overview

### User Dashboard
- Review history
- Statistics cards
- Quick actions

### Business Owner Dashboard
- My businesses list
- Business statistics
- Add/edit businesses

### Admin Dashboard
- System-wide statistics
- Pending approvals
- User management
- Category management

### Business Details
- Business information
- Average rating display
- Customer reviews
- Review form (for logged-in users)

## 🔑 Testing Credentials

Use these credentials for testing different roles:

### Admin Account
```
Username: admin
Password: Admin123
```

### Business Owner Accounts
```
Username: john_doe
Password: 12345678

Username: bob_wilson
Password: 12345678
```

### Regular User Accounts
```
Username: jane_smith
Password: 12345678

Username: alice_brown
Password: 12345678
```

## 🔗 API Endpoints (Servlets)

### Authentication
- `POST /login` - User login
- `GET /logout` - User logout
- `POST /register` - User registration

### Businesses
- `GET /business?action=list` - List all businesses
- `GET /business?action=view&id={id}` - View business details
- `GET /business?action=add` - Show add business form
- `POST /business?action=create` - Create new business
- `GET /business?action=edit&id={id}` - Show edit form
- `POST /business?action=update` - Update business
- `GET /business?action=delete&id={id}` - Delete business
- `GET /business?action=myBusinesses` - List owner's businesses

### Reviews
- `GET /review?action=add&businessId={id}` - Show review form
- `POST /review?action=create` - Create review
- `GET /review?action=edit&id={id}` - Show edit form
- `POST /review?action=update` - Update review
- `GET /review?action=delete&id={id}` - Delete review
- `GET /review?action=myReviews` - List user's reviews

### Search
- `GET /search?keyword={keyword}&location={location}&categoryId={id}` - Search businesses

### Admin Operations
- `POST /admin?action=approveBusiness&businessId={id}` - Approve business
- `POST /admin?action=rejectBusiness&businessId={id}` - Reject business
- `POST /admin?action=updateUserStatus` - Change user status
- `POST /admin?action=updateUserRole` - Change user role
- `POST /admin?action=deleteUser&userId={id}` - Delete user

### Categories
- `POST /category?action=create` - Create category
- `POST /category?action=update` - Update category
- `POST /category?action=delete&categoryId={id}` - Delete category

## 🧪 Testing the Application

### Manual Testing Checklist

#### User Registration & Login
- [ ] Register new user with valid data
- [ ] Try registration with existing username/email
- [ ] Test password validation (min 8 chars, alphanumeric)
- [ ] Login with valid credentials
- [ ] Test login with invalid credentials
- [ ] Verify session creation
- [ ] Test logout functionality

#### Business CRUD (Business Owner)
- [ ] Add new business
- [ ] Verify admin approval required
- [ ] Edit own business
- [ ] Try to edit other owner's business (should fail)
- [ ] View business statistics

#### Review CRUD (Regular User)
- [ ] Add review to business
- [ ] Try to add duplicate review (should fail)
- [ ] Edit own review
- [ ] Delete own review
- [ ] View review history

#### Search & Filter
- [ ] Search by business name
- [ ] Search by location
- [ ] Filter by category
- [ ] Test combined search criteria

#### Admin Functions
- [ ] Approve pending business
- [ ] Reject pending business
- [ ] Change user role
- [ ] Activate/deactivate user
- [ ] Delete user (not self)
- [ ] Manage categories

#### Authorization
- [ ] Try accessing admin pages as regular user
- [ ] Try accessing owner pages as regular user
- [ ] Test session timeout

#### Validation
- [ ] Test email format validation
- [ ] Test phone number validation
- [ ] Test required fields
- [ ] Test rating range (1-5)

## 🐛 Troubleshooting

### Common Issues

#### 1. Database Connection Error
```
Error: Unable to connect to database
```
**Solution:**
- Verify MySQL is running
- Check database credentials in `DBConnection.java`
- Ensure database exists: `SHOW DATABASES;`
- Test connection: `mysql -u root -p`

#### 2. ClassNotFoundException: com.mysql.cj.jdbc.Driver
**Solution:**
- Add MySQL Connector/J to classpath
- Verify `mysql-connector-j` dependency in `pom.xml`
- Run `mvn clean install`
- Check `WEB-INF/lib/` contains MySQL JAR

#### 3. HTTP 404 - Not Found
**Solution:**
- Verify Tomcat is running
- Check deployment context path
- Ensure WAR is deployed to `webapps/`
- Check Tomcat logs: `logs/catalina.out`

#### 4. JSP Compilation Error
**Solution:**
- Clean and rebuild project: `mvn clean package`
- Delete Tomcat work directory
- Restart Tomcat

#### 5. Session Not Working
**Solution:**
- Check browser cookies enabled
- Verify session timeout in `web.xml`
- Clear browser cache and cookies

#### 6. Cannot Login (Correct Credentials)
**Solution:**
- Verify password hashing matches
- Check user status is 'active'
- Review `authenticate()` method logs

### Enable Detailed Logging

Add to `web.xml`:
```xml
<context-param>
    <param-name>log_level</param-name>
    <param-value>DEBUG</param-value>
</context-param>
```

## 📝 Development Notes

### Code Organization
- **Model Classes**: Plain JavaBeans with getters/setters
- **DAO Pattern**: Separates data access logic
- **Servlet Controllers**: Handle HTTP requests
- **JSP Views**: Presentation layer
- **Utility Classes**: Reusable helper functions
- **Filters**: Request/response processing

### Best Practices Implemented
- ✅ Prepared statements (SQL injection prevention)
- ✅ Password hashing (security)
- ✅ Input validation (server-side)
- ✅ Exception handling (try-catch blocks)
- ✅ Resource management (try-with-resources)
- ✅ Session management (authentication)
- ✅ Role-based access control
- ✅ Clean code principles
- ✅ MVC architecture

### Future Enhancements
- [ ] Email verification for registration
- [ ] Password reset functionality
- [ ] Business image upload
- [ ] Advanced search filters
- [ ] Export reports (PDF, Excel)
- [ ] Email notifications
- [ ] Social media integration
- [ ] RESTful API
- [ ] Unit tests (JUnit)
- [ ] Integration tests

## 📄 License

This project is licensed under the MIT License.

```
MIT License

Copyright (c) 2026 Local Business Review

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

## 🙏 Acknowledgments

- Bootstrap team for the excellent CSS framework
- Font Awesome for icons
- Google Fonts for Outfit typeface
- Apache Tomcat team
- MySQL development team

## 📞 Support

For issues, questions, or contributions:
1. Check existing documentation
2. Search closed issues
3. Open a new issue on GitHub
4. Provide detailed error messages and logs

---

**Made with ❤️ using Java EE, JSP, Servlets & MySQL**

**⭐ If you find this project helpful, please give it a star!**