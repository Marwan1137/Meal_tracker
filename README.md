<h1 align="center" style="font-weight: bold;">Meal Tracker 🍽️</h1>
<p align="center">A modern, cross-platform meal tracking application built with Flutter. Track your daily meals, manage calorie intake, and maintain a healthy lifestyle with clean architecture.</p>
<p align="center"> </p>

💻 Technologies
- **Flutter**: Cross-platform framework
- **Dart**: Programming language
- **Clean Architecture**: Clean separation of concerns
- **Bloc/Cubit**: State management
- **Get It & Injectable**: Dependency injection
- **Shared Preferences**: Local storage
- **Image Picker & File Picker**: Media handling
- **Mockito**: Testing framework

🚀 Getting Started

Prerequisites
1. Flutter SDK (version 3.13.0 or later):
   - Download from Flutter's official website
   - Add Flutter to your PATH:
  ```bash
    export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"
  ```
-Verify installation
  ```bash
      flutter --version
  ```

 2. IDE:

    -  VS Code: Install Flutter and Dart extensions.

    -  Android Studio: Install Flutter and Dart plugins.
   
 3. Installation:
      - Clone the repository:
        ```bash
              git clone https://github.com/Marwan1137/Movie-App.git
            
      - Navigate to the project:
        ```bash
              cd meal_tracker
            

      - Install dependencies:
        ```bash
              flutter pub get
            
      - Run the app:
         ```bash
              flutter run
           

🏗 Project Structure

```bash           
lib/
├── core/
│   ├── DI/
│   ├── failures/
│   └── result/
│   └── utils/
├── data/
│   ├── datasource/
│   ├── datasourceimpl/
│   ├── model/
│   └── repo_impl/
├── domain/
│   ├── entity/
│   ├── repo/
│   └── usecases/
├── UI/
│   ├── cubit/
│   ├── screens/
│   └── widgets/
└── main.dart
 ```


✨ Key Features
1. Meal Management:
- Add, edit, and delete meals
- Track calories for each meal
- Categorize meals (breakfast, lunch, dinner, etc.)
- Add meal images

2. Data Persistence:
- Local storage for meal data
- Persistent theme preferences

3. Clean Architecture:
- Separation of concerns
- Testable and maintainable codebase
- Dependency injection

4. User Interface:
- Material Design 3
- Dark/Light theme support
- Responsive layout
- Intuitive meal management

5. State Management with Cubit:
- Efficient state updates
- Predictable state changes
- Intent-based actions

🛠 Support
For issues or questions:
- Open an issue on GitHub
- Contact: Marwan.hakil79@gmail.com

📱 Responsiveness Approach
- Flexible layouts using Column and Expanded widgets
- Adaptive UI elements based on screen size
- Support for both portrait and landscape orientations
- Cross-platform compatibility (iOS and Android)

📜 License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


  
