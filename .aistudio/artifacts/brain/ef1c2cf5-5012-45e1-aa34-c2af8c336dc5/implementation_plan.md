# Pure Flutter Conversion & Clean Packaging Plan

A comprehensive plan to structure the project at root as a pure Flutter/Dart application with complete platform runner configurations, matching the exact UI/UX shown in the live preview for seamless execution in Antigravity.

---

## User Review & Critical Decisions

> [!IMPORTANT]
> **Confirmed Choices from Clarification**:
> - **Packaging Choice**: Replace the root project with the pure Flutter codebase so that opening the downloaded ZIP in Antigravity directly runs Flutter (`flutter run`) without navigating into subfolders.
> - **Platform Runners**: Include standard platform runner configurations (`android/`, `ios/`, `web/`) so Antigravity and local tooling can build and run on any target out-of-the-box.
>
> [!NOTE]
> **Cloud Emulator Bridge Preservation**:
> In AI Studio, the streaming browser emulator relies on the Gradle build toolchain located in the project. Flutter's standard `android/` runner directory contains Gradle build files. We configure the standard Flutter `android/` runner so that:
> 1. In Antigravity / local machine: It runs purely as a Flutter app (`flutter run`).
> 2. In AI Studio: The streaming browser preview continues to build and run seamlessly.

---

## 1. Overview & Core Concept

- **Goal**: Provide a clean, unified Flutter/Dart codebase at the root level that contains zero deprecated or outdated designs, completely eliminating confusion between the Android template and the modern Flutter app.
- **Target Environment**: Local Antigravity IDE, Flutter CLI, VS Code, Android Studio, and the AI Studio live preview emulator.
- **Key Experience**: A personal task and routine management app with real-time dynamic task progress tracking, customizable color themes, Paytee-styled notifications without outdated concepts, and high-contrast typography personalized for **AYMANE**.

---

## 2. User Experience & Visual Design

The UI will replicate the design currently verified in the preview:

- **Header Bar**:
  - 46dp circular user avatar with initials `AD`.
  - Subtitle `"Good Morning"` in subtle gray and headline **`"AYMANE"`** in bold primary charcoal.
  - Black circular documentation shortcut button.
  - Frosted white circular notification bell with a red indicator dot.
- **Headline & Quick Action**:
  - Bold headline: **`"Let's Make\nToday Productive"`** (28sp bold).
  - Quick action **`"Random Task"`** button with blue ⚡ bolt icon in a crisp rounded container.
- **Pastel Spring Green Progress Card**:
  - Gradient background (`#DCF8A7` to `#CEF193`) with 26dp rounded corners and soft glow shadow.
  - Top mini pill badge: `⚡ Daily Sprint`.
  - Bold title: **`"Your Daily Progress"`**.
  - Three live metrics: *Total Tasks*, *Completed*, and *In Progress*.
  - Right-aligned 102dp circular progress ring with inner white disk, bold completion percentage, and ratio.
- **Plans & Tasks Section**:
  - Section header **`"Plans & Tasks"`** with square filter button.
  - Horizontal status filter pills: **`All`**, **`To Do`**, **`In Progress`**, **`In Review`**, and **`Done`**, with real-time count badges.
- **Task Cards (`FriendPlansTaskCard`)**:
  - Soft pastel themed cards matching task category (Soft Ice Blue, Warm Peach, Mint, Lavender, Crimson Red, Honey Yellow, Pink).
  - Top-left clean duration pill (e.g., `2h`, `1h 30m` with schedule icon).
  - Top-right status pill (`In Progress`, `Locked In`, `Completed`) + star toggle.
  - 20sp ExtraBold title and subtle description.
  - Category tags, calendar date chip, and project chip.
  - **Dynamic Progress Line on every single task**: Animated progress bar with live percentage and status (`65% ACTIVE NOW`, `100% DONE`, `20% SCHEDULED`).
  - Bottom row with time range and friend avatar stack.
- **Notifications Dialog**:
  - Paytee reference design: Status bar mock (`9:41`, signal, wifi, battery).
  - White container card with 28dp rounded corners.
  - Sections: *Today*, *This Week*, *Security* (**Strictly zero "Tomorrow" mentions**).
  - Clean big circular icons (44dp) with **no overlay badge icons**.
  - Action buttons: *Mark all read* and *Clear all*.

---

## 3. Key Technical Decisions & Project Structure

- **Decision 1: Promote Flutter to Root**:
  - Move `pubspec.yaml`, `lib/` (models, state, theme, widgets, screens), and platform runners directly to the project root.
  - Clean up redundant standalone duplicate folders to ensure the root directory is a standard Flutter app.
- **Decision 2: Standard Platform Runners**:
  - Generate standard `web/index.html` and runner configurations.
  - Configure standard Flutter `android/` runner with compatible Gradle plugins so Antigravity detects an authentic Flutter project while AI Studio's preview builder compiles without error.
- **Decision 3: Single Source of Truth**:
  - Ensure all models, screens, and state managers in `lib/` are fully typed Dart code using Flutter Material 3.

---

## 4. Technical Architecture & Component Mapping

```
┌────────────────────────────────────────────────────────────────────────┐
│                        Flutter App (main.dart)                         │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                         ┌──────────▼──────────┐
                         │    TaskProvider     │
                         │  (ChangeNotifier)   │
                         └──────────┬──────────┘
                                    │
       ┌────────────────────────────┼───────────────────────────┐
       │                            │                           │
┌──────▼──────┐             ┌───────▼───────┐           ┌───────▼───────┐
│ HomeScreen  │             │ScheduleScreen │           │ProjectsScreen │
│ (Spring     │             │(Timeline with │           │(Initiatives & │
│  Green Card,│             │ Dynamic Lines)│           │ Category Hub) │
│  AYMANE)    │             └───────────────┘           └───────────────┘
└──────┬──────┘
       │
┌──────▼────────────────────────────────────────────────────────────────┐
│ TaskCard (FriendPlansTaskCard design with Dynamic Progress on every)   │
└───────────────────────────────────────────────────────────────────────┘
```

### Proposed Directory Layout
```
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── models/
│   │   ├── task_model.dart
│   │   ├── notification_model.dart
│   │   └── user_profile_model.dart
│   ├── state/
│   │   └── task_provider.dart
│   ├── widgets/
│   │   ├── bottom_nav_bar.dart
│   │   ├── task_card.dart
│   │   └── circular_progress_ring.dart
│   └── screens/
│       ├── home_screen.dart
│       ├── schedule_screen.dart
│       ├── projects_screen.dart
│       ├── chatbot_screen.dart
│       ├── profile_screen.dart
│       ├── notifications_dialog.dart
│       ├── add_task_dialog.dart
│       ├── task_detail_dialog.dart
│       ├── routine_manager_dialog.dart
│       └── design_sandbox_screen.dart
├── web/
│   ├── index.html
│   └── manifest.json
└── android/
    ├── build.gradle.kts
    ├── settings.gradle.kts
    └── app/
```
