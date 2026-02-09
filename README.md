# KAPE4U - Premium Coffee Discovery App

A Flutter-based coffee discovery application designed for the Philippines. KAPE4U allows users to find trending cafes, access exclusive promotional deals, and use simulated AI to summarize reviews.

## Features Implemented

### 1. Home Feed
* **Staggered Grid Layout:** Displays coffee shops in a masonry-style feed.
* **Immersive Cards:** Features high-quality images with gradient overlays and text legibility enhancements.
* **Dynamic Data:** Fetches real-time coffee shop data from a remote JSON API.

### 2. Premium Detail Screen
* **Vertical Photo Stack:** A scrollable gallery of high-resolution images.
* **Info Cards:** Floating layout for Address, Website, and Phone information.
* **Story Section:** A dedicated area for the cafe's description.

### 3. Mocha AI Simulation
* **Chat Interface:** A custom UI with a "Golden Sand" theme.
* **Context Aware:** The simulation detects which shop is being viewed and provides specific answers regarding WiFi, noise levels, and bestsellers.
* **Entry Point:** Accessible via an "Ask" button on the detail page.

### 4. Deals & Promos
* **Horizontal Carousel:** A full-screen, swipeable view of active promotions.
* **Modern UI:** Utilizes a PageView with viewport fractions for a "peeking" card effect.
* **Real-time Updates:** Promotional data is fetched dynamically from the cloud.

### 5. Interactive Map
* **OpenStreetMap Integration:** Functional map centered on Manila.
* **Custom Markers:** Custom icons to denote different shop types.

---

## Technical Stack

* **Framework:** Flutter (Dart)
* **State Management:** Native setState
* **Networking:** http package
* **Backend (Mock):** npoint.io (JSON storage)
* **Map Engine:** flutter_map & latlong2
* **UI Libraries:** flutter_staggered_grid_view, google_fonts

---

## Setup and Execution

1.  **Install Dependencies:**
    Run the following command to install required packages:
    `flutter pub get`

2.  **Run on Web (Mobile Simulator):**
    Execute the following command to serve the app:
    `flutter run -d web-server`

3.  **View the App:**
    Open the localhost link provided in your terminal (e.g., http://localhost:xxxx). The app includes `device_preview` to simulate a mobile frame within the browser.

---

## Project Structure

* `lib/main.dart`: Entry point, configured with DevicePreview.
* `lib/models/`: Data models for CoffeeShop.
* `lib/screens/`:
    * `home_screen.dart`: