# 🚀 How to Run the App

Welcome! Follow these simple steps to set up and run the app on your local machine:

---

## 📝 Prerequisites
- **Xcode** installed (latest version recommended)
- **CocoaPods** installed (`sudo gem install cocoapods` if you don't have it)

---

## 📂 Getting Started

1. **Download or Clone the Repository**
   - Click the green `Code` button and select `Download ZIP`, or clone it using Git:
     ```bash
     git clone https://github.com/Mrwanhany/MazzadyTask/
     ```

2. **Open the Project Folder**
   - Locate the project folder in **Finder**.

3. **Install Pods**
   - Open **Terminal**.
   - Navigate to the project folder (drag the folder into Terminal or use `cd path/to/project`).
   - Run the following command:
     ```bash
     pod install
     ```

4. **Open the Workspace**
   - After `pod install`, always open the `.xcworkspace` file, **not** the `.xcodeproj`.

5. **Select the Target and Simulator**
   - In Xcode, select your project target.
   - Choose a simulator (e.g., iPhone 15 Pro).

6. **Build and Run**
   - Press `Cmd + R` or click the `Run` button in Xcode.

---

## ✨ Key Features

### 🌐 Localization
- Supports multiple languages with dynamic switching.
- All user-facing texts managed via `.strings` files.

### 💾 Cached Items
- Local data caching to support offline usage.
- Items are loaded from cache when network is unavailable.

### 📱 Responsive UI
- Flexible layouts and dynamic resizing based on content.
- Fully optimized for different device sizes and orientations.

### 🎯 MVVM Architecture
- Clear separation of concerns.
- ViewModels handle business logic and networking.

### 🧩 Protocol-Oriented Programming
- Components are designed with protocols and delegates.
- Improves reusability, scalability, and unit testing.

---

## 🎉 You're all set!
If you face any issues, make sure:
- You opened the `.xcworkspace` file.
- Your Pods are installed correctly.
- Your Xcode version is compatible.

Happy Coding! 🚀

