-- ====================================================================
-- EDUSAM ACADEMY - SEED DATA SCRIPT (SUPABASE)
-- ====================================================================

-- 1. Insert Initial Profiles
INSERT INTO profiles (id, email, full_name, phone, role, target_exam, avatar_url)
VALUES 
  ('a1111111-1111-1111-1111-111111111111', 'student@edusam.ac.in', 'Yashraj Rathod', '+91 9876543210', 'student', 'NEET', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80'),
  ('a2222222-2222-2222-2222-222222222222', 'admin@edusam.ac.in', 'Prof. R.K. Verma (Dean)', '+91 9988776655', 'admin', 'JEE', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&auto=format&fit=crop&q=80'),
  ('a3333333-3333-3333-3333-333333333333', 'physics.head@edusam.ac.in', 'Dr. Sneha Sharma (HOD Physics)', '+91 9123456789', 'teacher', 'NEET', 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80')
ON CONFLICT (id) DO NOTHING;

-- 2. Insert 4 Complete Flagship Batches
INSERT INTO courses_batches (id, title, slug, description, exam_category, class_grade, faculty_names, language, price_inr, original_price_inr, banner_url, features, start_date, validity_date, is_published)
VALUES 
  (
    'b1111111-1111-1111-1111-111111111111',
    'LAKSHYA NEET 2027 (Dropper & 12th Intensive)',
    'lakshya-neet-2027',
    'India’s most celebrated NEET preparatory batch. Complete coverage of Class 11th & 12th Physics, Chemistry, Botany & Zoology by Kota & Ex-AIIMS top mentors. Includes live interactive classes, daily practice problems (DPP) with video solutions, 24/7 AI Doubt Engine, and 30 NTA-pattern mock tests.',
    'NEET',
    'Class 12 & Dropper',
    ARRAY['Dr. Sneha Sharma (Physics)', 'Prof. Arvind Saxena (Organic Chem)', 'Dr. Maithili Deshmukh (Zoology)'],
    'Hinglish (Hindi + English)',
    4499.00,
    14999.00,
    'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&auto=format&fit=crop&q=80',
    ARRAY['Daily Live 2-Hour Interactive Classes', 'Instant DPP Quizzes with Video Explanations', 'All-India NTA Simulation Test Series', 'Vidyapeeth Offline Library & Doubt Counters Access'],
    '2026-04-15',
    '2027-06-30',
    true
  ),
  (
    'b2222222-2222-2222-2222-222222222222',
    'PRAYAS JEE MAIN & ADVANCED 2027',
    'prayas-jee-2027',
    'Comprehensive conceptual foundation for IIT-JEE aspirants. Deep-dive into problem-solving paradigms, calculus rigor, electrodynamics, and coordination chemistry. Guided by Top 100 AIR producers.',
    'JEE',
    'Class 12 & Repeater',
    ARRAY['Er. Sameer Bansal (Maths)', 'Prof. R.K. Verma (Physics)', 'Dr. N.K. Awasthi (Physical Chem)'],
    'Hinglish',
    4999.00,
    16999.00,
    'https://images.unsplash.com/photo-1509228468518-180dd4864904?w=800&auto=format&fit=crop&q=80',
    ARRAY['Advanced Problem Solving Workshops', 'Peer-to-Peer Doubt Forum', 'JEE Advanced Subjective Paper Practice', 'Free Hardcopy Study Material Delivery'],
    '2026-05-01',
    '2027-06-30',
    true
  ),
  (
    'b3333333-3333-3333-3333-333333333333',
    'TRIUMPH MHT-CET 2026 SPEED CRASH COURSE',
    'triumph-mht-cet-crash-2026',
    'Laser-focused fast-track program targeting 99.5+ Percentile in Maharashtra CET (Engineering & Pharmacy). Shortcuts, State Board textbook line-by-line coverage, and 50 Full CET Pattern Mock Tests.',
    'MHT-CET',
    'Class 12th Boards + CET',
    ARRAY['Prof. Tanmay Patil (CET Special)', 'Prof. Aniket Joshi (Mathematics)'],
    'Marathi + English',
    2199.00,
    7999.00,
    'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800&auto=format&fit=crop&q=80',
    ARRAY['CET Speed Hack Formulas & Tricks', 'Maharashtra State Board Alignment', '150 Speed Mock Tests with Rank Analytics', 'Last 10 Years PYQ Chapterwise Breakdown'],
    '2026-03-20',
    '2026-06-15',
    true
  ),
  (
    'b4444444-4444-4444-4444-444444444444',
    'SANKALP 10TH FOUNDATION (Boards + NTSE / Olympiads)',
    'sankalp-class-10-foundation',
    'Early starter powerhouse batch building unshakeable analytical aptitude for Class 10 Board 98%+ scores, along with NSEJS, PRMO, and early JEE/NEET fundamentals.',
    'Foundation',
    'Class 10',
    ARRAY['Er. Divya Mehta (Science)', 'Prof. Rajesh Kothari (Maths)'],
    'English & Hindi',
    2999.00,
    9999.00,
    'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800&auto=format&fit=crop&q=80',
    ARRAY['CBSE / ICSE Board 100% Exemplar Solutions', 'Mental Ability & Olympiad Level Questions', 'Weekly Parent-Teacher Mentorship Calls', 'Special Practical Science Experiments Virtual Lab'],
    '2026-04-01',
    '2027-03-31',
    true
  )
ON CONFLICT (id) DO NOTHING;

-- 3. Enroll Student in Lakshya NEET 2027
INSERT INTO enrollments (id, student_id, batch_id, payment_status, amount_paid)
VALUES 
  ('e1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 'completed', 4499.00)
ON CONFLICT (id) DO NOTHING;

-- 4. Insert Flagship Lectures
INSERT INTO lectures (id, batch_id, title, subject, chapter_name, lecture_number, video_url, notes_pdf_url, scheduled_at, duration_mins, is_live)
VALUES 
  (
    'l1111111-1111-1111-1111-111111111111',
    'b1111111-1111-1111-1111-111111111111',
    'Physics: Electrostatics 01 - Coulomb’s Law & Continuous Charge Distribution',
    'Physics',
    'Electrostatics',
    1,
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    NOW() - INTERVAL '2 hours',
    95,
    true
  ),
  (
    'l2222222-2222-2222-2222-222222222222',
    'b1111111-1111-1111-1111-111111111111',
    'Chemistry: Chemical Bonding 03 - VSEPR & Hybridization Super Tricks',
    'Chemistry',
    'Chemical Bonding',
    3,
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    NOW() - INTERVAL '1 day',
    85,
    false
  ),
  (
    'l3333333-3333-3333-3333-333333333333',
    'b1111111-1111-1111-1111-111111111111',
    'Biology: Human Physiology - Mechanism of Hormone Action & Second Messengers',
    'Biology',
    'Chemical Coordination',
    2,
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    NOW() + INTERVAL '1 day',
    90,
    false
  )
ON CONFLICT (id) DO NOTHING;

-- 5. Insert Live Chat Messages for Lecture 1
INSERT INTO live_chat_messages (id, lecture_id, user_id, user_name, user_role, message_text, is_pinned)
VALUES
  ('c1111111-1111-1111-1111-111111111111', 'l1111111-1111-1111-1111-111111111111', 'a3333333-3333-3333-3333-333333333333', 'Dr. Sneha Sharma (Teacher)', 'teacher', 'Welcome champions! Keep your NCERT Class 12 Chapter 1 open. We are starting vector form of Coulomb law now!', true),
  ('c2222222-2222-2222-2222-222222222222', 'l1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'Yashraj Rathod', 'student', 'Good evening maam! Audio and 1080p stream are crystal clear!', false),
  ('c3333333-3333-3333-3333-333333333333', 'l1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 'Aman (AIR 482 aspirant)', 'student', 'Maam, when dielectric slab is inserted, why does net electric field decrease by factor K?', false),
  ('c4444444-4444-4444-4444-444444444444', 'l1111111-1111-1111-1111-111111111111', 'a3333333-3333-3333-3333-333333333333', 'Dr. Sneha Sharma (Teacher)', 'teacher', 'Great question Aman! Because the induced polarization bound charges create an internal counter-field E_ind = E0 - E_p = E0/K.', false)
ON CONFLICT (id) DO NOTHING;

-- 6. Insert Mock Test Series
INSERT INTO test_series (id, title, exam_type, duration_minutes, total_marks, positive_marks, negative_marking_ratio, description)
VALUES 
  (
    't1111111-1111-1111-1111-111111111111',
    'EDUSAM All India NEET Mock Grand Test 01',
    'NEET',
    180,
    720,
    4,
    1.00,
    'Authentic NTA computer-based simulation test covering Full Syllabus: Physics (Mechanics & Electrodynamics), Chemistry (Physical & Organic), Biology (Genetics & Physiology). Strictly adheres to +4 / -1 marking scheme.'
  )
ON CONFLICT (id) DO NOTHING;

-- 7. Insert 10 Rigorous Test Questions
INSERT INTO test_questions (id, test_id, subject, chapter, question_text, option_a, option_b, option_c, option_d, correct_option, explanation, ncert_reference, difficulty)
VALUES 
  (
    'q1111111-1111-1111-1111-111111111111',
    't1111111-1111-1111-1111-111111111111',
    'Physics',
    'Electrostatics',
    'Two point charges +q and -q are separated by distance d in vacuum experiencing force F. If placed in a medium of dielectric constant K = 4 at the same distance, what is the new electrostatic force?',
    '4 F',
    'F / 4',
    'F / 2',
    '16 F',
    'B',
    'According to Coulomb’s law in a dielectric medium, F_med = F_vac / K. Given K = 4, the new force F_med = F / 4.',
    'NCERT Class 12 Physics, Part 1, Chapter 1, Page 12, Eq. 1.3',
    'Easy'
  ),
  (
    'q2222222-2222-2222-2222-222222222222',
    't1111111-1111-1111-1111-111111111111',
    'Physics',
    'Motion in a Plane',
    'A projectile is thrown with velocity u at an angle θ with the horizontal. At the highest point of its trajectory, the radius of curvature is:',
    'u² sin²θ / g',
    'u² cos²θ / g',
    'u² / g',
    'u² cosθ / g',
    'B',
    'At the highest point, speed v = u cosθ. The acceleration perpendicular to velocity is a_n = g. Radius of curvature R = v² / a_n = (u cosθ)² / g = u² cos²θ / g.',
    'NCERT Class 11 Physics, Chapter 4 (Motion in a Plane), Section 4.10',
    'Medium'
  ),
  (
    'q3333333-3333-3333-3333-333333333333',
    't1111111-1111-1111-1111-111111111111',
    'Physics',
    'Current Electricity',
    'A wire of resistance R is stretched uniformly such that its length increases by 10%. The percentage increase in its resistance is approximately:',
    '10%',
    '15%',
    '21%',
    '25%',
    'C',
    'Volume remains constant: V = A * L = constant => A is inversely proportional to L. Since R = ρ L / A = ρ L² / V, R ∝ L². If L becomes 1.10 L, R_new = (1.10)² R = 1.21 R. Percentage increase = (1.21 - 1) * 100 = 21%.',
    'NCERT Class 12 Physics, Chapter 3 (Current Electricity), Section 3.5',
    'Medium'
  ),
  (
    'q4444444-4444-4444-4444-444444444444',
    't1111111-1111-1111-1111-111111111111',
    'Chemistry',
    'Chemical Bonding',
    'Using Molecular Orbital Theory (MOT), determine the bond order and magnetic nature of O₂⁺ (dioxygen cation):',
    'Bond Order = 2.5, Paramagnetic',
    'Bond Order = 2.5, Diamagnetic',
    'Bond Order = 2.0, Paramagnetic',
    'Bond Order = 3.0, Diamagnetic',
    'A',
    'O₂ has 16 electrons. O₂⁺ has 15 electrons. Electronic configuration: σ1s² σ*1s² σ2s² σ*2s² σ2pz² (π2px² = π2py²) (π*2px¹ = π*2py⁰). Bonding electrons N_b = 10, Anti-bonding electrons N_a = 5. Bond order = (10 - 5)/2 = 2.5. Since it has 1 unpaired electron in π*2px, it is paramagnetic.',
    'NCERT Class 11 Chemistry, Part 1, Chapter 4, Page 129',
    'Medium'
  ),
  (
    'q5555555-5555-5555-5555-555555555555',
    't1111111-1111-1111-1111-111111111111',
    'Chemistry',
    'Haloalkanes & Haloarenes',
    'In an SN2 substitution reaction on an optically active alkyl halide (e.g., (R)-2-bromooctane with OH⁻), the reaction proceeds with:',
    '100% Retention of configuration',
    '100% Inversion of configuration (Walden Inversion)',
    'Complete Racemization (50% retention, 50% inversion)',
    'Retention or inversion depending on solvent dielectric constant',
    'B',
    'SN2 mechanism involves backside attack by the nucleophile opposite to the leaving group through a pentacoordinate transition state, resulting in complete inversion of stereochemical configuration (Walden inversion).',
    'NCERT Class 12 Chemistry, Chapter 10, Section 10.4',
    'Easy'
  ),
  (
    'q6666666-6666-6666-6666-666666666666',
    't1111111-1111-1111-1111-111111111111',
    'Chemistry',
    'Equilibrium',
    'For the exothermic synthesis of ammonia: N₂(g) + 3H₂(g) ⇌ 2NH₃(g) (ΔH = -92.4 kJ/mol), which set of conditions favors maximum equilibrium yield of NH₃?',
    'High temperature, Low pressure',
    'Low temperature, High pressure',
    'High temperature, High pressure',
    'Low temperature, Low pressure',
    'B',
    'By Le Chatelier’s principle: Forward reaction is exothermic, so lower temperature shifts equilibrium forward. Number of gas moles decreases from 4 (reactants) to 2 (products), so higher pressure shifts equilibrium forward toward fewer moles.',
    'NCERT Class 11 Chemistry, Chapter 7 (Equilibrium), Section 7.11',
    'Easy'
  ),
  (
    'q7777777-7777-7777-7777-777777777777',
    't1111111-1111-1111-1111-111111111111',
    'Biology',
    'Cell Division',
    'During meiotic cell division, crossing over between non-sister chromatids of homologous chromosomes occurs specifically during which sub-stage of Prophase I?',
    'Leptotene',
    'Zygotene',
    'Pachytene',
    'Diplotene',
    'C',
    'In meiotic Prophase I: Zygotene exhibits synapsis (synaptonemal complex). Crossing over mediated by the enzyme recombinase occurs during Pachytene stage where recombination nodules appear.',
    'NCERT Class 11 Biology, Chapter 10 (Cell Cycle and Cell Division), Page 168',
    'Easy'
  ),
  (
    'q8888888-8888-8888-8888-888888888888',
    't1111111-1111-1111-1111-111111111111',
    'Biology',
    'Genetics & Evolution',
    'In a dihybrid cross involving two unlinked heterozygous genes (AaBb x AaBb), what proportion of the F₂ progeny will have the genotype AaBb?',
    '1 / 16',
    '2 / 16',
    '4 / 16 (or 1/4)',
    '9 / 16',
    'C',
    'Probability of Aa from Aa x Aa is 2/4 = 1/2. Probability of Bb from Bb x Bb is 2/4 = 1/2. By product rule for independent assortment: P(AaBb) = (1/2) * (1/2) = 1/4 = 4/16.',
    'NCERT Class 12 Biology, Chapter 5 (Principles of Inheritance and Variation), Page 79',
    'Medium'
  ),
  (
    'q9999999-9999-9999-9999-999999999999',
    't1111111-1111-1111-1111-111111111111',
    'Biology',
    'Excretory Products',
    'In the mammalian counter-current multiplier mechanism of the kidney, the descending limb of the Loop of Henle is permeable to:',
    'Electrolytes only, impermeable to water',
    'Water only, almost impermeable to electrolytes',
    'Both water and electrolytes equally',
    'Urea only, impermeable to water',
    'B',
    'The descending limb of the Loop of Henle is permeable to water but almost impermeable to electrolytes. As filtrate moves down the hypertonic medullary interstitium, water exits by osmosis, concentrating the filtrate up to 1200 mOsmol/L at the hairpin loop.',
    'NCERT Class 11 Biology, Chapter 19 (Excretory Products and Elimination), Section 19.3',
    'Medium'
  ),
  (
    'q0000000-0000-0000-0000-000000000000',
    't1111111-1111-1111-1111-111111111111',
    'Physics',
    'Vectors & Mechanics',
    'If two vectors A and B satisfy |A + B| = |A - B|, what is the angle between vector A and vector B?',
    '0°',
    '45°',
    '90°',
    '180°',
    'C',
    'Squaring both sides: |A + B|² = |A - B|² => A² + B² + 2 A·B = A² + B² - 2 A·B => 4 A·B = 0 => A·B = 0 => |A||B| cosθ = 0. Therefore, cosθ = 0, which gives θ = 90° (the vectors are mutually perpendicular).',
    'NCERT Class 11 Physics, Chapter 4 (Motion in a Plane), Vector Algebra',
    'Easy'
  )
ON CONFLICT (id) DO NOTHING;

-- 8. Insert Demo Leads
INSERT INTO demo_leads (id, student_name, phone_number, target_exam, class_grade, city, status, notes)
VALUES 
  ('d1111111-1111-1111-1111-111111111111', 'Aarav Kulkarni', '+91 9823012345', 'NEET', 'Class 12', 'Pune', 'new', 'Interested in Lakshya NEET 2027 Vidyapeeth hybrid counseling'),
  ('d2222222-2222-2222-2222-222222222222', 'Rohan Mehta', '+91 9765432190', 'JEE', 'Class 11', 'Mumbai', 'contacted', 'Spoke regarding Prayas JEE scholarship entrance test')
ON CONFLICT (id) DO NOTHING;
