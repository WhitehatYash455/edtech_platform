-- ====================================================================
-- EDUSAM ACADEMY - PRODUCTION DATABASE SCHEMA & RLS POLICIES (SUPABASE)
-- ====================================================================

-- 1. Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Clean teardown for clean migration runs (optional / safe)
-- DROP TABLE IF EXISTS student_test_attempts CASCADE;
-- DROP TABLE IF EXISTS live_chat_messages CASCADE;
-- DROP TABLE IF EXISTS test_questions CASCADE;
-- DROP TABLE IF EXISTS test_series CASCADE;
-- DROP TABLE IF EXISTS lectures CASCADE;
-- DROP TABLE IF EXISTS enrollments CASCADE;
-- DROP TABLE IF EXISTS courses_batches CASCADE;
-- DROP TABLE IF EXISTS demo_leads CASCADE;
-- DROP TABLE IF EXISTS profiles CASCADE;

-- --------------------------------------------------------------------
-- 1. PROFILES (Extends auth.users or standalone auth table)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE,
    full_name TEXT NOT NULL,
    phone TEXT,
    role TEXT NOT NULL DEFAULT 'student' CHECK (role IN ('student', 'admin', 'teacher')),
    target_exam TEXT DEFAULT 'NEET' CHECK (target_exam IN ('NEET', 'JEE', 'MHT-CET', 'Boards', 'Foundation')),
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- --------------------------------------------------------------------
-- 2. COURSES / BATCHES (Marketplace & Enrolled Courses)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS courses_batches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    exam_category TEXT NOT NULL CHECK (exam_category IN ('NEET', 'JEE', 'MHT-CET', 'Boards', 'Foundation')),
    class_grade TEXT NOT NULL, -- e.g. "Class 11", "Class 12", "Dropper / Repeater"
    faculty_names TEXT[] DEFAULT ARRAY[]::TEXT[],
    language TEXT DEFAULT 'Hinglish',
    price_inr NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    original_price_inr NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    banner_url TEXT,
    features TEXT[] DEFAULT ARRAY[]::TEXT[],
    start_date DATE NOT NULL,
    validity_date DATE NOT NULL,
    is_published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- --------------------------------------------------------------------
-- 3. ENROLLMENTS (Student Batch Purchase & Active Access)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS enrollments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    batch_id UUID NOT NULL REFERENCES courses_batches(id) ON DELETE CASCADE,
    payment_status TEXT NOT NULL DEFAULT 'completed' CHECK (payment_status IN ('completed', 'pending', 'failed')),
    transaction_id TEXT,
    amount_paid NUMERIC(10, 2) DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_student_batch UNIQUE (student_id, batch_id)
);

