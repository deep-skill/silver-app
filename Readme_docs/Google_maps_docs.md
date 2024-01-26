``` 
GOOGLE MAPS
	Para la implementacion usamos las librerias:
		-google_maps_flutter: ^2.5.3: link https://pub.dev/packages/google_maps_flutter
		-google_maps_flutter_web 0.5.4+3: link https://pub.dev/packages/google_maps_flutter_web

	En la carpeta lib/google_maps tenemos dos archivos:
		- google_maps_screen.dart
		- location_data.dart

	La implementacion nececita de un api key generada en Google Console. Esta key esta guardada en el archivo .env GOOGLE_MAPS_KEY=
	
```
``` 
Configuracion previa:
	*Android:
		-Set the `minSdkVersion` in `android/app/build.gradle`:
			android {
			    defaultConfig {
			        minSdkVersion 20
			    }
			}
		-Specify your API key in the application manifest `android/app/src/main/AndroidManifest.xml`:

			<manifest ...
			  <application ...
			    <meta-data android:name="com.google.android.geo.API_KEY"
			               android:value="YOUR KEY HERE"/>

	*Web:
		Modify the `<head>` tag of your `web/index.html` to load the Google Maps JavaScript API, like so:
			<head>
			  <!-- // Other stuff -->
			  <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
			</head>
			
```

``` 
En el archivos location_data.dart se encuentra la Class LocationData
	
	class  LocationData {
		final  double  latitude;
		final  double  longitude;
		final  String  address;

		LocationData({
		required  this.latitude,
		required  this.longitude,
		required  this.address,
		});
}

```

```

En el archivo google_maps_screen.dart tenemos la screen en la que se implementa google maps:
	
	La constante 
		static  const  CameraPosition  _kGooglePlex  =  CameraPosition(
		target:  LatLng(-12.04967738829701, -77.09668506723912),
		zoom:  kIsWeb  ?  17.0  :  15.00,);

	Esta constante guarda CamaraPosition()
		-target: recibe un atributo LatLng para indicar la posicion inicial de la camara. En este caso se usa una cordenada de Lima Peru.  
		-zoom: configura el zoom de la camara inicial para web se usa 17 y movil 15.

	La función _searchAndNavigate(String  address)
		Recibe la dirección ingresada en el buscador:
			-verifica que el dato ingresado no sea un string vació.
			-realiza una petición usando dio a 'https://maps.googleapis.com/maps/api/geocode/json'
				parametros ingresados:
					-address : dato a buscar
					-components: filtra resultados posibles a Lima Peru ingresando 'locality:Lima|country:PE'
					-key: se agrega api key para la peticion
					
		En caso de peticion correcta guarda los resultados y los muestra. En caso contrario guarda un array vacio y no muestra el contenedor de resultados.

	La función _updateMapLocation(LatLng  location, String  addressName)
		Recibe la Lat y Log del resultado de _searchAndNavigate:
			-Agrega selectedLocation '${location.latitude}, ${location.longitude}, $addressName'
			-usa _markers para limpiar y redirigir el mapa a la dirección indicada.

	Cuando selectedLocation es distinto de null 
		Mostramos por pantalla un Container que contiene el boton 'Confirmar Ubicación', con el cual confirmamos la busqueda. Y nos retorna a la  ventana anterior cargando los resultados de la busqueda. 
	
 ```
