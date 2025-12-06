# ⛪ Parish Connect

**Parish Connect** is a mobile application developed with **Flutter** designed to revolutionize data management and collection within the various structures of the Church, including Small Christian Communities (**SCCs**), **Mission Stations**, **Deaneries**, and **Parishes**. Our goal is to provide a unified, accurate, and organized platform for data handling, eliminating manual processes and inherent biases.

---

## ✨ Features

Parish Connect provides a robust set of tools tailored for ecclesiastical administration:

* **Organized Data Collection:** Structured forms for collecting specific data (e.g., membership, financials, sacramental records) relevant to each level of the Church structure.
* **Hierarchical Management:** Seamlessly manage and categorize data flow from the SCC level all the way up to the Deanery and Parish level.
* **Bias-Free Reporting:** Data is collected and stored in an objective format, ensuring reports and insights are accurate and unbiased.
* **User Roles and Permissions:** Secure access control tailored for various users (e.g., SCC leaders, Mission Station coordinators, Parish priests, data entry personnel).
* **Offline Capability (Planned):** Allow data collection in areas with limited or no internet connectivity, syncing once a connection is established.
* **Intuitive Mobile Interface:** A clean, easy-to-use interface built with Flutter for a consistent experience across iOS and Android devices.

---

## 💻 Tech Stack

Parish Connect is a full-stack application leveraging the following technologies:

| Component | Technology | Details |
| :--- | :--- | :--- |
| **Frontend** | **Flutter** (Dart) | Cross-platform mobile application development. |
| **Backend** | **Node.js** | Provides the RESTful API for communication with the mobile app. |
| **Framework/Library** | (e.g., **Express.js**) | Used for building the robust backend server and handling routes. |
| **Database** | (e.g., **MongoDB**) | *Specify which database is used by the Node.js backend.* |
| **State Management** | (Riverpod) | *Specify state management solution for the Flutter app.* |

---

## 🚀 Getting Started

To set up the complete Parish Connect environment, you need to set up both the **mobile app (Flutter)** and the **API server (Node.js)**.

### Prerequisites

1.  **Flutter SDK:** [Installation Guide](https://flutter.dev/docs/get-started/install)
2.  **Node.js & npm/yarn:** [Installation Guide](https://nodejs.org/en/download/)
3.  **Code Editor:** VS Code or Android Studio with Flutter/Dart plugins.

### 1. Backend Setup (Node.js API)

1.  **Navigate to the backend directory:**
    ```bash
    cd backend/ # Assuming your Node.js code is in a folder named 'backend'
    ```
2.  **Install server dependencies:**
    ```bash
    npm install # or yarn install
    ```
3.  **Configure Environment Variables:**
    * Create a `.env` file in the backend root directory.
    * Add necessary configurations (e.g., database connection string, port, JWT secrets):
        ```
        PORT=3000
        MONGODB_URI=...
        # Add other necessary variables
        ```
4.  **Start the API Server:**
    ```bash
    npm start # or node server.js (depending on your startup script)
    ```
    The server should now be running, typically on `http://localhost:3000`.

### 2. Frontend Setup (Flutter App)

1.  **Navigate back to the project root and then into the frontend directory:**
    ```bash
    cd ../frontend/ # Assuming your Flutter code is in a folder named 'frontend'
    ```
2.  **Fetch Flutter dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Configure API URL:**
    * Ensure the app's configuration file (e.g., `lib/config/api_config.dart`) points to the correct backend address (e.g., `http://10.0.2.2:3000` for Android emulator or `http://localhost:3000` for web/desktop).
4.  **Run the App:**
    ```bash
    flutter run
    ```
    Select a connected device or emulator to run the application.

---

## 📂 Project Structure

A high-level overview of the main directories: