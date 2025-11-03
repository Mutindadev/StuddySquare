# StudySquare

**Mobile App Development with Flutter Virtual Internship — Group 27**  
**Department Associate:** Kolawole Oparinde  
**Team Members:**  
- [Regina Mutinda](mailto:rmmutinda02@gmail.com)
- [Sai Keerthana](mailto:saikeerthana1112@gmail.com)  
- [Elton Mwangi](mailto:eltonmwangi8@gmail.com)
- [Favoured Mwange](mailto:mwangefavoured@gmail.com)  
- [Niloy Mutsuddy](mailto:niloymutsuddy2001@gmail.com)  
- [Mathias Mutua](mailto:triplem706@gmail.com)

### 🖼️ Screenshots  

<div align="center">

<!-- Row 1 -->
<img width="230" height="480" alt="Login Screen" src="https://github.com/user-attachments/assets/df844dfa-fdb1-42ed-921e-7ebb197bdc52" />
<img width="230" height="480" alt="Profile Screen" src="https://github.com/user-attachments/assets/e0c38ba5-73b8-46c1-936b-1a36a251f1ba" />
<img width="230" height="480" alt="Empty Dashboard" src="https://github.com/user-attachments/assets/529d6636-ec33-480f-9603-4fb633f10d6f" />
<img width="230" height="480" alt="Program Detail Screen 1" src="https://github.com/user-attachments/assets/8d4edc3d-04e5-47d5-b45b-66827c716b85" />

<!-- Row 2 -->
<img width="230" height="480" alt="Program Detail Screen 2" src="https://github.com/user-attachments/assets/6c9bef83-bb4c-4c0a-a33f-e110e24ff719" />
<img width="230" height="480" alt="Program Listing" src="https://github.com/user-attachments/assets/35fd2e2e-f119-42c6-a5b3-a8fab44bf21e" />
<img width="230" height="480" alt="Updated Dashboard" src="https://github.com/user-attachments/assets/43653674-b4ed-496e-b80d-410b33177f31" />
<img width="230" height="480" alt="Progress Page" src="https://github.com/user-attachments/assets/0e907f8e-040f-4aa4-bcef-a6033279c683" />

</div>

---

---

### 🎥 Demo Video  

