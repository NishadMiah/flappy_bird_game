# 🐦 Flappy Bird (Flame Engine Edition)

A modern, premium, and high-performance Flappy Bird clone built with **Flutter** and the **Flame Engine** (`v1.37.0`). The game features a 100% canvas-rendered design system, implementing all graphics (the bird, scrolling parallax backgrounds, ground, and obstacle pipes) procedurally using Flutter's `Canvas` API. This results in an incredibly lightweight bundle without the overhead of heavy image assets.

---

## 📱 Gameplay Preview

Below is a preview of the game running in the simulator:

<p align="center">
  <img src="Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20Max%20-%202026-06-19%20at%2022.03.18.png" alt="Flappy Bird Flame Screenshot" width="360" style="border-radius: 20px; box-shadow: 0 8px 24px rgba(0,0,0,0.3);" />
</p>

---

## ⚡ Key Features

*   **🎮 Responsive Game Engine**: Leverages the power of the Flame game loop for seamless physics, collision handling, and object lifecycle management.
*   **🎨 100% Canvas & Vector Rendering**:
    *   **Sky Gradient**: Rich blue transition gradient that shifts from sky to horizon.
    *   **Parallax City Skyline**: Multi-layered background scrolling with independent speed coefficients. Contains randomized building widths, heights, depths, colors, and subtle warm window lights.
    *   **Procedural Clouds**: Slowly floating custom-drawn clouds that wrap around the screen.
    *   **Cylindrical Pipes**: 3D shading gradients on green pipes with authentic top and bottom caps.
*   **🦅 Dynamic Bird Physics**:
    *   Responsive tap-based flap impulse.
    *   Procedural flight rotation: tilts upward during a flap and pivots downward as gravity pulls it down.
    *   Flapping wing animation synced with vertical velocity.
*   **💥 Forgiving Hitboxes**: Incorporates a slightly shrunk circular hitbox (`CircleHitbox`) on the bird to give the player a fair, classic arcade feel during near-misses.
*   **✨ Modern Glassmorphism Overlays**:
    *   **Main Menu**: Implements a glassmorphic blurred backdrop filter with a pulsing, custom-scaled "PLAY NOW" button and high score persistence.
    *   **Heads-Up Display (HUD)**: A minimal overhead layout showing the live score.
    *   **Game Over**: A red-accented blurred panel displaying the final score, current high score, and an instant replay button.
*   **⚙️ Mobile Optimization**: Locks the device to portrait mode and activates full-screen sticky immersive mode to maximize playable area.

---

## 🛠️ Technical Details & Physics

The game incorporates classic retro parameters optimized for high-refresh-rate displays:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| **Gravity** | `1000.0` | Pulls the bird downwards over time |
| **Flap Strength** | `-320.0` | Upward velocity impulse applied on screen tap |
| **Pipe Spawn Interval** | `1.8s` | Time gap between procedural pipe pair spawns |
| **Pipe Gap Size** | `180.0` | Vertical space opening between top and bottom pipes |
| **Ground Scrolling Velocity**| `120.0` | Horizontal speed of ground and pipes |
| **Sky Skyline Velocity** | `36.0` | Middle layer scroll speed (30% of ground velocity) |
| **Cloud Scrolling Velocity** | `18.0` | Furthest background layer scroll speed (15% of ground velocity) |

---

## 📂 Project Architecture

The codebase is organized following Flutter and Flame best practices:

```text
lib/
 ├── main.dart                      # App entry point, orientation locks, fullscreen setup
 └── game/
      ├── flappy_bird_game.dart     # Core Flame game orchestrator (state, tap listeners, scoring)
      ├── components/
      │    ├── background.dart      # Skyline, cloud vectors, and parallax rendering
      │    ├── bird.dart            # Gravity, flapping animation, custom canvas drawing
      │    ├── ground.dart          # Scrolling ground stripes and grass line
      │    └── pipe.dart            # Cylindrical 3D gradient pipes, score trigger, and hitboxes
      └── overlays/
           ├── main_menu.dart       # Title screen with pulsing button and background float animation
           ├── hud.dart             # Live score tracker overlay
           └── game_over.dart       # Glassmorphic failure screen with high score indicator
```

---

## 🚀 Getting Started

### Prerequisites
Make sure you have [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.

### Setup Instructions

1.  **Clone the Repository**:
    ```bash
    git clone <your-repo-url>
    cd flappy_bird_game
    ```

2.  **Get Packages**:
    Fetch the necessary Flame and Flutter dependencies.
    ```bash
    flutter pub get
    ```

3.  **Run the Game**:
    Ensure you have an emulator open or a physical device connected.
    ```bash
    flutter run
    ```

---

## 📜 Dependencies

*   [Flutter SDK](https://flutter.dev)
*   [Flame Game Engine](https://pub.dev/packages/flame) (`^1.37.0`)
