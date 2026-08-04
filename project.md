```markdown
# Flutter Project Prompt – Minimal Relationship Counter App

## Project Overview

Build a **minimalist Flutter application** for Android that tracks the number of days I've been together with my girlfriend.

This project is for **personal use only** and will **not be published to the Google Play Store**.

The design philosophy should be:

- Clean
- Minimal
- Modern
- Lightweight
- No unnecessary features
- Smooth animations
- Offline-first

The inspiration is the **Been Together** app, but I only want the features that I actually use.

---

# Tech Stack

- Flutter (latest stable)
- Dart
- Material 3
- Local storage (Hive or SharedPreferences)
- flutter_local_notifications
- timezone package (for accurate reminder scheduling)
- intl package
- go_router (optional)
- Provider/Riverpod (simple state management)
- Dynamic Color support (Material You)

---

# Main Features

## 1. Relationship Day Counter

Display the number of days we've been together.

Example

```

❤️ Together for

1,245 Days

```

Also display

- Start Date
- Today's Date

Example

```

Since
January 14, 2023

```

---

## 2. Anniversary Counter

Show useful milestones.

Examples

```

100 Days
200 Days
300 Days
500 Days
1000 Days
1500 Days
2000 Days

```

Completed milestones should appear differently from upcoming milestones.

---

## 3. Daily Reminder

This is the most important feature.

Allow setting a reminder every day.

Example

```

9:00 PM

❤️ Don't forget to say good night.

```

or

```

❤️ Today you've been together for 1,245 days.

```

Requirements

- User can enable/disable reminder
- Choose reminder time
- Edit reminder message
- Notification works offline
- Notification survives device reboot if possible

---

## 4. Home Screen

Very simple layout.

```

❤️

1,245

Days Together

Since
January 14, 2023

Next Milestone
❤️ 1,300 Days
55 days left

---

Reminder
9:00 PM
Enabled

```

Everything centered.

Large typography.

Lots of white space.

---

## 5. Edit Relationship Date

Allow changing

- Anniversary date
- Partner name (optional)

---

## 6. Dark Mode

Support

- Light
- Dark
- System

Automatically adapt colors.

---

## 7. Minimal Settings

Only include:

- Anniversary date
- Reminder time
- Reminder on/off
- Reminder message
- Theme

Nothing else.

---

# Nice Animations

Use subtle animations only.

Examples

- Counter fades in
- Card slides up
- Button ripple
- Animated number transition

Avoid flashy effects.

---

# UI Style

Use Material 3.

Design principles

- Rounded corners
- Soft shadows
- Large typography
- Comfortable spacing
- Minimal colors
- One accent color (Pink or Red)
- Elegant icons

No clutter.

---

# Color Palette

Example

Primary

```

#E91E63

```

Background

```

White

```

Dark Background

```

#121212

````

Text

Material 3 defaults.

---

# Data Model

```dart
RelationshipSettings {
  DateTime startDate;
  String partnerName;
  bool reminderEnabled;
  TimeOfDay reminderTime;
  String reminderMessage;
  ThemeMode themeMode;
}
````

---

# App Structure

```
lib/
    main.dart

    core/
        theme/
        utils/

    models/
        relationship_settings.dart

    services/
        notification_service.dart
        storage_service.dart

    screens/
        home/
        settings/

    widgets/
        day_counter.dart
        milestone_card.dart
        reminder_card.dart

    providers/
```

---

# Calculations

Automatically calculate

* Days together
* Months together
* Years together
* Next milestone
* Remaining days until next milestone

---

# Reminder Examples

```
❤️ You've been together for 1,245 days.

❤️ Give her a hug today.

❤️ Time to send a sweet message.

❤️ Don't forget to say good night.

❤️ Another beautiful day together.
```

---

# Performance Goals

* Fast startup
* Small APK size
* Smooth 60 FPS animations
* Offline-first
* Minimal battery usage

---

# Future Features (Optional)

These should be designed so they can be added later without major refactoring:

* Widget for Home Screen
* Backup & Restore
* Multiple reminder templates
* Anniversary countdown
* Photo background
* Custom themes

Do **not** implement these yet.

---

# Coding Guidelines

* Follow clean architecture principles where appropriate, but avoid over-engineering.
* Write readable, maintainable, and well-documented code.
* Keep widgets small and reusable.
* Separate UI, business logic, and services.
* Use meaningful class and variable names.
* Prefer composition over inheritance.
* Handle edge cases (invalid dates, notification permissions, timezone changes).

---

# Deliverables

1. Fully functional Flutter Android app.
2. Clean and organized project structure.
3. Offline local data persistence.
4. Daily local notification reminders.
5. Responsive Material 3 UI.
6. Easy-to-maintain codebase with comments where necessary.

---

# Goal

Create a beautiful, minimalist relationship day counter app focused on what matters most:

* ❤️ Counting the days we've been together
* 🔔 Daily reminder notifications

The app should feel calm, elegant, fast, and distraction-free, providing a delightful experience every time it's opened.

```
```
