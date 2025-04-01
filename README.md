# Qubee Games [![Release](https://img.shields.io/badge/Download-QubeeGames%20v1.0.0-green)](https://github.com/venopyX/QubeeGame/releases/tag/v1.0.0)

> <font color="cyan">**Learn With Laughter, Grow With Culture!**</font>

<img src="https://github.com/venopyX/QubeeGame/raw/main/image.png" alt="QubeeGame Logo" width="80%" height="50%">

> <font color="yellow">**Notice:**</font> <font color="lightgreen">This project is developed as part of my ALX Africa Software Engineering program and is intended to demonstrate skills and knowledge I acquired during the course</font>

Welcome to Qubee Games!
This Flutter application is designed to provide an engaging and educational experience for users, focusing on language learning and interactive gameplay. The app currently features three main MVP (Minimum Viable Product) features: Hibboo Language Learning Game, Playhouse Video Browsing Experience, and QubeeQuest Letter Tracing.

## 📱 App Screenshots

<div align="center">
  <img src="screenshots/home_screen.png" alt="Home Screen" width="250"/>
  <img src="screenshots/hibboo_game.png" alt="Hibboo Game" width="250"/>
  <img src="screenshots/qubee_quest.png" alt="Qubee Quest" width="250"/>
</div>

<div align="center">
  <img src="screenshots/playhouse.png" alt="Playhouse" width="250"/>
  <img src="screenshots/word_matching.png" alt="Word Matching" width="250"/>
</div>

## 🔗 Project Links

