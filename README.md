# Local Business Review Website
## Project Overview

Local Business Review Website is a full-stack web application designed to help users discover, review, and rate local businesses across Africa, with particular emphasis on Rwandan businesses.

## The platform enables:

- Business owners to register and manage their establishments

- Users to share experiences through reviews and ratings

- Administrators to moderate content and manage the system

## Key Highlights

- [x] 40+ African businesses across 15+ countries

- [x] Full CRUD operations for all entities

- [x] Role-based access control (Admin, Business Owner, User)

- [x] Business approval workflow (Pending → Approved/Rejected)

- [x] 5-star rating system with detailed reviews

- [x] Advanced search & filtering (name, location, category)

- [x] Responsive design with modern UI/UX

- [x] Server-side validation and security measures

- [x] Production-ready code with robust error handling

# Features
## User Authentication & Authorization

Secure user registration with password validation

Login & logout with 30-minute session timeout

Role-based access control:

Admin: Full system access

Business Owner: Manage own businesses

Regular User: Browse and review businesses

Password encryption using SHA-512 hashing

Duplicate prevention (unique username & email)

## Business Management

Create: Submit new businesses (admin approval required)

Read: Browse all approved businesses

Update: Edit business details (owner/admin only)

Delete: Remove businesses (admin only)

Search: By name, location, or category

Status Workflow: Pending → Approved / Rejected

Ratings: Automatic average rating calculation

## Review System

Add reviews with 1–5 star ratings and comments

Edit & delete own reviews (admin override available)

One review per user per business (duplicate prevention)

Review moderation by admin

Display average ratings and review counts

## Category Management

Admin-only category CRUD operations

Track business count per category

Filter businesses by category

8 Default Categories:

Restaurant

Shopping

Services

Healthcare

Entertainment

Education

Automotive

Beauty & Spa

## Admin Dashboard

System statistics overview:

Total users

Businesses

Reviews

Categories

User management (roles, activation, deletion)

Business & review moderation

Category management

Centralized pending approvals queue

## Search & Discovery

Multi-criteria search (keyword + location + category)

Featured businesses (recently added)

Top-rated businesses

Browse by category

Location-based filtering (city/country)

## User Interface

Modern, clean, professional design

Fully responsive (mobile, tablet, desktop)

Outfit font from Google Fonts

Amber color scheme (#92400e)

Built with Bootstrap 5

Interactive UI elements (hover effects, transitions)

Visual star rating system

Success & error alert notifications

## Technologies Used
### Backend Technologies
Technology	Version	Purpose
Java	17	Core programming language
Jakarta Servlet	6.0	HTTP request handling
JSP	3.1	Dynamic page generation
JDBC	—	Database connectivity
Apache Tomcat	11	Application server
Maven	3.x	Build & dependency management
### Frontend Technologies
Technology	Version	Purpose
HTML5	—	Page structure
CSS3	—	Styling
Bootstrap	5.3	UI framework
JavaScript	ES6+	Client-side interactivity
Font Awesome	6.4	Icons
Google Fonts	—	Outfit typography
## Database
Technology	Version	Purpose
MySQL / MariaDB	8.0+ / 10.4+	Relational database
## Development Tools

IntelliJ IDEA – IDE

Git – Version control

XAMPP – Local development (MySQL/MariaDB)

Maven – Build automation

## License

This project is for educational and learning purposes.
You may extend or adapt it based on your needs.
