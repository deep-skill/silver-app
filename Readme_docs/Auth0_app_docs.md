```
    AUTH0 

        Para la implementacion usamos la libreria:
            -auth0_flutter ^1.2.1: link https://pub.dev/packages/auth0_flutter

        En la carpeta lib/auth0 tenemos el archivo:
            -auth0.dart , se configura el front del login

        En la carpeta lib/providers tenemos el archivo:
            -auth0_provider.dart , se realizan las configuraciones necesarias
            
        Tambien hay que tener en cuenta en lib/config/dio el archivo:
            -dio_request.dart donde configuramos dio para agregar el token de seguridad

        La implementacion necesita 5 variables de entonrno que se ecuentran en el archivo .env:

        -AUTH0_DOMAIN= Se obtiene en Aplications / silverapp / Settings , primer menu Domain  

        -AUTH0_CLIENT_ID= Se obtiene en Aplications / silverapp / Settings , primer menu Client ID

        -AUTH0_CUSTOM_SCHEME= Se obtiene en Aplications / silverapp / Settings , menu Application URIs debe conincidir con lo completado en el campo

        -APP_AUDIENCE= Se obtiene en Aplications / Express API / APIs ,  API Identifier: "debe coincidir con este campo". Se usa para pedir token de seguridad

        -APP_REDIRECT_URL= Dirreccion de retorno para el inicio y cierre de sesion ,Se obtiene en Aplications / silverapp / Settings , menu Application URIs debe conincidir con lo completado en el campo

```

```
    En la carpeta lib/providers tenemos el archivo:
            -auth0_provider.dart 


    En este archivo primero configuramos: 
        -auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
        cargamos los datos para la conexion con auth0 ingresando el AUTH0_DOMAIN y 

    Funcion login():
        return auth0Web.loginWithRedirect(
            redirectUrl: '${dotenv.env['APP_REDIRECT_URL']}',
            audience: '${dotenv.env['APP_AUDIENCE']}',
            scopes: {'openid', 'profile', 'email', 'admin', 'driver', 'user'},)

        propiedades:
            -redirectUrl: Dirrecion cargada en auth0 para volver despues del login/logout
            -sudience: Ruta de la Api para obtener el token
            -scopres: ingresa permisos a agregar en el token

    Funcion logout():

        caso Web:
        await auth0Web.logout(returnToUrl: '${dotenv.env['APP_REDIRECT_URL']}');
            -returnToUrl: ruta para el cierre de sesion redirige a direccion http indicada en web

        caso App:
        await auth0
            .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
            .logout();
            -scheme: manda al inicio de la aplicacion despues de cerrar sesion

```

```
    Configuracion Dio con token de seguridad:

    Funcion const dio = getDio;

    Dio getDio(String accessToken) {
    return Dio(BaseOptions(
        baseUrl: '${dotenv.env['HTTP_REQUEST']}',
        headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
        }));
    }

    (1) Credentials? credentials = ref.watch(authProvider).credentials;
    
    (2) final response = await dio(credentials!.accessToken).get('reserves/admin-reserves/$id');

    Para realizar una peticion a la Api hay que pedir al authProvider el token de usuario (1) y agregarlo a la funcion dio (2)
    HTTP_REQUEST es la variable que se encuentra en el archivo .env donde se encuntra alojada la Api
 
```