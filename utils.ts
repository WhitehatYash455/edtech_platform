import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function formatINR(amount: number): string {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    maximumFractionDigits: 0,
  }).format(amount);
}

export function formatDuration(seconds: number): string {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}m ${s < 10 ? '0' : ''}${s}s`;
}

export function formatClockTimer(totalSeconds: number): string {
  const h = Math.floor(totalSeconds / 3600);
  const m = Math.floor((totalSeconds % 3600) / 60);
  const s = totalSeconds % 60;
  return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
}

export function calculatePredictedAIR(score: number, maxMarks: number, examType: string = 'NEET'): number {
  const pct = Math.max(0, Math.min(100, (score / maxMarks) * 100));
  if (examType === 'NEET') {
    if (pct >= 95) return Math.floor(1 + Math.random() * 50);
    if (pct >= 90) return Math.floor(51 + Math.random() * 250);
    if (pct >= 80) return Math.floor(301 + Math.random() * 1200);
    if (pct >= 70) return Math.floor(1500 + Math.random() * 4000);
    if (pct >= 60) return Math.floor(5500 + Math.random() * 12000);
    return Math.floor(18000 + Math.random() * 40000);
  }
  // JEE / CET
  if (pct >= 90) return Math.floor(10 + Math.random() * 200);
  if (pct >= 75) return Math.floor(201 + Math.random() * 1500);
  return Math.floor(2000 + Math.random() * 20000);
}
