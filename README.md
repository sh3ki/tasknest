# TaskNest

> A native Android task manager with smart scheduling, recurring tasks, and team workspaces.

---

## Overview

TaskNest is a Kotlin-native Android task management app supporting personal to-dos and shared team workspaces. Users create tasks with due dates, priorities, subtasks, and labels; set flexible recurrence rules; and get reminded by the system at the right time — even when the app is closed. Teams share workspace boards with real-time collaborative updates.

---

## Problem

Lightweight to-do apps don't scale to team use. Project management tools are too heavyweight for personal use. Users need a single app that handles both a personal inbox and lightweight team task boards without requiring a subscription for core features.

---

## Solution

TaskNest separates personal tasks from workspace boards within one app. Personal tasks are local-first in Room; workspace tasks sync and collaborate via Supabase in real time. WorkManager handles reliable reminder scheduling across all Android power management regimes.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Kotlin |
| UI | Jetpack Compose + Material 3 |
| Architecture | Clean Architecture (MVVM + UseCases + Repository) |
| DI | Hilt |
| Local DB | Room (SQLite) |
| Preferences | DataStore (Proto) |
| Background Jobs | WorkManager |
| Auth | Supabase Auth (email + Google OAuth) |
| Sync | Supabase PostgreSQL + Realtime |
| Async | Kotlin Coroutines + Flow |
| Navigation | Compose Navigation |

---

## Features

**Core**
- Create tasks with title, description, due date/time, priority (P1–P4), and labels
- Subtask checklist within a task with independent completion tracking
- Flexible recurrence rules: daily, weekly (specific days), monthly (specific date), or custom interval
- Multiple list views: Today, Upcoming, By Project, All Tasks, Completed Archive
- Bulk actions: complete, reschedule, assign label, or delete selected tasks
- Personal inbox for quick-capture tasks without a due date

**Backend & Infrastructure**
- Supabase Auth with email/password and Google OAuth; access tokens stored securely in DataStore, not SharedPreferences
- Room as local store for personal tasks: `tasks`, `subtasks`, `labels`, `task_labels` tables — all operations on personal tasks are fully offline
- WorkManager `ReminderWorker`: scheduled at exact task due time using `setExactAndAllowWhileIdle`; re-enqueued after device reboot via `BootBroadcastReceiver`
- WorkManager `RecurrenceWorker`: runs after a recurring task is completed, computes next due date using the recurrence rule, creates the next task instance in Room
- Supabase PostgreSQL tables: `workspaces`, `workspace_members`, `workspace_tasks`, `workspace_subtasks` — all scoped with Row Level Security based on workspace membership
- Supabase Realtime subscription on `workspace_tasks` — changes made by any team member appear instantly for all active members without polling
- Supabase Auth used for workspace invite flow: invite by email generates a Supabase Auth invite link; recipient joins workspace on account creation
- DataStore stores user preferences: default list view, reminder sound, theme, last selected workspace

**Workspaces & Collaboration**
- Create or join team workspaces with a unique invite link or email invite
- Board view and list view switchable per workspace
- Assign workspace tasks to members; assignee sees tasks in their personal Today/Upcoming views
- Comment thread per workspace task with real-time updates via Supabase Realtime
- Activity log per workspace: task created, completed, reassigned, commented — with actor and timestamp

**Notifications**
- WorkManager `ExactAlarmCompat` reminder built with `AlarmManager.setAlarmClock` for Android 12+ exact alarm permission
- Notification channels: Task Reminders, Workspace Activity, Daily Digest
- Daily digest: WorkManager periodic task at 8 AM — queries today's tasks and posts a summary notification
- Workspace activity notification: FCM (via Supabase webhooks to a Deno Edge Function sending FCM) for mentions and assignments

**Offline**
- Personal tasks: fully offline, no connectivity needed
- Workspace tasks: Supabase offline write queue — changes made offline are flushed on reconnect
- Supabase Realtime auto-reconnect with exponential backoff handled by the Supabase Kotlin client

---

## Challenges

- Ensuring WorkManager exact alarm reminders survive OEM-specific battery optimizations (Huawei, Xiaomi, Samsung) without requesting unrestricted battery access
- Merging offline-queued workspace task updates with real-time Supabase changes without creating duplicates
- Implementing a flexible recurrence engine in pure Kotlin that matches iCalendar RRULE semantics

---

## Screenshots

_Today View · Task Detail · Workspace Board · Reminders_
