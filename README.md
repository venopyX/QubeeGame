# Qubee Games [![Release](https://img.shields.io/badge/Download-QubeeGames%20v1.0.0-green)](https://github.com/venopyX/QubeeGame/releases/tag/v1.0.0)

> <font color="cyan">**Learn With Laughter, Grow With Culture!**</font>

> <font color="yellow">**Notice:**</font> <font color="lightgreen">This project is developed as part of my ALX Africa Software Engineering program and is intended to demonstrate skills and knowledge I acquired during the course</font>

Welcome to Qubee Games!
This Flutter application is designed to provide an engaging and educational experience for users, focusing on language learning and interactive gameplay. The app currently features three main MVP (Minimum Viable Product) features: Hibboo Language Learning Game, Playhouse Video Browsing Experience, and QubeeQuest Letter Tracing.


<!-- ![QubeeGames Logo](https://github.com/venopyX/QubeeGame/raw/main/image.png) -->

<img src="https://github.com/venopyX/QubeeGame/raw/main/image.png" alt="QubeeGame Logo" width="80%" height="50%">

## Download

[![Download](https://img.shields.io/badge/Download-QubeeGames%20v1.0.0-blue)](https://github.com/venopyX/QubeeGame/releases/tag/v1.0.0)

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
   - [Hibboo Language Learning Game](#hibboo-language-learning-game)
   - [Playhouse Video Browsing Experience](#playhouse-video-browsing-experience)
   - [QubeeQuest Letter Tracing](#qubee-quest-letter-tracing)
3. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
4. [Usage](#usage)
5. [Contributing](#contributing)
6. [License](#license)
7. [Contact](#contact)

## Introduction

Qubee Games is an educational Flutter application that aims to make learning Afan Oromo fun and interactive. The app is built using the Flutter framework, which allows for cross-platform development, ensuring a consistent user experience across different devices. The app features a clean architecture pattern, state management using Provider, and a modern UI design.

## Features

### Hibboo Language Learning Game

The Hibboo Language Learning Game is an interactive mini-game that helps users learn traditional Oromo words through word-based puzzles. The game features a visual growth progression system, achievement tracking, and an interactive hint system.

- **Game Mechanics**:
  - Word-based puzzles presented in question-answer format.
  - Interactive hint system with scrambled letters.
  - Custom UI designed to match QubeeGames style.

- **Progress & Achievement System**:
  - 5-level progression system with visual representation.
  - Achievement tracking for users reaching 85+ correct answers.
  - Growth points system that ties into visual tree evolution.

- **Visual Growth Representation**:
  - Animated tree that evolves through 5 distinct stages.
  - Special visual effects for higher-level achievements.

- **Educational Approach**:
  - Lenient answer matching to improve the learning curve.
  - Success dialogs showing both the user's answer and the correct spelling.
  - Detailed feedback to enhance vocabulary retention.

### Playhouse Video Browsing Experience

The Playhouse feature transforms the application into a clean, modern video browsing experience with search and category filtering. The new implementation includes automatic playback of the next video in the queue and a loop-back feature once all videos are watched.

- **Entities and Models**:
  - Added `Video` entity to include categories.
  - Created `VideoModel` to match the new `Video` entity.

- **Data Layer**:
  - Implemented `PlayhouseDatasource` for fetching video data.
  - Added `PlayhouseRepository` and its implementation.

- **Use Cases**:
  - Created `TrackVideoProgress` use case for managing the playback progress of videos.

- **Providers**:
  - Implemented `PlayhouseProvider` to handle search, filtering, and auto-play features.

- **UI Components**:
  - Designed `PlayhouseDashboardPage` with a new layout for video browsing.
  - Added `PlayhousePlayingPage` to handle video playback with auto-advance.
  - Developed `VideoCardWidget` for displaying video information.
  - Updated `VideoPlayerWidget` to auto-continue to the next video.

- **Dependency Injection**:
  - Configured DI setup to include the new Playhouse feature.

- **Routing**:
  - Added necessary routes for the new video playback flow.

- **Theme**:
  - Updated the app theme to use Material 3 for a modern look.

### QubeeQuest Letter Tracing

QubeeQuest is an interactive educational feature that helps users learn the Qubee alphabet through guided letter tracing exercises. This feature provides an engaging way for learners to practice writing letters while receiving real-time feedback on their accuracy.

- **Letter Tracing Mechanics**:
  - Intuitive tracing interface with visual guides.
  - Real-time accuracy feedback.
  - Path coverage calculation using a sampling-based approach.
  - Multiple segments requiring 70% coverage per segment.

- **Gamification Elements**:
  - Points system based on tracing accuracy and path coverage.
  - Letter unlocking progression system.
  - Celebration overlay with confetti upon successful completion.
  - Treasure word collection feature.

- **Learning Aids**:
  - Audio pronunciation support.
  - Example words and sentences.
  - Visual demonstrations of letter forms (capital and small).
  - Practice count tracking.

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:
- Flutter SDK installed on your machine.
- Dart SDK installed on your machine.
- An IDE such as Visual Studio Code or Android Studio.

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/venopyx/QubeeGame.git
   ```
2. Navigate to the project directory:
   ```sh
   cd QubeeGame
   ```
3. Install the dependencies:
   ```sh
   flutter pub get
   ```
4. Run the application:
   ```sh
   flutter run
   ```
   
> <font color="cyan">Don't forget to Star the repo 😄
</font>

## Usage

1. **Hibboo Language Learning Game**:
   - Navigate to the Hibboo dashboard from the home page.
   - Start playing the game by answering word-based puzzles.
   - Track your progress and achievements through the visual growth system.

2. **Playhouse Video Browsing Experience**:
   - Access the Playhouse dashboard from the home page.
   - Browse and search for videos using categories and filters.
   - Enjoy automatic playback of the next video in the queue.

3. **QubeeQuest Letter Tracing**:
   - Open the QubeeQuest map page from the home page.
   - Select a letter to start tracing.
   - Receive real-time feedback and track your progress through the gamification elements.

## Contributing

Contributions are welcome! Please follow these steps to contribute:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a new Pull Request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

If you have any questions or suggestions, feel free to contact me at [venopyx@gmail.com](mailto:venopyx@gmail.com).

---

Thank you for using Qubee Games! We hope you enjoy the educational and interactive experience.
