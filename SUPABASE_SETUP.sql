-- ============================================================
-- CED Africa AV Design Studio — Supabase Setup
-- Run this entire script once in Supabase SQL Editor
-- Project: Settings > API to get your URL and anon key
-- ============================================================

-- 1. Create all required tables
CREATE TABLE IF NOT EXISTS ced_settings (
  id TEXT PRIMARY KEY DEFAULT 'singleton',
  data JSONB,
  updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS ced_users (
  id TEXT PRIMARY KEY DEFAULT 'singleton',
  data JSONB,
  updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS ced_quotes (
  id TEXT PRIMARY KEY DEFAULT 'singleton',
  data JSONB,
  updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS ced_specifiers (
  id TEXT PRIMARY KEY DEFAULT 'singleton',
  data JSONB,
  updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS ced_discoveries (
  id TEXT PRIMARY KEY DEFAULT 'singleton',
  data JSONB,
  updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS ced_templates (
  id TEXT PRIMARY KEY DEFAULT 'singleton',
  data JSONB,
  updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS ced_session (
  id TEXT PRIMARY KEY DEFAULT 'singleton',
  data JSONB,
  updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS ced_designs (
  id TEXT PRIMARY KEY DEFAULT 'singleton',
  data JSONB,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Disable Row Level Security (app manages its own auth)
ALTER TABLE ced_settings    DISABLE ROW LEVEL SECURITY;
ALTER TABLE ced_users       DISABLE ROW LEVEL SECURITY;
ALTER TABLE ced_quotes      DISABLE ROW LEVEL SECURITY;
ALTER TABLE ced_specifiers  DISABLE ROW LEVEL SECURITY;
ALTER TABLE ced_discoveries DISABLE ROW LEVEL SECURITY;
ALTER TABLE ced_templates   DISABLE ROW LEVEL SECURITY;
ALTER TABLE ced_session     DISABLE ROW LEVEL SECURITY;
ALTER TABLE ced_designs     DISABLE ROW LEVEL SECURITY;

-- Done. The app will show "☁ LIVE" in the nav when connected.
