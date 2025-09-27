🚲 Wheelways

Wheelways is a role-based Flutter application designed to manage and monitor the usage of bicycles within a company environment. The app provides tailored functionalities for Employees, Security personnel, and Admins, ensuring efficient allocation, monitoring, and maintenance of bicycles.

✨ Features
👤 Employees

Login/Register into the system.

View available bicycles.

Request a bicycle (only one active allocation at a time).

Return allocated bicycle after use.

🛡️ Security

Check availability of bicycles.

Verify bicycle condition after return.

Categorize bicycles as Damaged or Undamaged.

Add new bicycles into the system.

🏢 Admin

Monitor the entire system’s activity.

Access all screens and functionalities of Employees and Security.

Track bicycle allocations and condition updates.

🔑 Constraints

Each employee can have only one bicycle allocated at a time.

Employees cannot request a new bicycle until the previous one is returned.

Damaged bicycles are excluded from the available list for employees.

🛠️ Tech Stack

Frontend: Flutter

Backend & Auth: Firebase Authentication

Database: Firebase Firestore

State Management:  Provider, Riverpod, etc.

Storage: Firestore documents for user roles, bicycles, and allocations

🚀 Getting Started
Prerequisites

Flutter SDK installed

Firebase project setup

Clone this repository

git clone https://github.com/SudharshanGeddam/WheelWays.git
cd wheelways

Setup

Run flutter pub get to install dependencies.

Configure Firebase in your project (google-services.json for Android, GoogleService-Info.plist for iOS).

Enable Email/Password Authentication in Firebase Console.

Create Firestore collections (users, bicycles) as per the structure above.

Run the App
flutter run

📱 Screenshots 

! Admin Home Screen | (assets/AppScreenShots/admin.jpg)
! Employee Home Screen | (assets/AppScreenShots/employee.jpg)
! Security Home Screen | (assets/AppScreenShots/security.jpg)
# More Screen shots available in AppScreenShots folder in assets.

📌 Future Improvements

Add Theme toggling (light/dark mode).

Expand Settings page with personalization options.

Add a transaction history/logs feature for better tracking.