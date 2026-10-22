# Task & Routine Planner (Pure Flutter / Dart)

A modern, high-contrast personal task and routine management app built with **Flutter (Dart)** and Material 3 design.

## Features & UI/UX
- **Header**: User Avatar with **"Good Morning AYMANE"**, documentation quick link, and notification bell with active alert indicator.
- **Headline**: **"Let's Make Today Productive"** with a **"Random Task"** bolt action button.
- **Progress Card**: Fresh pastel spring green gradient (`#DCF8A7` → `#CEF193`), `⚡ Daily Sprint` badge, `Your Daily Progress` headline, task counters (*Total Tasks*, *Completed*, *In Progress*), and 102dp circular progress ring with white inner disk.
- **Plans & Tasks Section**: Section header with filter button and 5 status pills (**All**, **To Do**, **In Progress**, **In Review**, **Done**) with live item count badges.
- **Task Cards (`FriendPlansTaskCard`)**: Soft pastel theme cards (Ice Blue, Peach, Mint, Lavender, Crimson, Pink) with duration pill, status pill, tag chips, calendar chip, and **Dynamic Progress Line on every task**.
- **Notifications Dialog**: Paytee-styled card dialog with status bar mock, clean big circular icons (no overlay badges), and strictly **no "Tomorrow" concept**.
- **Schedule & Timeline**: 7-day strip with hourly timeline task flow and dynamic progress bars.
- **Projects & AI Assistant**: Category groupings and AI task assistant with quick prompt chips.

## Project Structure
```
├── pubspec.yaml            # Flutter project dependencies
├── lib/
│   ├── main.dart           # App entry point with tab navigation & modals
│   ├── models/             # TaskModel, NotificationModel, UserProfile
│   ├── state/              # TaskProvider (ChangeNotifier state)
│   ├── theme/              # AppTheme, AppColors, Material 3 tokens
│   ├── widgets/            # TaskCard, CircularProgressRing, BottomNavBar
│   └── screens/            # Home, Schedule, Projects, Chatbot, Profile, Dialogs
├── web/                    # Flutter web runner (index.html, manifest.json)
└── android/                # Android runner & build configuration
```

## Running the App in Antigravity or Local Terminal

### 1. In Antigravity / VS Code / Android Studio
Simply open this root folder directly. Antigravity will automatically recognize it as a Flutter project. Press **Run** or use the debug toolbar.

### 2. Via Terminal
```bash
# Fetch dependencies
flutter pub get

# Run on connected device, emulator, or Chrome web
flutter run
```
