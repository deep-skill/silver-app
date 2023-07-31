# Silver Express App

Silver Express is a taxicab company.

## Run the project

To run the project:

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

## Completed Tasks

### Installed dependencies
- auth0_flutter: ^1.2.1
- flutter_dotenv: ^5.1.0
- flutter_riverpod: ^2.3.6
- go_router: ^10.0.0
- shared_preferences: ^2.2.0

### Auth0
- app/build.gradle: Upgrade minSdkVersion to 21, and added manifestPlaceholders
- web/index.html: added auth0Web script tag
