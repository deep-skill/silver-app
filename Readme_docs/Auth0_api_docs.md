```
    Configuracion Auth0 

    Usamos la libreria  express-oauth2-jwt-bearer
        -express-oauth2-jwt-bearer : link https://www.npmjs.com/package/express-oauth2-jwt-bearer

    Variables usadas:
        -AUDIENCE = Se obtiene en Aplications / Express API / APIs , API Identifier: "debe coincidir con este campo". Se usa para pedir token de seguridad
        -ISSUERBASEURL = Se obtiene en Aplications / silverapp / Settings , primer menu Domain 
        -TOKENSIGNINGALG = Configuracion de Token

```

```
    Implementacion  

    const {auth} = require('express-oauth2-jwt-bearer');
    const { AUDIENCE, ISSUERBASEURL, TOKENSIGNINGALG } = process.env

    const jwtCheck = auth({
        audience: `${AUDIENCE}`,
        issuerBaseURL: `${ISSUERBASEURL}`,
        tokenSigningAlg: `${TOKENSIGNINGALG}`
    });

    module.exports = jwtCheck;

    Guardamos en una constante auth() 
        -audience : se introduce ruta pera solicitar token
        -issuerBaseURL : se introduce ruta de dominio 
        -tokenSigningAlg : Configuracion de Token

    Ejemplo proteccion de ruta:
        TripRouter.get("/admin-history", (1) jwtCheck, (2) requiredScopes('admin'), getTripsHistory);

    (1) Se llama a la a jwtCheck 
    (2) se llama a requiredScopes('ingreso rool requerido para ingresar') 
    

```