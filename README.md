# kevit_prac

# 📸 Kevit Practical - A Flutter Instagram-Style Social App

Kevit Practical is a lightweight Instagram-style social media mobile app built using **Flutter**
and *
*Riverpod**, featuring offline storage using **Hive**. It allows users to create image posts, like
and comment, and view a paginated feed — all in a sleek, modern UI.

---

## 🔍 App Overview

This app enables users to:

- Log in with a username
- Post images with captions
- View a feed of all posts (paginated)
- Like, comment, and download posts
- Use the app even offline thanks to local storage

---

## ✨ Features

- 🖼️ Create posts using camera or gallery
- 🧾 Add captions to posts
- ❤️ Like/unlike posts with live UI updates
- 💬 Comment on posts with timestamps
- 📥 Download images to gallery
- 🗂️ Local data persistence using Hive
- 🔁 Feed with lazy loading / pagination
- 🎨 Beautiful and responsive UI using Material Design

---

## 🧰 Tech Stack

- **Flutter(3.29.0)** (UI Framework)
- **Riverpod** (State Management)
- **Hive** (Local NoSQL database)
- **Image Picker** (Camera/Gallery access)
- **Shared Preferences** (Simple persistent key-value storage)
- **Dart** (Programming Language)

---

## 📦 APK Download

👉 [Download APK](https://drive.google.com/drive/folders/1pmv9Sj0LItx9GZUtj5zClYIL0RaNP3RB?usp=drive_link)

---

## 🚀 How to Run

### Prerequisites:

- Flutter SDK installed: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Android/iOS Emulator or device

### Steps:

```bash
git clone https://github.com/deepparsania/kevit_prac.git
cd kevit_prac
flutter pub get
flutter packages pub run build_runner build
flutter run


