# 🧠 SafeSpace Doctor App

The **SafeSpace Doctor App** is part of the *SafeSpace Mental Health Platform*, a cross-platform Flutter application designed to support mental health professionals and students.  
This app enables doctors and counselors to connect with users seeking mental health assistance, manage appointments, view patient profiles, and monitor ongoing consultations — all through a secure and user-friendly interface.

---

## 📱 Overview

SafeSpace aims to bridge the mental health accessibility gap among Sri Lankan undergraduates by providing an integrated digital platform for early detection, self-assessment, and professional counseling.  
The **Doctor App** is specifically designed for mental health professionals to interact with the system, track user sessions, and provide timely support.

---

## 🧩 Features

- 🔐 **Secure Login & Authentication**
- 📊 **Doctor Dashboard** – View statistics and pending appointments
- 🗓️ **Appointments Management** – Accept, reschedule, or view session details
- 👩‍⚕️ **Patient Profiles** – Access patient records, progress, and chat history
- 💬 **Chat Interface** – Communicate with users through the integrated AI and chat system
- ⚙️ **Profile Management** – Edit personal details, availability, and preferences
- ☁️ **Cloud Integration** – Secure API and storage for patient data
- 🧠 **AI-Powered Insights** – Integration with SafeSpace’s AI chatbot for progress tracking

---

## 🏗️ Project Structure

lib/
├── main.dart
├── screens/
│ ├── login/
│ ├── dashboard/
│ ├── profile/
│ ├── appointments/
│ └── patients/
├── models/
├── services/
│ ├── auth_service.dart
│ ├── api_service.dart
│ └── storage_service.dart
├── widgets/
└── utils/

markdown
Copy code

**Folder Description:**
- `screens/` → UI screens organized by feature (Login, Dashboard, Profile, etc.)
- `models/` → Data structures for users, appointments, and patients
- `services/` → Backend integrations (authentication, APIs, and storage)
- `widgets/` → Reusable custom Flutter widgets
- `utils/` → Helper functions, constants, and utilities

---

## ⚙️ Tech Stack

- **Framework:** Flutter (Dart)
- **Backend:** FastAPI / Supabase
- **Database:** PostgreSQL / Supabase
- **AI Integration:** LangChain + Cohere/Together API
- **Version Control:** Git & GitHub

---

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/<your-username>/safespace-doctor-app.git