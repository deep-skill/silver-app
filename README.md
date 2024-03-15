![Silver App Logo](/assets/images/silver-logo_white_font-color.png "Silver App Logo")
# Silver Express App

Silver Express is a taxicab company.

## Run the project

To run the project:

First, rename the file name ".env.example" to ".env". Then make sure you have the API working and fill in the data correctly in the ".env" file.

Then, to create env variables run the command:

```sh
dart run build_runner build
```

When modifying the .env file, the generator might not pick up the change due to dart-lang/build#967. If that happens simply clean the build cache and run the generator again.

```sh
dart run build_runner clean
```
```sh
dart run build_runner build --delete-conflicting-outputs
```


### 📱 Mobile

Press F5 on main.dart or you can use the [Flutter CLI's](https://docs.flutter.dev/reference/flutter-cli) `run` command.

```sh
flutter run
```

Ensure you have at least one emulator running. If you have multiple running, the CLI will prompt you to select the one to run the app on.

### 🖥️ Web

```sh
flutter run -d chrome --web-port 3000 --web-renderer html
```
### 🐳 Docker Web and API

First open the terminal and build the web project build with flutter with the following command line on the silver-app folder.

```sh
flutter build web
```

Then rename silver-app\build\web\assets\.env without a leading "."

Next, in the top directory, copy the .env file (from the api or app folder) and the docker-compose.yml file.

Finally, open a terminal in the main directory and run:

```sh
docker compose up
```

## Completed Tasks

### Installed dependencies
  - animate_do
  - auth0_flutter
  - cupertino_icons
  - dash_bubble
  - dio: ^5.3.2
  - envied: ^0.5.3
  - firebase_analytics: ^10.7.4
  - firebase_core: ^2.24.2
  - firebase_crashlytics: ^3.4.8
  - flutter: sdk: flutter
  - flutter_riverpod: ^2.3.6
  - formz: ^0.6.1
  - geolocator: ^10.1.0
  - go_router: ^10.0.0
  - google_maps_flutter: ^2.5.2
  - google_maps_flutter_web: ^0.5.4+3
  - intl: ^0.18.1
  - url_launcher: ^6.2.1

### Installed dev dependencies
  - build_runner: ^2.4.8
  - envied_generator: ^0.5.3
  - flutter_lints: ^2.0.0
  - flutter_test: sdk: flutter

### Auth0
- app/build.gradle: Upgrade minSdkVersion to 21, and added manifestPlaceholders
- web/index.html: added auth0Web script tag
- API audience
- Scopes: user, driver, admin

### GoRouter
- app_router: Redirects to routes
- app_router_notifier: Notifies authProvider state
- app_router scopes

### Assets
- Pubspect: Added
- assets/images/
- Logos

### Dio Request:
- .env your IP to call server
- accessToken added to dio

### Fonts:
- Pubspect: Added
- Primary: Raleway
- Secondary: Montserrat

### Providers:
- ProviderScope on  MainApp()

### Theme:
- Darkblue: #031329
- Blue: #164672
- Lightblue: #23A5CD
- Grey: #E7E7E7
- White: #FFFFFF