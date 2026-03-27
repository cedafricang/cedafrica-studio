# CED Africa AV Design Studio — Deployment Guide

> For the development team deploying to Netlify + Supabase.

---

## Repository Structure

```
/
├── ced_studio_platform.jsx     ← The entire app (single file, React + JSX)
├── index.html                  ← HTML shell (Supabase credentials injected at build)
├── build.sh                    ← Netlify build script
├── netlify.toml                ← Netlify configuration
├── netlify/
│   └── functions/
│       └── send-email.js       ← Serverless email function (Resend API)
└── SUPABASE_SETUP.sql          ← Run once in Supabase SQL Editor
```

---

## Step 1 — GitHub

Push all files to a GitHub repository (public or private).
The folder structure above must be at the **root** of the repo.

---

## Step 2 — Supabase

1. Create a project at [supabase.com](https://supabase.com)
2. Go to **SQL Editor** → New Query → paste `SUPABASE_SETUP.sql` → Run
3. Go to **Project Settings → API** and copy:
   - **Project URL** → `https://xxxx.supabase.co`
   - **anon/public key** → `eyJhbGci...` (long JWT string)

---

## Step 3 — Resend (Email)

1. Create a free account at [resend.com](https://resend.com)
2. Go to **Domains** → Add `cedafrica.com` → verify DNS records (add TXT + MX records your DNS provider)
3. Go to **API Keys** → Create Key → copy it

---

## Step 4 — Netlify

1. Go to [netlify.com](https://netlify.com) → **Add new site → Import from Git**
2. Connect the GitHub repo
3. Build settings are auto-detected from `netlify.toml`:
   - Build command: `bash build.sh`
   - Publish directory: `_site`
4. Go to **Site configuration → Environment variables** → Add all three:

| Key | Value |
|-----|-------|
| `SUPABASE_URL` | `https://xxxx.supabase.co` |
| `SUPABASE_KEY` | `eyJhbGci...` (anon key) |
| `RESEND_API_KEY` | `re_xxxxxxxxxxxx` |

5. **Deploy site** (or trigger redeploy if already deployed)

---

## Step 5 — Verify

Open the deployed URL. The nav bar should show:

- **☁ LIVE** (green) — Supabase connected, data is shared across all users ✓
- **⚠ LOCAL** (amber) — Not connected, check env vars and redeploy

---

## First Login

Default credentials (change immediately after first login):

| Field | Value |
|-------|-------|
| Email | `lead@cedafrica.com` (created on first load) |
| Password | `CED@2025` |
| Admin panel password | `ADMIN@CED` |
| Recovery code | `CEDRECOVER` |

**On first login:**
1. Change your password (you will be prompted)
2. Go to Admin Panel → Security → change the Admin Panel password and Recovery Code
3. Go to Admin Panel → Users → create accounts for each team member

---

## How It Works

- **Storage:** All data (quotes, users, settings, discoveries) is stored in Supabase as JSON in 8 tables. Every write is shared across all users in real time.
- **Auth:** App-level authentication (not Supabase Auth). Users and hashed passwords are stored in `ced_users`.
- **Email:** Automatic delivery via Resend API on Netlify. Falls back to `mailto:` (opens local mail client) in development.
- **No build step:** The app is a single JSX file transpiled in the browser by Babel standalone. No webpack, no bundler, no `npm install` needed.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| ⚠ LOCAL after deploy | Check all 3 env vars are set, trigger redeploy |
| ☁ LIVE but data lost on refresh | RLS still enabled — re-run `SUPABASE_SETUP.sql` |
| Users can't log in from other browsers | Same as above — data is in localStorage not Supabase |
| Email not sending | Check `RESEND_API_KEY` is set; verify domain in Resend dashboard |
| Blank white screen | Check browser console for errors; clear browser cache |

---

## Support

Platform built by Claude (Anthropic) for CED Africa.
Technical queries: check browser DevTools console for error messages.
