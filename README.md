![Silver App Logo](/assets/images/silver-logo_white_font-color.png "Silver App Logo")
# Silver Express App

Silver Express is a taxicab company.

## Run the project

To run the project:

First, rename the file name ".env.example" to ".env". Then make sure you have the API working and fill in the data correctly in the ".env" file.

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

First open the terminal and build the  web project build with flutter with the following command line on the silver-app folder.

```sh
flutter build web
```
Then rename C:\Users\Popis\Desktop\silver\silver-app\build\web\assets\.env without a leading "."

Next, in the top directory, copy the .env file and the docker-compose.yml file.

Finally, open a terminal in the main directory and run:

```sh
docker compose up
```

## Completed Tasks

### Installed dependencies
- auth0_flutter: ^1.2.1
- flutter_dotenv: ^5.1.0
- flutter_riverpod: ^2.3.6
- go_router: ^10.0.0

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