📹 [View Demo Video](https://drive.google.com/drive/folders/1Y2ENMF1j0Eo_nJBXmgCuTzGOtg-1a0yB?usp=drive_link)

---

### 🎨 Reference  

Figma Design: [StudySquare UI Design](https://www.figma.com/design/FyDv6MV9Q4w8eP5bsJ4JCy/app_dev)

## 🧩 App Wireframes

**Core Screens:**

- Login Screen  
- Home Screen  
- Program Listing Screen  
- Program Details Screen  
- Profile Screen  

---

### 💾 GitHub Repository  

All source files are available in our shared repository:  
🔗 [StudySquare GitHub Repository](https://github.com/Mutindadev/StuddySquare)

---

## 📘 Overview

StudySquare is a cross-platform mobile application developed during the **Mobile App Development with Flutter Virtual Internship** by Group 27.  
The app is designed to bridge the gap between learners and administrators within the **Excelerate ecosystem**, providing a digital space where users can explore programs, access learning materials, track their progress, and stay updated on announcements, all in one interactive environment.

The project aims to **empower learners, simplify administrative tasks, and enhance digital education delivery** through a user-centered and visually engaging Flutter interface.

---

## 🎯 Purpose

The purpose of this app is to create an engaging, all-in-one learning platform that enhances the experience of learners and administrators by:

- Centralizing program listings and details for easy access.  
- Allowing learners to view, enroll, and engage in available learning opportunities.  
- Providing administrators with tools to manage learning content, announcements, and user feedback.  
- Building a structured, intuitive, and accessible environment that aligns with **Excelerate's mission** to make education more innovative, inclusive, and impactful.  

---

## 🌍 Alignment with Excelerate's Mission, Vision & Values

| Excelerate Core                                               | How StudySquare Aligns                                                                        |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| **Mission:** Empower learners through digital education.      | StudySquare enables access to programs and courses digitally, fostering continuous learning.  |
| **Vision:** Make quality learning accessible and connected.   | The app bridges the learner-admin gap, connecting users through an intuitive mobile platform. |
| **Values:** Innovation, Collaboration, Growth, Accessibility. | The app encourages teamwork, scalable growth, and user-friendly innovation in learning.       |

---

## 👥 Target Users

- **Learners:** Individuals seeking to explore and enroll in learning programs.  
- **Administrators (Excelerate Team):** Manage programs, post updates, and monitor engagement.  

---

🔄 Process & Development Journey

### 🧭 Planning & Design

- Defined the app’s purpose, target users, and features in the **App Proposal Document**.  
- Designed low-fidelity **wireframes** for the core user flow (Login → Dashboard → Program Details → Progress → Profile).  
- Set up a structured **GitHub repository** and base Flutter project layout.  

### 🏗️ Implementation Phase

The team collaboratively translated the designs into functional Flutter screens with smooth navigation and interactive components.

**Core Screens Implemented:**

- 🔐 Login & Authentication Screen  
- 🏠 Dashboard (Home) Screen  
- 📚 Program Listing Screen  
- 📄 Program Details Screen  
- 👤 Profile Screen  
- 📈 Progress Tracking Page  

Each screen followed clean design principles, ensuring responsiveness and a consistent user experience.

---

## 🚀 App Features

### 1. **User Authentication**

- Secure registration and login powered by **FirebaseAuth**.  
- Includes a simplified flow for user login and registration within one interface.  
- Validations ensure strong password requirements (uppercase, lowercase, number, special character).  
- Real-time feedback for invalid or duplicate credentials.

### 2. **User Dashboard**

- Displays enrolled courses, time spent, and learning streaks.  
- Highlights recommended programs for new users.  
- Automatically updates once users enroll in a program.

### 3. **Program Listing**

- Fetches data dynamically from `assets/data/programs.json`.  
- Each card shows course duration, progress, and quick “View Details” actions.  
- Integrated with **Riverpod** for real-time state updates.  

### 4. **Program Details**

- Displays complete curriculum with weekly tasks, readings, quizzes, and projects.  
- Enroll/Continue button dynamically changes based on user enrollment status.  
- Week progression locked until previous week completion (gating logic).  

### 5. **Profile Page**

- Reads and updates data from `assets/profile.json`.  
- Displays editable user information (name, email, preferences).  
- Real-time updates reflected through JSON simulation and providers.  

### 6. **Progress Tracking**

- Tracks user progress across all enrolled programs.  
- Data persisted locally using `SharedPreferences`.  
- Automatically loads progress upon login.

---

## 🧭 User Journey Examples

### **Learner Journey**

1. **Sign Up / Log In:** Kim creates his StudySquare account using email and selects his learning interests.  
2. **Access Dashboard:** Personalized dashboard displays recommended courses and learning progress.  
3. **Enroll in a Course:** He enrolls in "AI & ML Skill Develpment" and begins learning.  
4. **Interactive Learning:** Engages with structured video lessons, exercises, and quizzes.  
5. **Track Progress:** Earns badges, XP points, and tracks milestones.  
6. **Receive Reminders:** Gets daily notifications to maintain streaks and explore new courses.  
7. **Earn Certificate:** Completes a course and downloads a digital Certificate of Achievement.  
8. **Feedback:** Leaves a rating and review to improve course quality.  

---

## 🧩 Tech Stack

| Component              | Technology Used      |
| ---------------------- | -------------------- |
| **Frontend**           | Flutter              |
| **State Management**   | Provider             |
| **Backend**            | Firebase             |
| **Database**           | Firestore            |
| **Authentication**     | Firebase Auth        |
| **Storage**            | Firebase Storage     |
| **Version Control**    | Git & GitHub         |
| **Wireframes/Design**  | Figma                |

---

## ⚙️ Technical Implementation

### 🧩 Architecture

StudySquare follows a **clean architecture** structure separating:

- **Presentation Layer:** UI and state management  
- **Domain Layer:** Business logic, providers, and data flow  
- **Data Layer:** JSON and local persistence logic  

---

## 🏗️ Project Structure

```text
StudySquare/
├── .fvm/                                  # Flutter Version Management
│   └── versions/
│       └── 3.35.3/                        # Flutter 3.35.3 managed by FVM
├── .fvmrc                                 # FVM configuration file
├── .vscode/                               # VS Code workspace settings
│   └── settings.json                      # IDE configuration
├── android/                               # Android platform files
│   ├── .sdkmanrc                         # SDKMAN Java version config (21.0.8-tem)
│   ├── app/
│   │   └── build.gradle.kts              # Android build configuration
│   └── gradle/
│       └── wrapper/
│           └── gradle-wrapper.properties
├── assets/                                # Static assets
│   ├── images/
│   │   └── .gitkeep                      # Placeholder for images
│   ├── fonts/
│   │   └── .gitkeep                      # Placeholder for fonts
│   └── icons/
│       └── .gitkeep                      # Placeholder for icons
├── ios/                                   # iOS platform files
├── lib/                                   # Main Flutter source code
│   ├── main.dart                         # Application entry point
│   ├── app/                              # App-level configuration
│   │   ├── app.dart                      # Main app widget configuration
│   │   ├── routes/                       # Navigation and routing
│   │   │   ├── app_routes.dart          # Route definitions and constants
│   │   │   └── route_generator.dart     # Dynamic route generation logic
│   │   └── themes/                       # UI theming and styling
│   │       ├── app_theme.dart           # Main theme configuration
│   │       ├── colors.dart              # Color palette and constants
│   │       └── text_styles.dart         # Typography definitions
│   ├── core/                            # Core utilities and shared logic
│   │   ├── constants/                   # Application constants
│   │   │   ├── api_constants.dart       # API endpoints and configurations
│   │   │   ├── app_constants.dart       # General app constants
│   │   │   └── storage_keys.dart        # Local storage key definitions
│   │   ├── errors/                      # Error handling system
│   │   │   ├── exceptions.dart          # Custom exception definitions
│   │   │   ├── failures.dart            # Failure classes for error states
│   │   │   └── error_handler.dart       # Centralized error handling
│   │   ├── network/                     # Network layer configuration
│   │   │   ├── api_client.dart          # HTTP client setup and configuration
│   │   │   └── network_info.dart        # Network connectivity utilities
│   │   ├── utils/                       # Utility functions and helpers
│   │   │   ├── validators.dart          # Input validation functions
│   │   │   ├── date_utils.dart          # Date formatting and manipulation
│   │   │   ├── string_utils.dart        # String manipulation utilities
│   │   │   └── image_utils.dart         # Image processing utilities
│   │   └── usecases/                    # Base use case interfaces
│   │       └── usecase.dart             # Abstract base use case class
│   ├── features/                        # Feature-based modules (Clean Architecture)
│   │   ├── auth/                        # Authentication feature
│   │   │   ├── data/                    # Data layer
│   │   │   │   ├── data_sources/        # Data source implementations
│   │   │   │   │   ├── auth_local_data_source.dart    # Local auth storage
│   │   │   │   │   └── auth_remote_data_source.dart   # Remote auth API
│   │   │   │   ├── models/              # Data models and DTOs
│   │   │   │   │   ├── user_model.dart               # User data model
│   │   │   │   │   └── login_response_model.dart     # Login API response model
│   │   │   │   └── repositories/        # Repository implementations
│   │   │   │       └── auth_repository_impl.dart    # Auth repository concrete class
│   │   │   ├── domain/                  # Domain/Business logic layer
│   │   │   │   ├── entities/            # Business entities
│   │   │   │   │   └── user.dart        # User entity definition
│   │   │   │   ├── repositories/        # Repository interfaces
│   │   │   │   │   └── auth_repository.dart         # Auth repository contract
│   │   │   │   └── usecases/            # Business use cases
│   │   │   │       ├── login_user.dart             # Login use case
│   │   │   │       ├── register_user.dart          # Registration use case
│   │   │   │       └── logout_user.dart            # Logout use case
│   │   │   └── presentation/            # Presentation/UI layer
│   │   │       ├── providers/           # State management (Provider)
│   │   │       │   └── auth_provider.dart          # Authentication state provider
│   │   │       ├── pages/               # Screen/Page widgets
│   │   │       │   ├── login_page.dart             # Login screen
│   │   │       │   ├── register_page.dart          # Registration screen
│   │   │       │   └── forgot_password_page.dart   # Password reset screen
│   │   │       └── widgets/             # Feature-specific widgets
│   │   │           ├── auth_form.dart              # Authentication form widget
│   │   │           └── social_login_button.dart    # Social media login buttons
│   │   ├── dashboard/                   # Dashboard feature
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── dashboard_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── dashboard_data_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── dashboard_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── dashboard_data.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── dashboard_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       └── get_dashboard_data.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── dashboard_provider.dart     # Dashboard state management
│   │   │       ├── pages/
│   │   │       │   └── dashboard_page.dart         # Main dashboard screen
│   │   │       └── widgets/
│   │   │           ├── course_card.dart            # Course display card
│   │   │           ├── progress_indicator.dart     # Progress visualization
│   │   │           └── stats_widget.dart           # Statistics display
│   │   ├── courses/                     # Course management feature
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── courses_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── course_model.dart
│   │   │   │   │   └── lesson_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── courses_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── course.dart
│   │   │   │   │   └── lesson.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── courses_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_courses.dart
│   │   │   │       ├── enroll_in_course.dart
│   │   │   │       └── get_course_details.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── courses_provider.dart       # Course listing state
│   │   │       │   └── course_details_provider.dart # Individual course state
│   │   │       ├── pages/
│   │   │       │   ├── courses_list_page.dart      # Course catalog screen
│   │   │       │   ├── course_details_page.dart    # Course detail screen
│   │   │       │   └── lesson_page.dart            # Individual lesson screen
│   │   │       └── widgets/
│   │   │           ├── course_tile.dart            # Course list item
│   │   │           ├── lesson_content.dart         # Lesson content display
│   │   │           └── enrollment_button.dart      # Course enrollment button
│   │   ├── profile/                     # User profile feature
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── profile_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── profile_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── profile_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── profile.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── profile_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_profile.dart
│   │   │   │       └── update_profile.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── profile_provider.dart       # Profile state management
│   │   │       ├── pages/
│   │   │       │   ├── profile_page.dart           # Profile view screen
│   │   │       │   └── edit_profile_page.dart      # Profile editing screen
│   │   │       └── widgets/
│   │   │           ├── profile_avatar.dart         # Profile picture widget
│   │   │           └── profile_info_tile.dart      # Profile information display
│   │   ├── progress/                    # Learning progress feature
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── progress_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── progress_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── progress_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── progress.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── progress_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_progress.dart
│   │   │   │       └── update_progress.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── progress_provider.dart      # Progress tracking state
│   │   │       ├── pages/
│   │   │       │   └── progress_page.dart          # Progress overview screen
│   │   │       └── widgets/
│   │   │           ├── progress_chart.dart         # Progress visualization charts
│   │   │           └── achievement_badge.dart      # Gamification badges
│   │   ├── notifications/               # Notification system feature
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── notifications_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── notification_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── notifications_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── notification.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── notifications_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_notifications.dart
│   │   │   │       └── mark_as_read.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── notifications_provider.dart # Notification state
│   │   │       ├── pages/
│   │   │       │   └── notifications_page.dart     # Notifications center
│   │   │       └── widgets/
│   │   │           └── notification_tile.dart      # Individual notification item
│   │   └── admin/                       # Administrative features
│   │       ├── data/
│   │       │   ├── data_sources/
│   │       │   │   └── admin_remote_data_source.dart
│   │       │   ├── models/
│   │       │   │   └── admin_analytics_model.dart
│   │       │   └── repositories/
│   │       │       └── admin_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── admin_analytics.dart
│   │       │   ├── repositories/
│   │       │   │   └── admin_repository.dart
│   │       │   └── usecases/
│   │       │       ├── get_user_analytics.dart
│   │       │       └── manage_courses.dart
│   │       └── presentation/
│   │           ├── providers/
│   │           │   ├── admin_provider.dart         # Admin dashboard state
│   │           │   └── user_management_provider.dart # User management state
│   │           ├── pages/
│   │           │   ├── admin_dashboard_page.dart   # Admin control panel
│   │           │   └── user_management_page.dart   # User administration
│   │           └── widgets/
│   │               ├── analytics_chart.dart        # Admin analytics charts
│   │               └── user_list_tile.dart         # User management list items
│   ├── shared/                          # Shared components across features
│   │   ├── widgets/                     # Reusable UI components
│   │   │   ├── custom_button.dart       # Standardized button component
│   │   │   ├── custom_text_field.dart   # Standardized text input field
│   │   │   ├── loading_widget.dart      # Loading state indicators
│   │   │   ├── error_widget.dart        # Error state display
│   │   │   ├── app_bar_widget.dart      # Custom application bar
│   │   │   └── bottom_nav_bar.dart      # Bottom navigation component
│   │   ├── models/                      # Shared data models
│   │   │   └── base_model.dart          # Base model class with common functionality
│   │   ├── providers/                   # Global state providers
│   │   │   ├── app_provider.dart        # Global application state
│   │   │   ├── theme_provider.dart      # Theme switching state
│   │   │   └── connectivity_provider.dart # Network connectivity state
│   │   └── extensions/                  # Dart language extensions
│   │       ├── string_extensions.dart   # String utility extensions
│   │       ├── context_extensions.dart  # BuildContext utility extensions
│   │       └── date_extensions.dart     # DateTime utility extensions
│   └── services/                        # External service integrations
│       ├── local_storage_service.dart   # Local storage (SharedPreferences)
│       ├── firebase_service.dart        # Firebase SDK integration
│       ├── notification_service.dart    # Push notification service
│       ├── analytics_service.dart       # Analytics and tracking service
│       └── dependency_injection.dart    # Service locator and DI setup
├── test/                                # Testing suite
│   ├── integration/                     # End-to-end integration tests
│   │   └── .gitkeep
│   ├── unit/                           # Unit tests for business logic
│   │   └── .gitkeep
│   └── widget/                         # Widget and UI component tests
│       └── .gitkeep
├── .gitignore                         # Git version control ignore rules
├── .metadata                          # Flutter project metadata
├── analysis_options.yaml             # Dart static analysis configuration
├── pubspec.yaml                       # Flutter dependencies and configuration
├── pubspec.lock                       # Locked dependency versions
├── setup.sh                          # macOS/Linux development setup script
├── setup.bat                         # Windows development setup script
└── readMe.md                         # Project documentation and setup guide
```

---

### 🧠 State Management

- `EnrollmentProvider` — Handles user enrollment and unenrollment logic.  
- `ProgressProvider` — Tracks and updates learning progress.  
- `AuthProvider` — Manages Firebase login states and authentication flow.  

### 💾 Persistence Layer

- **SharedPreferences** used for user-specific data storage:
  - `enrollments_{uid}`
  - `progress_{uid}_{programId}`
- Data auto-syncs upon login and logout.

---

## 🧹 Final Improvements & Stability Fixes

- Fixed **app freeze** issue on login by refactoring `main.dart` to use `ChangeNotifierProxyProvider`.  
- Resolved **crashes from unmounted context** using `if (!mounted) return;` checks.  
- Removed deprecated **Admin Login** routes and providers to improve security.  
- Refined **UI transitions** and defaulted the app to open directly on the user login screen.  
- Simplified routing and improved performance across pages.
  
  ---
  
## 🧠 Outcomes

- **Improved Learning Access:** Easy exploration and enrollment in learning programs.  
- **Enhanced Engagement:** Interactive, motivating, and learner-centered experiences.  
- **Streamlined Experience:** Simple navigation and better user flow.  
- **Feedback Integration:** Continuous improvement from learner insights.  
- **Admin Efficiency:** Simplified course and user management.  
- **Future Scope (Data-Driven Insights):** Analytics to improve learning outcomes.  
- **Mission Alignment:** Supports Excelerate's vision of inclusive and accessible digital learning.  

---

## 🧠 Challenges & Learnings

- Implementing **persistent progress tracking** across sessions required deep understanding of local data handling.  
- Ensuring **smooth navigation** between multiple pages using Flutter routes.  
- Handling **JSON-driven UI updates** effectively for dynamic data.  
- Debugging and refactoring **asynchronous errors** without breaking the flow.  

This project strengthened our skills in **collaborative version control, state management, UI/UX consistency, and app scalability.**

---

## 🚀 Getting Started

### 1. Clone Repository

```bash
git clone https://github.com/Mutindadev/StuddySquare.git
cd StuddySquare
```

2.Install Dependencies

 ```bash
flutter pub get

```

3.Run App

```bash
flutter run
```

---

## 🧪 Testing

| Test Type | Description | Status |
|------------|-------------|--------|
| Unit Tests | Enrollment + Progress Providers | ✅ Passed |
| Integration Tests | Enrollment Flow | ✅ Passed |
| UI Tests | Dynamic Rendering + Error Handling | ✅ Passed |


---

### 🔮 Future Improvements and Next Steps  
-Migrate from local JSON to Firebase/REST API.
-Add dark mode and user analytics.
-Improve UI transitions using Flutter animations.
-These upcoming improvements will elevate the platform’s overall user experience, making StudySquare more secure, scalable, and learner-centered.

---

💬 Credits

Team 27 - Excelerate Flutter Internship (MAD Track)
Developed by:Team 27
Supervised by: Excelerate Internship Program Leads

- ## 👥 Team 27 — Roles & Contributions  

| Team Member | Role | Key Contributions |
|--------------|------|------------------|
| **Regina Mutinda** | Team Lead | Developed the Dashboard screen, handled data reading from JSON and profile integration, co-authored documentation, coordinated team deliverables, and managed project workflow. |
| **Mathias Mutua** | Developer | Implemented the Login screen and authentication logic, integrated Firebase authentication, and managed JSON-based user validation. |
| **Niloy Mutsuddy** | Developer | Built the Program Listing and Program Detail screens, ensuring smooth data flow and UI consistency. |
| **Sai Keerthana** | Developer & Project Scribe | Developed the Profile page, co-authored documentation, and assisted in maintaining project structure. |
| **Favoured Mwange** | Developer | Created the Progress page, implementing the user progress tracking and UI updates. |
| **Elton Mwangi** | Project Manager | Oversaw code reviews, maintained clean architecture, ensured adherence to coding standards, and coordinated beta testing. |


**Department Associate:** Kolawole Oparinde  

---

## 🌟 Team Reflection  

Throughout this internship journey, **Team 27** grew from a group of individual learners into a cohesive, highly collaborative development team.  
From our very first design sketches to the final deployment of **StudySquare**, every challenge became a shared opportunity to learn, refine, and improve.

We mastered version control through GitHub, strengthened our understanding of **Flutter**, **Firebase**, and **clean architecture**, and learned how to communicate effectively across different time zones and skill levels.  
Every milestone—whether debugging crashes, refining the dashboard UI, or implementing JSON-based data—taught us the value of teamwork, patience, and persistence.

Beyond coding, we discovered what it means to deliver real-world solutions under deadlines, document our progress clearly, and uphold professional standards in our workflows.  
By the end of this project, we not only built a functional learning app but also built confidence, leadership, and collaboration skills that will guide us in our future professional journeys.

> Together, we didn’t just complete a project — we built a product we’re proud of.  
> — **Team 27 (StudySquare)**

---

---

## ✅ Conclusion

StudySquare represents a meaningful step toward **accessible, engaging, and gamified digital learning**.  
By combining structured learning, progress tracking, and community engagement, it empowers learners to grow continuously while giving admins the tools to manage learning effectively — perfectly aligning with Excelerate's mission to bridge the gap between education and opportunity.  

---

## 🛠️ Development Setup

## 📋 Version Requirements

- **Flutter**: 3.35.3 (managed by FVM)
- **Java**: 21.0.8-tem (managed by SDKMAN)
- **Dart SDK**: ^3.9.2

## 🏛️ Architecture Overview

This project follows **Clean Architecture** principles with **Provider** for state management:

### **Architecture Layers:**

1. **Presentation Layer** (`presentation/`): UI components, pages, and Provider state management
2. **Domain Layer** (`domain/`): Business logic, entities, use cases, and repository interfaces  
3. **Data Layer** (`data/`): Data sources, models, and repository implementations

### **Key Benefits:**

- **Separation of Concerns**: Each layer has distinct responsibilities
- **Testability**: Easy to unit test business logic independently
- **Maintainability**: Changes in one layer don't affect others
- **Scalability**: New features can be added without disrupting existing code
- **Provider Integration**: Simple state management with reactive UI updates

### Prerequisites

- [SDKMAN](https://sdkman.io/) for Java version management
- [FVM](https://fvm.app/) for Flutter version management

### Quick Setup

1. Clone the repository
2. Run the setup script:

   ```bash
   # On macOS/Linux
   chmod +x setup.sh
   ./setup.sh
   
   # On Windows
   setup.bat
   ```

### Manual Setup

1. Install correct Flutter version:

   ```bash
   fvm install
   fvm use
   ```

2. Install correct Java version (in android directory):

   ```bash
   sdk env install
   sdk env
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

### Running the App

```bash
flutter run
```

---
