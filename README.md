# Kiosco AU

Sistema de autoatención y turnero para Autoconsa. Permite a los clientes registrar su llegada, obtener un turno y recibir notificación por WhatsApp — sin intervención del personal. La pantalla de turnero se despliega en una TV y muestra la cola en tiempo real junto con publicidad de la agencia.

---

## Plataformas objetivo

| Plataforma | Rol principal |
|---|---|
| Android TV | Turnero (pantalla pública) |
| Android tablet / teléfono | Kiosco de **autoatención** |
| Windows | Kiosco o guardia (escritorio) |

---

## Roles

La app arranca en `/loading`, lee la sesión guardada en Isar y redirige según el rol configurado.

| Rol | Ruta inicial | Descripción |
|---|---|---|
| `kiosco` | `/ingresar-ruc` | Cliente ingresa RUC/cédula, busca cita y obtiene turno |
| `turnero` | `/pantalla-turnos` | Pantalla grande, muestra cola + publicidad |
| `guardia` | `/guardia` | El guardia registra llegadas y genera turnos manuales |

Si no hay sesión guardada, la app va a `/config` para que el administrador la configure.

---

## Stack técnico

| Capa | Librería | Versión |
|---|---|---|
| UI | Flutter | 3.41.2 |
| Lenguaje | Dart | 3.11.0+ |
| Estado | flutter_riverpod | 3.2.1 |
| Navegación | go_router | 17.1.0 |
| HTTP | dio | 5.9.1 |
| Persistencia local | isar_community | 3.3.2 |
| Video | media_kit | 1.2.0 |
| Audio (TTS) | audioplayers | 6.6.0 |
| Variables de entorno | flutter_dotenv | 6.0.0 |
| Fuente | Montserrat | variable |

---

## Arquitectura

Clean Architecture en tres capas:

```
domain/          → entidades, repositorios abstractos, requests/responses
infrastructure/  → implementaciones de repositorios, datasources HTTP, mappers
presentation/    → screens, widgets, providers (Riverpod)
config/          → router, tema, constantes, validadores, env
```

### Decisiones clave

- **`FutureProvider.family`** — cachea resultados por parámetro. Si el widget se recrea, Riverpod devuelve el valor en memoria sin llamar a la API. Esto aplica especialmente a `turneroMediaProvider` (imágenes/videos publicitarios).
- **`StateNotifierProvider`** — para estado mutable como la sesión activa (`appSessionProvider`) y la cola de turnos (`clienteSiacProvider`).
- **`autoDispose`** — los providers efímeros se limpian cuando ningún widget los observa.
- **`KioskIdleDetector`** — widget que envuelve cada pantalla del kiosco y redirige a `/ingresar-ruc` si el usuario no interactúa en el tiempo configurado.

---

## Configuración — archivo `.env`

El archivo `.env` está en la raíz del proyecto y se empaqueta dentro del APK/exe. Nunca lo subas con credenciales reales a un repositorio público.

```env
# URL base de la API (cambiar cuando ngrok reinicie)
API_BASE_URL=https://<subdominio>.ngrok-free.dev/api/v1

# Nombre visible de la app
NOMBRE_APP=Kiosco AU

# Servidor TTS (text-to-speech local)
TTS_URL=http://192.168.0.194:8000/tts/
TTS_VOICE=es-EC-AndreaNeural
TTS_RATE=+0%
TTS_PITCH=+0Hz

# Retorno automático al inicio si el usuario no interactúa
# Poner en false durante desarrollo para no interrumpir pruebas
RETORNO_AUTOMATICO=true
```

### Tiempos de inactividad (KioskIdleDetector)

| Pantalla | Tiempo |
|---|---|
| home, tipo_atencion, ingresar_ruc | 10 segundos |
| turno_asignado | 15 segundos |

Cuando `RETORNO_AUTOMATICO=false` el detector queda completamente desactivado.

### Actualizar la URL de ngrok

Cuando ngrok reinicia cambia el subdominio. Solo editar la línea `API_BASE_URL` en `.env` y recompilar (o reinstalar en TV).

---

## Ejecutar en desarrollo

### Requisitos previos

- Flutter 3.41.2 (`flutter --version`)
- Android Studio con SDK instalado
- `adb` disponible en PATH o en `C:\Users\<usuario>\AppData\Local\Android\Sdk\platform-tools\`

### Instalar dependencias

```bash
flutter pub get
```

### Android (teléfono / tablet)

Con un dispositivo físico o emulador Android normal conectado:

```bash
flutter run
```

### Windows

```bash
flutter run -d windows
```

### Android TV — emulador

Flutter 3.41.2 no reconoce los emuladores de Android TV como dispositivo válido para `flutter run`. El flujo correcto es compilar el APK y desplegarlo manualmente con `adb`.

**1. Compilar el APK de debug**

```bash
flutter build apk --debug
```

El APK queda en:
```
build\app\outputs\flutter-apk\app-debug.apk
```

**2. Ver dispositivos conectados**

```bash
adb devices
```

Si hay más de un dispositivo (ej. celular + emulador TV), usar `-s <id>` para apuntar al correcto. El emulador aparece como `emulator-5554`.

**3. Instalar y lanzar**

```bash
# Si solo hay un dispositivo/emulador:
adb install -r build\app\outputs\flutter-apk\app-debug.apk
adb shell am start -n com.example.kiosco_au/com.example.kiosco_au.MainActivity

