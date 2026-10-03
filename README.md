# EDUSAM ACADEMY - Full-Stack EdTech Web Application

A full-stack, production-ready EdTech platform inspired by **Physics Wallah (PW)**, built for NEET, IIT-JEE, and MHT-CET aspirants. Includes full course delivery, custom lecture workspace with real-time live chat, interactive daily practice problems (DPP), an instant AI Doubt Solver engine with NCERT citations, and an authentic NTA computer-based online test simulation with chapter-wise weakness heatmaps and predicted All-India Rank (AIR).

---

## 🌟 Key Features

### 1. Global Navigation & Exam Target Engine
- **Exam Target Selector**: Dynamically toggle between NEET, IIT-JEE, MHT-CET, Class 12 Boards, and 10th Foundation.
- **Role Switcher**: Instant switching between **Student**, **Teacher**, and **Dean/Admin** views for testability.
- **Top Bar**: Fast admissions hotline, scholarship alert, and "Book Free Demo Lecture" modal trigger.

### 2. High-Converting Marketplace & Lead Generation
- **Hero Banner**: Bold PW-style branding with verified AIR proof badges (NEET AIR 1, JEE Adv AIR 4 & 9, CET 99.98%tile).
- **Filterable Batches**: Filter by exam category and grade with discount tags, faculty names, syllabus modules, and pricing.
- **Instant Enrollment Modal**: Mock checkout flow with UPI QR code, credit card, and net banking options, plus coupon discounts (`EDUSAM1000` / `AIR1`).
- **Lead Capture Form**: Stores demo bookings directly into the `demo_leads` database table.

### 3. Student Dashboard & Lecture Workspace
- **Gamified Consistency Counters**: 14-day study streak, watch time metrics, and test history.
- **Custom High-Definition Video Player**:
  - Play / Pause, seek bar, time display, mute/unmute, and full-screen mode.
  - Playback speed controller: **1x, 1.25x, 1.5x, 2x**.
  - Video stream quality switcher: **1080p HD, 720p, 480p, 360p**.
- **Tabbed Classroom Container**:
  - **Tab 1: Lecture Notes**: High-resolution downloadable PDF notes and key revision formula summaries.
  - **Tab 2: DPP Quizzes**: Interactive Daily Practice Problems with instant scoring and explanation toggles.
  - **Tab 3: 24/7 AI Doubt Solver**: Natural language doubt input with step-by-step mathematical reasoning, master exam tips, and exact NCERT page references.
  - **Tab 4: Real-time Live Q&A Stream**: Supabase Realtime WebSocket subscription with instant sync and teacher replies.

### 4. NTA & CET Computer-Based Online Test Simulation (CBT)
- **Authentic NTA CBT Interface**:
  - Real-time countdown timer with auto-submit on timeout.
  - Question Palette matching official NTA standards:
    - 🟢 **Answered** (Green polygon)
    - 🔴 **Not Answered** (Red polygon)
    - 🟣 **Marked for Review** (Purple circle)
    - 🟣🟢 **Answered & Marked for Review** (Purple circle with green badge)
    - ⚪ **Not Visited** (Grey rectangle)
  - Subject switcher: Physics, Chemistry, Biology / Mathematics.
  - Actions: **Save & Next**, **Clear Response**, **Mark for Review & Next**, and **Submit Examination**.
- **Diagnostic Post-Test Analytics Dashboard**:
  - **Predicted All-India Rank (AIR)** calculated from official marks distribution.
  - Score (+4 correct, -1 incorrect), accuracy percentage, and time taken.
  - **Chapter-wise Weakness Heatmap**:
    - 🟢 **Strong** (>75% accuracy)
    - 🟡 **Average** (50-75% accuracy)
    - 🔴 **Weak** (<50% accuracy)
  - Question-by-question review with candidate response, correct answer, solution explanation, and NCERT line citation.

### 5. Administrative & Dean Console (`/admin`)
- Live inquiry leads pipeline with one-click filters and timestamps.
- Batch enrollment registry and gross revenue tracking.
- All-India mock test attempt diagnostics.

---

## 🛠️ Technology Stack

- **Frontend**: Next.js 15 (App Router), React 19, TypeScript, Tailwind CSS, Lucide React icons, Canvas Confetti.
- **Backend & APIs**: Next.js Server Route Handlers (`/api/batches`, `/api/leads/demo`, `/api/enrollment`, `/api/tests/submit`, `/api/ai/doubt`, `/api/auth`).
- **Database & Realtime**: Supabase (PostgreSQL, Row Level Security, Supabase Auth, WebSockets).
- **State & Fallback**: Unified store in `src/lib/store.ts` ensuring the portal is **100% testable and functional immediately** even before Supabase keys are configured.

---

## 🗄️ Database Schemas & Migrations

The database migration file is located at `supabase/schema.sql` and seed data at `supabase/seed.sql`:

1. `profiles`: Candidate profiles, role (student/admin/teacher), target exam, avatar.
2. `courses_batches`: Batches with title, slug, price, faculty, and validity.
3. `enrollments`: Student batch purchases with payment verification status.
4. `lectures`: Class curriculum, video links, duration, notes PDF, and DPP associations.
5. `live_chat_messages`: WebSocket-enabled real-time lecture discussion with pinned messages.
6. `test_series`: Exam rules, positive marks (+4), negative marking ratio (-1), duration.
7. `test_questions`: Subject MCQs with options, correct answer, explanations, and NCERT references.
8. `student_test_attempts`: Time-stamped results, accuracy %, answers JSON, and predicted AIR.
9. `demo_leads`: High-intent leads from landing pages and modals.

---

## 🚀 Getting Started

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Environment (Optional for Supabase)
Copy `.env.example` to `.env.local` and add your Supabase credentials:
```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```
*(Note: If left empty, the application runs in local fallback mode with persistent state and mock real-time events).*

### 3. Run Development Server
```bash
npm run dev
```
Open [http://localhost:3000](http://localhost:3000) to view the portal.

### 4. Build for Production
```bash
npm run build
```
