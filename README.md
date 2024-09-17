# TodoTestApp

This repository contains a Todo application built using the VIPER architectural pattern. The app allows users to manage their tasks efficiently, supporting features such as adding, updating, and deleting todos. It also includes unit tests to ensure the reliability and robustness of the application's core functionalities.

## Features

- **Add Todos**: Create new tasks with a name and description.
- **Update Todos**: Edit existing tasks to change their details or completion status.
- **Delete Todos**: Remove tasks that are no longer needed.
- **Mark as Completed**: Toggle the completion status of tasks.
- **Persistent Storage**: Todos are stored using Core Data for persistence across app launches.
- **Initial Data Loading**: On the first launch, the app loads a predefined list of todos.
- **VIPER Architecture**: The app is structured using the VIPER pattern for clear separation of concerns.
- **Unit Tests**: Comprehensive unit tests cover models, services, and VIPER components.

## Architecture

The app follows the VIPER architectural pattern, which divides the application logic into five distinct layers:

- **View**: Handles the display of information to the user and user interactions.
- **Interactor**: Contains the business logic related to the data (Entities) or networking.
- **Presenter**: Acts as a mediator between the View and Interactor, formatting data for display.
- **Entity**: Simple data objects used by the Interactor.
- **Router**: Manages navigation and the creation of modules.

## Getting Started

### Prerequisites

- **Xcode 12 or later**
- **iOS SDK 14.0 or later**

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/dockoks/TodoTestApp
   ```
1. **Open the project**
   ```bash
   cd TodoApp
   open TodoApp.xcodeproj
   ```
### Running the App
1. Select a Simulator or Device
Choose an iOS Simulator or a connected device from Xcode.
1. Build and Run
Click the Run button or press `Cmd + R` to build and launch the app.

### Running Unit Tests
1. Select the Test Scheme
Choose the TodoApp scheme and select the desired test target.
1. Run Tests
Click on Product > Test or press Cmd + U to execute the unit tests.

### Project Structure
```
.
  ├── App
  │   ├── Application                 # App & Scene Delegate
  │   ├── CoreData                    # Data models
  │   │   └── Generated Entities
  │   ├── Helpers                     # Extensions 
  │   ├── Modules                     
  │   │   ├── Shared                  # Custom UI components & Entities
  │   │   ├── AddTodo                 # View, Presenter, Interactor, Router, Module Builder
  │   │   ├── TodoDetails             # View, Presenter, Interactor, Router, Module Builder
  │   │   └── TodoList                # View, Presenter, Interactor, Router, Module Builder & Module UI components
  │   ├── Resources                   
  │   │   ├── ColorPalette            # Custom app colors
  │   │   └── TodoFonts               # Custom fonts
  │   └── Services                    
  │       ├── APIClientService        # Handles data fetched from url
  │       ├── UserDefaultsService     # Tracks first launch
  │       ├── CoreDataManager         # Restores, saved, updates, deletes data from CoreData
  │       └── TodoService             # Manages complex scenarios of all services
  └── Tests                           # Unit tests
```

### Dependencies
- Core Data: Used for data persistence.
- UIKit: For building the user interface.
- XCTest: Used for unit testing.
