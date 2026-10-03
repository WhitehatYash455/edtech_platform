export type UserRole = 'student' | 'admin' | 'teacher';
export type ExamCategory = 'NEET' | 'JEE' | 'MHT-CET' | 'Boards' | 'Foundation';

export interface UserProfile {
  id: string;
  email: string;
  full_name: string;
  phone?: string;
  role: UserRole;
  target_exam: ExamCategory;
  avatar_url?: string;
  created_at?: string;
}

export interface CourseBatch {
  id: string;
  title: string;
  slug: string;
  description: string;
  exam_category: ExamCategory;
  class_grade: string;
  faculty_names: string[];
  language: string;
  price_inr: number;
  original_price_inr: number;
  banner_url: string;
  features: string[];
  start_date: string;
  validity_date: string;
  is_published: boolean;
  enrolled_count?: number;
}

export interface Enrollment {
  id: string;
  student_id: string;
  batch_id: string;
  payment_status: 'completed' | 'pending' | 'failed';
  transaction_id?: string;
  amount_paid: number;
  created_at: string;
  batch?: CourseBatch;
}

export interface Lecture {
  id: string;
  batch_id: string;
  title: string;
  subject: 'Physics' | 'Chemistry' | 'Biology' | 'Maths';
  chapter_name: string;
  lecture_number: number;
  video_url: string;
  notes_pdf_url?: string;
  dpp_quiz_id?: string;
  scheduled_at: string;
  duration_mins: number;
  is_live: boolean;
}

export interface LiveChatMessage {
  id: string;
  lecture_id: string;
  user_id: string;
  user_name: string;
  user_role: UserRole;
  message_text: string;
  is_pinned?: boolean;
  created_at: string;
}

export interface TestSeries {
  id: string;
  title: string;
  exam_type: ExamCategory;
  duration_minutes: number;
  total_marks: number;
  positive_marks: number;
  negative_marking_ratio: number;
  description: string;
  questions_count?: number;
}

export interface TestQuestion {
  id: string;
  test_id: string;
  subject: 'Physics' | 'Chemistry' | 'Maths' | 'Biology';
  chapter: string;
  question_text: string;
  question_image_url?: string;
  option_a: string;
  option_b: string;
  option_c: string;
  option_d: string;
  correct_option: 'A' | 'B' | 'C' | 'D';
  explanation: string;
  ncert_reference?: string;
  difficulty: 'Easy' | 'Medium' | 'Hard';
}

export interface QuestionResponse {
  question_id: string;
  selected_option: 'A' | 'B' | 'C' | 'D' | null;
  status: 'answered' | 'unanswered' | 'marked' | 'marked_answered' | 'not_visited';
  time_spent_seconds: number;
}

export interface StudentTestAttempt {
  id: string;
  student_id: string;
  test_id: string;
  test_title?: string;
  exam_type?: ExamCategory;
  total_score: number;
  max_marks: number;
  total_correct: number;
  total_incorrect: number;
  total_unattempted: number;
  accuracy_percentage: number;
  time_taken_seconds: number;
  predicted_air: number;
  answers_json: Record<string, {
    selected: 'A' | 'B' | 'C' | 'D' | null;
    is_correct: boolean;
    correct_option: 'A' | 'B' | 'C' | 'D';
    time_spent: number;
    subject: string;
    chapter: string;
    question_id?: string;
    question_text?: string;
    explanation?: string;
    ncert_reference?: string;
  }>;
  completed_at: string;
}

export interface DemoLead {
  id: string;
  student_name: string;
  phone_number: string;
  target_exam: string;
  class_grade: string;
  city: string;
  status: 'new' | 'contacted' | 'converted' | 'closed';
  notes?: string;
  created_at: string;
}

export interface DPPItem {
  id: string;
  question: string;
  options: string[];
  correctIndex: number;
  explanation: string;
}
