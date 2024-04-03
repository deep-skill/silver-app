![Silver App Logo](/assets/images/silver-logo_white_font-color.png "Silver App Logo")
# Silver Express App

Silver Express is a taxicab company.

## Technologies

- Flutter: Cross-platform development framework (Android and iOS)
- Node.js: Runtime environment for backend development
- PostgreSQL: Robust and scalable database
- Nginx: Efficient and secure web server
- Auth0: Secure and flexible authentication
- Docker Compose: Tool for automating deploying applications in containers

## Getting started

API:

1- Navigate to the silver-api/docker directory.

2- Rename the file .env.dockercompose.template to .env.dockercompose.

3- Fill in the environment variables in the .env.dockercompose file.

4- Run the command docker compose up to start the API in development mode.

```sh
docker compose up
```

APP:

1- Complete the .env file at the root of the silver-app directory with the environment variables.

2- Run the command to generate obfuscated environment variables.

```sh
dart run build_runner build
```
*-  When modifying the .env file, the generator might not pick up the change due to dart-lang/build#967. If that happens simply clean the build cache and run the generator again.

```sh
dart run build_runner clean
```
```sh
dart run build_runner build --delete-conflicting-outputs
```

Running Options:



### 📱 Mobile

With API running, execute press F5 on a .dart file or you can use the [Flutter CLI's](https://docs.flutter.dev/reference/flutter-cli) `run` command:
```sh
flutter run
```
Ensure you have at least one emulator running. If you have multiple running, the CLI will prompt you to select the one to run the app on.

### 🖥️ Web

With API running, execute:

```sh
flutter run -d chrome --web-port 3000 --web-renderer html
```

or if you want to use another browser:
```sh
flutter run -d web-server --web-port 3000 --web-renderer html
```

### 🐳 Docker Web and API without API running

Open the terminal and build the web project build with flutter with the following command line on the silver-app folder. You must create the .env variables obfuscated as described above.

```sh
flutter build web
```

Finally, open a terminal in the "silver-app/docker" directory  and run:

- Local mode:
```sh
docker compose -f docker-compose.local.yml up
```

- Production mode:
```sh
docker compose -f docker-compose.production.yml up
```
Considerations:

- Ensure you have the necessary tools installed (Flutter, Node.js, Docker, etc.).
- Refer to the official documentation of each tool for more information.
- This README is a general guide, you can adapt it to your specific needs.
