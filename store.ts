import { 
  UserProfile, 
  CourseBatch, 
  Enrollment, 
  Lecture, 
  LiveChatMessage, 
  TestSeries, 
  TestQuestion, 
  StudentTestAttempt, 
  DemoLead, 
  UserRole,
  ExamCategory 
} from './types';
import { 
  INITIAL_USER, 
  INITIAL_BATCHES, 
  INITIAL_LECTURES, 
  INITIAL_CHAT_MESSAGES, 
  INITIAL_TEST_SERIES, 
  INITIAL_QUESTIONS, 
  INITIAL_LEADS,
  INITIAL_ATTEMPTS
} from './mockData';
import { getSupabase } from './supabase';

const STORAGE_KEYS = {
  USER: 'edusam_user_v1',
  BATCHES: 'edusam_batches_v1',
  ENROLLMENTS: 'edusam_enrollments_v1',
  LECTURES: 'edusam_lectures_v4',
  CHAT: 'edusam_chat_v1',
  TESTS: 'edusam_tests_v1',
  ATTEMPTS: 'edusam_attempts_v1',
  LEADS: 'edusam_leads_v1',
};

// Custom event emitter for real-time local sync across tabs/components
class LocalEventEmitter {
  private listeners: Record<string, Set<(data: any) => void>> = {};

  on(event: string, callback: (data: any) => void) {
    if (!this.listeners[event]) {
      this.listeners[event] = new Set();
    }
    this.listeners[event].add(callback);
    return () => {
      this.listeners[event].delete(callback);
    };
  }

  emit(event: string, data: any) {
    if (this.listeners[event]) {
      this.listeners[event].forEach((cb) => cb(data));
    }
  }
}

export const realtimeEmitter = new LocalEventEmitter();

function safeGet<T>(key: string, defaultValue: T): T {
  if (typeof window === 'undefined') return defaultValue;
  try {
    const item = localStorage.getItem(key);
    return item ? JSON.parse(item) : defaultValue;
  } catch {
    return defaultValue;
  }
}

function safeSet<T>(key: string, value: T): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(key, JSON.stringify(value));
  } catch (err) {
    console.error('LocalStorage write error', err);
  }
}

