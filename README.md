# ⚡ Pulse — Interactive Analytics Dashboard UI

A beautifully designed, fully responsive Flutter analytics dashboard with animated cards, interactive charts, and drag-to-reorder layout customization.

---

## 📱 Screenshots

> Add your screenshots here after building the app

---

## ✨ Features

### 🃏 Swipeable Metric Cards
- Horizontal swipe to navigate between metric cards
- Tap any card to expand and see detailed stats
- Cards automatically collapse when you swipe to next card
- Animated page indicator dots with unique color per card

### 📊 Interactive Charts
- **Line Chart** — animated reveal with refresh button for new data
- **Bar Chart** — elastic spring animation with tap to highlight bars
- **Pie Chart** — smooth arc draw-in animation with tap to expand segments

### 🔀 Drag to Reorder
- Long press any chart card to drag and reorder your dashboard
- Smooth lift and scale animation while dragging
- Rearrange charts in any order you prefer

### 📐 Fully Responsive
- **Mobile** — swipeable cards with bottom navigation bar
- **Tablet** — 2 column metric grid with bottom navigation bar
- **Desktop** — side navigation with 4 column grid and 2 column charts

---

## 🛠️ Tech Stack

- **Flutter** — core framework
- **fl_chart** — line, bar and pie charts
- **Google Fonts** — Space Grotesk typography
- **Cupertino Icons** — iOS style icons

---

## 📁 Project Structure

- **main.dart** — app entry point and theme setup
- **core/constants** — color design tokens
- **core/utils** — responsive breakpoints and fluid sizing helpers
- **models** — dashboard card data model
- **screens** — main dashboard screen that switches layout per device
- **widgets** — all reusable UI components including cards, charts and navigation



### Typography
- Font family — Space Grotesk
- Multiple font weights used from regular to extra bold



## 📐 Responsive Behavior

The app uses a custom Responsive utility class that provides fluid sizing across all screen sizes. It automatically detects whether the user is on mobile, tablet or desktop and adjusts font sizes, spacing, chart heights, card heights and layout columns accordingly.

---

## 🐛 Bugs Fixed During Development

- PageController multiple clients crash during rebuild
- Bottom overflow error when expanding cards
- Horizontal overflow in expanded card stats row on small screens
- Content flashing briefly during card expand animation
- Spacer widget crashing inside fixed height columns

---

## 🗺️ Roadmap

- Real API integration
- Dark and light theme toggle
- Push notifications
- Export charts as PDF
- User authentication screen
- Persistent layout order saved to device storage
- Unit and widget tests


---

<p align="center">Built with ❤️ using Flutter</p>