# Si hay celular y emulador TV al mismo tiempo (usar -s con el ID de adb devices):
adb -s emulator-5554 install -r build\app\outputs\flutter-apk\app-debug.apk
adb -s emulator-5554 shell am start -n com.example.kiosco_au/com.example.kiosco_au.MainActivity
```

**4. Flujo completo — un solo dispositivo (copiar y pegar)**

```bash
flutter build apk --debug && adb install -r build\app\outputs\flutter-apk\app-debug.apk && adb shell am start -n com.example.kiosco_au/com.example.kiosco_au.MainActivity
```

**4b. Flujo completo — TV emulador con celular también conectado**

```bash
flutter build apk --debug && adb -s emulator-5554 install -r build\app\outputs\flutter-apk\app-debug.apk && adb -s emulator-5554 shell am start -n com.example.kiosco_au/com.example.kiosco_au.MainActivity
```

> El emulador de Android TV recomendado es **API 33** (Android 13). Las versiones API 34+ pueden dar problemas de compatibilidad con algunas librerías nativas (media_kit).

**5. Ver logs en tiempo real**

```bash
adb -s emulator-5554 logcat -s flutter
```

---

## Generación de código

### Isar — modelos de base de datos local

Cuando se modifica `AppSessionConfig` u otra entidad marcada con `@Collection`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Ícono de la app

El ícono se configura en `pubspec.yaml` (sección `flutter_launcher_icons`) y la imagen fuente está en `assets/icons/icon.png`.

Para regenerar los íconos en todas las plataformas:

```bash
dart run flutter_launcher_icons
```

---

## Estructura de carpetas

```
kiosco_au/
├── .env                          # Variables de entorno (no commitear con datos reales)
├── assets/
│   ├── fonts/                    # Montserrat
│   ├── icons/                    # icon.png (fuente para flutter_launcher_icons)
│   └── img/                      # Imágenes estáticas de la app
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml   # LEANBACK_LAUNCHER para Android TV
└── lib/
    ├── main.dart
    ├── config/
    │   ├── app_constants.dart    # AppDurations, AppBreakpoints
    │   ├── app_validators.dart   # normalizarTelefono, telefonoEcuatoriano, formatearTipoTurno
    │   ├── env.dart              # Carga variables del .env (Env.apiBaseUrl, etc.)
    │   ├── config.dart           # Barrel de config/
    │   ├── theme/                # AppTheme, GuardiaTheme
    │   └── router/app_router.dart
    ├── domain/
    │   ├── entities/             # AppSessionConfig, Turno, TurneroMedia, Cita, etc.
    │   ├── repositories/         # Interfaces abstractas
    │   ├── datasources/          # Interfaces abstractas
    │   ├── requests/
    │   └── response/
    ├── infrastructure/
    │   ├── datasources/          # KioscoDatasourceImpl (Dio), IsarDatasource
    │   ├── repositories/         # KioscoRepositoryImpl, LocalStorageRepositoryImpl
    │   └── mappers/
    └── presentation/
        ├── providers/
        │   ├── data/             # agenciaProvider, citasProvider, turneroMediaProvider
        │   ├── turnos/           # pantallaTurnosProvider (refresh cada 10s)
        │   ├── db/               # appSessionProvider (Isar)
        │   ├── repositories/     # kioscoRepositoryProvider
        │   └── theme/            # themeProvider
        ├── screens/
        │   ├── config/           # ConfigScreen, CloseSessionScreen
        │   ├── guard/            # GuardiaScreen
        │   ├── home/             # HomeScreen, TallerServicioScreen
        │   ├── kiosco/           # TipoAtencionScreen, BienvenidaUsuarioScreen
        │   ├── loading/          # LoadingScreen (bootstrap y redirección por rol)
        │   ├── placa/            # IngresarPlacaScreen
        │   ├── ruc/              # IngresarRucScreen (pantalla inicial del kiosco)
        │   └── turnos/           # TurneroWaitingScreen, TurnoAsignadoScreen
        └── widgets/
            ├── kiosk/            # KioskIdleDetector
            ├── turnero/          # TurneroAdPlaceholder, TurneroHeader, etc.
            ├── guardia/          # GuardiaBody, GuardiaAcciones
            ├── whatsapp/         # WhatsappTurnoNotificacion
            └── hidden_admin_access/ # Acceso oculto a /config (toque largo en esquina)
```

---

## Notas de Android TV

- El `AndroidManifest.xml` incluye `LEANBACK_LAUNCHER` para que la app aparezca en el launcher de TV.
- `android.hardware.touchscreen` marcado como `required="false"` para que la app funcione sin pantalla táctil.
- La navegación con D-pad está soportada: los botones focusables muestran un borde animado al recibir foco.
- El video en `TurneroAdPlaceholder` usa `enableHardwareAcceleration: false` para evitar errores de contexto de hardware en el emulador.