// Global EDUSAM Data Access Store
export const edusamStore = {
  // ---------------- USER / AUTH ----------------
  getUser(): UserProfile {
    return safeGet<UserProfile>(STORAGE_KEYS.USER, INITIAL_USER);
  },

  setUser(user: UserProfile) {
    safeSet(STORAGE_KEYS.USER, user);
    realtimeEmitter.emit('user_changed', user);
  },

  switchRole(role: UserRole) {
    const user = this.getUser();
    const updated = { ...user, role };
    this.setUser(updated);
    return updated;
  },

  setTargetExam(exam: ExamCategory) {
    const user = this.getUser();
    const updated = { ...user, target_exam: exam };
    this.setUser(updated);
    return updated;
  },

  // ---------------- BATCHES ----------------
  getBatches(): CourseBatch[] {
    return safeGet<CourseBatch[]>(STORAGE_KEYS.BATCHES, INITIAL_BATCHES);
  },

  getBatchBySlug(slug: string): CourseBatch | undefined {
    return this.getBatches().find((b) => b.slug === slug);
  },

  getBatchById(id: string): CourseBatch | undefined {
    return this.getBatches().find((b) => b.id === id);
  },

  // ---------------- ENROLLMENTS ----------------
  getEnrollments(): Enrollment[] {
    const defEnrollments: Enrollment[] = [
      {
        id: 'e1111111-1111-1111-1111-111111111111',
        student_id: INITIAL_USER.id,
        batch_id: 'b1111111-1111-1111-1111-111111111111',
        payment_status: 'completed',
        transaction_id: 'PAY_MOCK_SUCCESS_78912',
        amount_paid: 4499,
        created_at: new Date(Date.now() - 1000 * 60 * 60 * 48).toISOString(),
      },
    ];
    const enrollments = safeGet<Enrollment[]>(STORAGE_KEYS.ENROLLMENTS, defEnrollments);
    const batches = this.getBatches();
    return enrollments.map(e => ({
      ...e,
      batch: batches.find(b => b.id === e.batch_id)
    }));
  },

  isEnrolled(batchId: string): boolean {
    const user = this.getUser();
    return this.getEnrollments().some((e) => e.student_id === user.id && e.batch_id === batchId);
  },

  async enroll(batchId: string, amount: number): Promise<Enrollment> {
    const user = this.getUser();
    const newEnrollment: Enrollment = {
      id: 'enr_' + Math.random().toString(36).substring(2, 10),
      student_id: user.id,
      batch_id: batchId,
      payment_status: 'completed',
      transaction_id: 'TXN_' + Math.floor(10000000 + Math.random() * 90000000),
      amount_paid: amount,
      created_at: new Date().toISOString(),
    };

    // If Supabase is connected, try to insert
    const supabase = getSupabase();
    if (supabase) {
      try {
        await supabase.from('enrollments').insert([newEnrollment]);
      } catch (e) {
        console.warn('Supabase enroll sync skipped, fallback to local', e);
      }
    }

    const current = this.getEnrollments();
    const updated = [newEnrollment, ...current];
    safeSet(STORAGE_KEYS.ENROLLMENTS, updated);
    realtimeEmitter.emit('enrollments_changed', updated);
    return newEnrollment;
  },

  // ---------------- LECTURES ----------------
  getLectures(batchId?: string): Lecture[] {
    const all = safeGet<Lecture[]>(STORAGE_KEYS.LECTURES, INITIAL_LECTURES);
    const sanitized = all.map((l) => {
      if (l.id === 'l3333333-3333-3333-3333-333333333333' && (!l.video_url || l.video_url.includes('RGbX_6QjH_c'))) {
        return { ...l, video_url: 'https://www.youtube.com/watch?v=eWHH9je2zG4' };
      }
      if (l.id === 'l1111111-1111-1111-1111-111111111111' && (!l.video_url || l.video_url.includes('flower.mp4') || l.video_url.includes('bHIhgxav9LY'))) {
        return { ...l, video_url: 'https://www.youtube.com/watch?v=mdulzEfQXDE' };
      }
      return l;
    });
    if (!batchId) return sanitized;
    return sanitized.filter((l) => l.batch_id === batchId);
  },

  getLectureById(lectureId: string): Lecture | undefined {
    return this.getLectures().find((l) => l.id === lectureId);
  },

  // ---------------- LIVE CHAT (WEBSOCKETS / REALTIME) ----------------
  getChatMessages(lectureId: string): LiveChatMessage[] {
    const all = safeGet<LiveChatMessage[]>(STORAGE_KEYS.CHAT, INITIAL_CHAT_MESSAGES);
    return all.filter((m) => m.lecture_id === lectureId);
  },

  async sendChatMessage(lectureId: string, messageText: string): Promise<LiveChatMessage> {
    const user = this.getUser();
    const newMsg: LiveChatMessage = {
      id: 'chat_' + Math.random().toString(36).substring(2, 11),
      lecture_id: lectureId,
      user_id: user.id,
      user_name: user.full_name,
      user_role: user.role,
      message_text: messageText.trim(),
      created_at: new Date().toISOString(),
    };

    // Supabase Realtime broadcast if enabled
    const supabase = getSupabase();
    if (supabase) {
      try {
        await supabase.from('live_chat_messages').insert([newMsg]);
      } catch (err) {
        console.warn('Supabase chat write fallback to local', err);
      }
    }

    const all = safeGet<LiveChatMessage[]>(STORAGE_KEYS.CHAT, INITIAL_CHAT_MESSAGES);
    const updated = [...all, newMsg];
    safeSet(STORAGE_KEYS.CHAT, updated);
    realtimeEmitter.emit(`chat_${lectureId}`, newMsg);

    // Mock teacher response after 2.5 seconds for engaging live demo
    if (user.role === 'student' && messageText.includes('?')) {
      setTimeout(() => {
        const teacherReplies = [
          "Noted! Let's write the formula on the digital whiteboard right now.",
          "Exactly! Keep in mind the boundary condition from NCERT section 2.4.",
          "Good doubt! Notice how the polarity cancels the tangential component of E.",
          "Remember this concept—it appeared in NEET 2023 with direct numerical values!"
        ];
        const teacherMsg: LiveChatMessage = {
          id: 'chat_teacher_' + Math.random().toString(36).substring(2, 10),
          lecture_id: lectureId,
          user_id: 'a3333333-3333-3333-3333-333333333333',
          user_name: 'Dr. Sneha Sharma (Teacher)',
          user_role: 'teacher',
          message_text: teacherReplies[Math.floor(Math.random() * teacherReplies.length)],
          created_at: new Date().toISOString(),
        };
        const currentMsgs = safeGet<LiveChatMessage[]>(STORAGE_KEYS.CHAT, INITIAL_CHAT_MESSAGES);
        safeSet(STORAGE_KEYS.CHAT, [...currentMsgs, teacherMsg]);
        realtimeEmitter.emit(`chat_${lectureId}`, teacherMsg);
      }, 2500);
    }

    return newMsg;
  },

  subscribeToLiveChat(lectureId: string, onMessage: (msg: LiveChatMessage) => void) {
    const supabase = getSupabase();
    let supabaseChannel: any = null;

    if (supabase) {
      supabaseChannel = supabase
        .channel(`public:live_chat_messages:lecture_id=eq.${lectureId}`)
        .on(
          'postgres_changes',
          {
            event: 'INSERT',
            schema: 'public',
            table: 'live_chat_messages',
            filter: `lecture_id=eq.${lectureId}`,
          },
          (payload) => {
            onMessage(payload.new as LiveChatMessage);
          }
        )
        .subscribe();
    }

    const unsubscribeLocal = realtimeEmitter.on(`chat_${lectureId}`, onMessage);

    return () => {
      unsubscribeLocal();
      if (supabaseChannel && supabase) {
        supabase.removeChannel(supabaseChannel);
      }
    };
  },

  // ---------------- TEST SERIES & QUESTIONS ----------------
  getTestSeries(): TestSeries {
    return safeGet<TestSeries>(STORAGE_KEYS.TESTS, INITIAL_TEST_SERIES);
  },

  getTestQuestions(testId?: string): TestQuestion[] {
    return INITIAL_QUESTIONS;
  },

  // ---------------- TEST ATTEMPTS ----------------
  getTestAttempts(): StudentTestAttempt[] {
    return safeGet<StudentTestAttempt[]>(STORAGE_KEYS.ATTEMPTS, INITIAL_ATTEMPTS);
  },

  getAttemptById(attemptId: string): StudentTestAttempt | undefined {
    return this.getTestAttempts().find((a) => a.id === attemptId);
  },

  async submitTestAttempt(attempt: Omit<StudentTestAttempt, 'id' | 'completed_at'>): Promise<StudentTestAttempt> {
    const fullAttempt: StudentTestAttempt = {
      ...attempt,
      id: 'att_' + Math.random().toString(36).substring(2, 10),
      completed_at: new Date().toISOString(),
    };

    const supabase = getSupabase();
    if (supabase) {
      try {
        await supabase.from('student_test_attempts').insert([fullAttempt]);
      } catch (err) {
        console.warn('Supabase test attempt submit fallback to local', err);
      }
    }

    const existing = this.getTestAttempts();
    const updated = [fullAttempt, ...existing];
    safeSet(STORAGE_KEYS.ATTEMPTS, updated);
    realtimeEmitter.emit('attempts_changed', updated);
    return fullAttempt;
  },

  // ---------------- DEMO LEADS ----------------
  getDemoLeads(): DemoLead[] {
    return safeGet<DemoLead[]>(STORAGE_KEYS.LEADS, INITIAL_LEADS);
  },

  async submitDemoLead(lead: Omit<DemoLead, 'id' | 'status' | 'created_at'>): Promise<DemoLead> {
    const newLead: DemoLead = {
      ...lead,
      id: 'lead_' + Math.random().toString(36).substring(2, 10),
      status: 'new',
      created_at: new Date().toISOString(),
    };

    const supabase = getSupabase();
    if (supabase) {
      try {
        await supabase.from('demo_leads').insert([newLead]);
      } catch (e) {
        console.warn('Supabase lead write fallback to local', e);
      }
    }

    const existing = this.getDemoLeads();
    const updated = [newLead, ...existing];
    safeSet(STORAGE_KEYS.LEADS, updated);
    realtimeEmitter.emit('leads_changed', updated);
    return newLead;
  },
};