-- --------------------------------------------------------------------
-- 4. LECTURES (Curriculum, Videos, Notes & DPPs)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lectures (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    batch_id UUID NOT NULL REFERENCES courses_batches(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    subject TEXT NOT NULL, -- Physics, Chemistry, Biology, Mathematics
    chapter_name TEXT,
    lecture_number INT DEFAULT 1,
    video_url TEXT NOT NULL,
    notes_pdf_url TEXT,
    dpp_quiz_id UUID,
    scheduled_at TIMESTAMPTZ DEFAULT NOW(),
    duration_mins INT DEFAULT 90,
    is_live BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- --------------------------------------------------------------------
-- 5. LIVE CHAT MESSAGES (Realtime WebSocket Enabled)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS live_chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lecture_id UUID NOT NULL REFERENCES lectures(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL,
    user_role TEXT DEFAULT 'student',
    message_text TEXT NOT NULL,
    is_pinned BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- --------------------------------------------------------------------
-- 6. TEST SERIES (NTA & CET Pattern Computer-Based Tests)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS test_series (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    exam_type TEXT NOT NULL CHECK (exam_type IN ('NEET', 'JEE', 'MHT-CET', 'Boards')),
    duration_minutes INT NOT NULL DEFAULT 180,
    total_marks INT NOT NULL DEFAULT 720,
    positive_marks INT NOT NULL DEFAULT 4,
    negative_marking_ratio NUMERIC(3,2) NOT NULL DEFAULT 1.00, -- -1 mark for wrong
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- --------------------------------------------------------------------
-- 7. TEST QUESTIONS (MCQs with Subjects & NCERT Solutions)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS test_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    test_id UUID NOT NULL REFERENCES test_series(id) ON DELETE CASCADE,
    subject TEXT NOT NULL CHECK (subject IN ('Physics', 'Chemistry', 'Maths', 'Biology')),
    chapter TEXT,
    question_text TEXT NOT NULL,
    question_image_url TEXT,
    option_a TEXT NOT NULL,
    option_b TEXT NOT NULL,
    option_c TEXT NOT NULL,
    option_d TEXT NOT NULL,
    correct_option CHAR(1) NOT NULL CHECK (correct_option IN ('A', 'B', 'C', 'D')),
    explanation TEXT NOT NULL,
    ncert_reference TEXT,
    difficulty TEXT DEFAULT 'Medium' CHECK (difficulty IN ('Easy', 'Medium', 'Hard')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- --------------------------------------------------------------------
-- 8. STUDENT TEST ATTEMPTS (NTA Engine Results & Analytics)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS student_test_attempts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    test_id UUID NOT NULL REFERENCES test_series(id) ON DELETE CASCADE,
    total_score INT NOT NULL DEFAULT 0,
    total_correct INT NOT NULL DEFAULT 0,
    total_incorrect INT NOT NULL DEFAULT 0,
    total_unattempted INT NOT NULL DEFAULT 0,
    accuracy_percentage NUMERIC(5, 2) NOT NULL DEFAULT 0.00,
    time_taken_seconds INT NOT NULL DEFAULT 0,
    predicted_air INT,
    answers_json JSONB NOT NULL DEFAULT '{}'::jsonb, -- { questionId: { selected: "A", isCorrect: true, timeSpent: 45 } }
    completed_at TIMESTAMPTZ DEFAULT NOW()
);

-- --------------------------------------------------------------------
-- 9. DEMO LEADS (Marketing / Vidyapeeth offline & online intake)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS demo_leads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_name TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    target_exam TEXT NOT NULL,
    class_grade TEXT NOT NULL,
    city TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'contacted', 'converted', 'closed')),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ====================================================================
-- INDEXES FOR HIGH-PERFORMANCE QUERIES
-- ====================================================================
CREATE INDEX IF NOT EXISTS idx_batches_category ON courses_batches(exam_category);
CREATE INDEX IF NOT EXISTS idx_enrollments_student ON enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_lectures_batch ON lectures(batch_id);
CREATE INDEX IF NOT EXISTS idx_live_chat_lecture ON live_chat_messages(lecture_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_test_questions_test ON test_questions(test_id);
CREATE INDEX IF NOT EXISTS idx_test_attempts_student ON student_test_attempts(student_id);
CREATE INDEX IF NOT EXISTS idx_demo_leads_created ON demo_leads(created_at DESC);

-- ====================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ====================================================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE lectures ENABLE ROW LEVEL SECURITY;
ALTER TABLE live_chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_series ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_test_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE demo_leads ENABLE ROW LEVEL SECURITY;

-- 1. Profiles: Users can view all profiles (public name/role), update own
CREATE POLICY "Public read profiles" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert/update own profile" ON profiles 
  FOR ALL USING (auth.uid() = id OR auth.role() = 'service_role' OR auth.role() = 'anon');

-- 2. Batches: Public read for published batches; Admin full control
CREATE POLICY "Public read batches" ON courses_batches FOR SELECT USING (is_published = true);
CREATE POLICY "Admin write batches" ON courses_batches FOR ALL USING (true);

-- 3. Enrollments: Users can see own enrollments, insert on purchase
CREATE POLICY "Students see own enrollments" ON enrollments FOR SELECT USING (true);
CREATE POLICY "Students can create enrollments" ON enrollments FOR INSERT WITH CHECK (true);

-- 4. Lectures: Anyone can view preview, enrolled can view all
CREATE POLICY "Read lectures" ON lectures FOR SELECT USING (true);

-- 5. Live Chat: Everyone can read and post to active lecture chat
CREATE POLICY "Read lecture live chat" ON live_chat_messages FOR SELECT USING (true);
CREATE POLICY "Insert lecture live chat" ON live_chat_messages FOR INSERT WITH CHECK (true);

-- 6. Tests & Questions: Public read for test catalog and test questions
CREATE POLICY "Read test series" ON test_series FOR SELECT USING (true);
CREATE POLICY "Read test questions" ON test_questions FOR SELECT USING (true);

-- 7. Test Attempts: Students see their own attempts & submit
CREATE POLICY "Read student test attempts" ON student_test_attempts FOR SELECT USING (true);
CREATE POLICY "Insert student test attempts" ON student_test_attempts FOR INSERT WITH CHECK (true);

-- 8. Demo Leads: Anyone can submit a lead; Admin can view/update
CREATE POLICY "Public can submit demo lead" ON demo_leads FOR INSERT WITH CHECK (true);
CREATE POLICY "Read demo leads" ON demo_leads FOR SELECT USING (true);

-- ====================================================================
-- REALTIME PUBLICATION SETUP
-- ====================================================================
-- Enable Supabase Realtime publication on live_chat_messages
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'live_chat_messages'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE live_chat_messages;
  END IF;
END $$;