- [Deployed Application](https://github.com/venopyX/QubeeGame/releases/tag/v1.0.0) => [![Download](https://img.shields.io/badge/Download-QubeeGames%20v1.0.0-blue)](https://github.com/venopyX/QubeeGame/releases/tag/v1.0.0)

- [Project Blog Article](https://medium.com/@venopyx/building-qubee-games-educational-app-with-flutter-123456)

## Demo Video

<a href="https://www.youtube.com/watch?v=wC_Hru1s7WY">
  <img src="http://img.youtube.com/vi/wC_Hru1s7WY/0.jpg" alt="QubeeGames Demo Video">
</a>

## 👨‍💻 Author

- **VenopyX** - [LinkedIn](https://www.linkedin.com/in/venopyx/) | [GitHub](https://github.com/venopyX)

## Table of Contents

- [Qubee Games ](#qubee-games-)
  - [📱 App Screenshots](#-app-screenshots)
  - [🔗 Project Links](#-project-links)
  - [Demo Video](#demo-video)
  - [👨‍💻 Author](#-author)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
    - [Hibboo Language Learning Game](#hibboo-language-learning-game)
    - [Playhouse Video Browsing Experience](#playhouse-video-browsing-experience)
    - [QubeeQuest Letter Tracing](#qubeequest-letter-tracing)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
  - [Usage](#usage)
    - [Home Screen](#home-screen)
    - [Hibboo Language Learning Game](#hibboo-language-learning-game-1)
    - [Playhouse Video Browsing Experience](#playhouse-video-browsing-experience-1)
    - [QubeeQuest Letter Tracing](#qubeequest-letter-tracing-1)
  - [Project Structure](#project-structure)
  - [Technologies Used](#technologies-used)
  - [Contributing](#contributing)
    - [Contribution Guidelines](#contribution-guidelines)
  - [Related Projects](#related-projects)
  - [License](#license)
  - [The Story Behind Qubee Games 🚀](#the-story-behind-qubee-games-)
    - [Inspiration and Vision](#inspiration-and-vision)
    - [Technical Challenges and Solutions](#technical-challenges-and-solutions)
      - [Clean Architecture Implementation](#clean-architecture-implementation)
      - [Letter Tracing Algorithm](#letter-tracing-algorithm)
      - [Lessons Learned](#lessons-learned)
    - [Timeline and Development Process](#timeline-and-development-process)
    - [Future Enhancements](#future-enhancements)
    - [Personal Reflection](#personal-reflection)
  - [Acknowledgements](#acknowledgements)
  - [Contact](#contact)

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

- Flutter SDK installed on your machine (version 3.10.0 or later)
- Dart SDK installed on your machine (version 3.0.0 or later)
- An IDE such as Visual Studio Code or Android Studio
- Git installed on your machine
- A basic understanding of Dart and Flutter

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

## Usage

### Home Screen

The home screen serves as a gateway to all features of Qubee Games. From here, you can:

- Navigate to any of the game modules
- View featured games
- Access settings and preferences

### Hibboo Language Learning Game

1. Navigate to the Hibboo dashboard from the home page.
2. Start playing the game by answering word-based puzzles.
3. Use the hint feature if you're stuck on a particular question.
4. Track your progress and achievements through the visual growth system.
5. Celebrate your achievements as you reach higher levels.

### Playhouse Video Browsing Experience

1. Access the Playhouse dashboard from the home page.
2. Browse and search for videos using categories and filters.
3. Tap on a video to start playback.
4. Enjoy automatic playback of the next video in the queue.
5. Use the category filter to find videos on specific topics.

### QubeeQuest Letter Tracing

1. Open the QubeeQuest map page from the home page.
2. Select a letter to start tracing.
3. Follow the on-screen guides to trace the letter.
4. Receive real-time feedback on your tracing accuracy.
5. Collect treasure words as you complete letter tracing exercises.

## Project Structure

The project follows a clean architecture pattern with a feature-first approach:

```
lib/
├── app/              # Application-level configurations
│   ├── di/           # Dependency injection setup
│   ├── routes/       # Application routes
│   └── app.dart      # Main application widget
├── core/             # Core utilities and constants
├── features/         # Feature modules
│   ├── hibboo/       # Hibboo language learning game
│   ├── home/         # Home screen
│   ├── playhouse/    # Video browsing feature
│   ├── qubee_quest/  # Letter tracing game
│   └── word_matching/# Word matching game
├── shared/           # Shared widgets and themes
└── main.dart         # Entry point
```

Each feature follows the same structure:

- **data**: Data sources, models, and repository implementations
- **domain**: Entities, repository interfaces, and use cases
- **presentation**: UI components, state management, and widgets

## Technologies Used

- **Flutter**: Cross-platform UI toolkit
- **Provider**: State management
- **Clean Architecture**: Architectural pattern
- **Material Design 3**: UI design system
- **Lottie**: Animation library for visual effects
- **Google Fonts**: Typography customization

## Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch:
   ```
   git checkout -b feature-branch
   ```
3. Make your changes and commit them:
   ```
   git commit -am 'Add new feature'
   ```
4. Push to the branch:
   ```
   git push origin feature-branch
   ```
5. Create a new Pull Request.

### Contribution Guidelines

- Follow the Flutter style guide and best practices
- Write clean, maintainable code
- Include appropriate tests for new features
- Update documentation as necessary
- Ensure your code passes all existing tests

## Related Projects

- [Oromo Language Translator](https://play.google.com/store/apps/details?id=com.bj.oromotranslator) - Afan Oromo English translator
- [Oromo Kids](https://apkpure.com/oromo-kids-learn-afaan-oromo-english/com.batudevs.oromokids) - Quickly teach your kids AFAAN OROMO alphabets and ABC, colors, numbers, body parts.
- [Learn Afaan Oromo language](https://play.google.com/store/apps/details?id=eindbk.learn.oro) - It includes words and phrases to get you started in the exciting language of Afaan Oromo.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## The Story Behind Qubee Games 🚀

### Inspiration and Vision

Growing up in Ethiopia, I witnessed firsthand how technology could be leveraged to preserve cultural heritage while making education accessible. The Afan Oromo language, despite being spoken by over 35 million people, had very few digital learning resources. This gap inspired me to create Qubee Games during my journey at ALX Africa's Software Engineering program.

My vision was simple yet ambitious: build an educational platform that makes learning Afan Oromo engaging, interactive, and accessible to anyone with a smartphone.

### Technical Challenges and Solutions

#### Clean Architecture Implementation

One of my biggest challenges was implementing Clean Architecture in Flutter. I wanted to create a codebase that was maintainable, testable, and scalable. The solution was to organize the project into three layers:

- **Presentation Layer**: UI components using Provider for state management
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Data sources and repository implementations

This separation allowed me to develop features independently and ensure that business logic wasn't tightly coupled with UI or external data sources.

```dart
// Example of clean architecture in the Hibboo feature
// Domain layer - Use case
class GetHibbooList {
  final HibbooRepository repository;
  GetHibbooList(this.repository);

  Future<List<Hibboo>> call() async {
    return await repository.getHibbooList();
  }
}
```

#### Letter Tracing Algorithm

The QubeeQuest feature required a sophisticated algorithm to track a user's finger movement and calculate how accurately they traced a letter. The solution involved:

1. Breaking down letters into segments
2. Using path sampling to track coverage of each segment
3. Implementing a tolerance system to accommodate different tracing styles

```dart
// Simplified version of the tracing accuracy algorithm
double calculatePathCoverage(Path userPath, Path templatePath) {
  final sampledUserPoints = samplePath(userPath, sampleCount: 100);
  final sampledTemplatePoints = samplePath(templatePath, sampleCount: 100);

  int coveredPoints = 0;
  for (final templatePoint in sampledTemplatePoints) {
    if (isPointCovered(templatePoint, sampledUserPoints, tolerance: 15.0)) {
      coveredPoints++;
    }
  }

  return coveredPoints / sampledTemplatePoints.length;
}
```

This was particularly challenging because it needed to be performant on low-end devices while still providing accurate feedback to users.

#### Lessons Learned

1. **State Management Complexity**: Initially, I used setState() for state management but quickly realized its limitations for complex features. Transitioning to Provider significantly improved code organization but came with its learning curve.

2. **Performance Optimization**: The letter tracing feature initially caused frame drops on older devices. I had to refine the algorithm to use fewer computational resources while maintaining accuracy.

3. **Offline-First Approach**: Learning resources needed to be available offline, which required careful planning of data storage and synchronization strategies.

### Timeline and Development Process

| Week   | Milestone                                            |
| ------ | ---------------------------------------------------- |
| Week 1 | Research, wireframing, and architecture planning     |
| Week 2 | Core app structure and Hibboo feature implementation |
| Week 3 | Playhouse video platform development                 |
| Week 4 | QubeeQuest letter tracing implementation             |
| Week 5 | Testing, optimization, and release preparation       |

### Future Enhancements

Qubee Games is just beginning its journey. Future iterations will include:

- **Multiplayer Competitions**: Allow friends to compete in language learning challenges
- **AI-Powered Personalization**: Adapt difficulty based on user learning patterns
- **Expanded Cultural Content**: Add more traditional stories and cultural elements
- **Voice Recognition**: Implement pronunciation practice with feedback

### Personal Reflection

This project pushed me far beyond my comfort zone. As a developer who primarily worked on backend systems, diving into mobile development with Flutter was both exciting and intimidating. There were nights of debugging gesture detectors and days of refactoring provider implementations, but each challenge taught me valuable lessons about software design, user experience, and the impact technology can have on cultural preservation.

Qubee Games represents not just a technical achievement, but a personal mission to use technology for cultural and educational empowerment. While it's still a work in progress, I'm proud of what it's become and excited about where it's going.

> "The beauty of programming isn't just in what we build, but in how our creations can preserve what matters to us." — Personal motto during this project

## Acknowledgements

- ALX Africa Software Engineering Program for providing the opportunity to develop this project
- The Flutter community for their excellent documentation and support
- Google Fonts for providing beautiful typography options
- All contributors who have helped improve this project

## Contact

If you have any questions or suggestions, feel free to contact me:

- Email: [venopyx@gmail.com](mailto:venopyx@gmail.com)
- GitHub: [@venopyX](https://github.com/venopyX)
- LinkedIn: [VenopyX](https://www.linkedin.com/in/venopyx/)

---

> <font color="cyan">Don't forget to Star the repo 😄</font>

Thank you for using Qubee Games! I hope you enjoy the educational and interactive experience.
