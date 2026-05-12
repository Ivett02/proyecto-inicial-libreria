# 📘 Plan de Implementación: "Librería: Tinta & Hojas"
> *Nota preliminar:* "Antigravity" no corresponde a un IDE oficial para Flutter. Se recomienda **VS Code** como entorno principal, complementado con las extensiones oficiales de Flutter/Dart y Firebase. El plan está estructurado para ser **multiplataforma** (Android, iOS, Web, Windows/macOS/Linux si se desea).

---

## 🛠️ 1. Herramientas y Entorno de Desarrollo
| Categoría | Herramienta Recomendada |
|-----------|------------------------|
| **Editor** | VS Code (con extensiones: `Flutter`, `Dart`, `Firebase`, `Error Lens`, `Pubspec Assist`, `Pretty JSON`) |
| **SDK** | Flutter SDK ≥ `3.22` (rama estable), Dart SDK ≥ `3.4` |
| **Control de versiones** | Git + GitHub/GitLab/Bitbucket |
| **Diseño/Prototipado** | Figma (diseño de pantalla, paleta, componentes, handoff) |
| **Pruebas locales** | Firebase Local Emulator Suite, emuladores Android/iOS, navegador Chrome |
| **CLI** | Flutter CLI, Firebase CLI (`flutterfire configure`) |
| **CI/CD (opcional)** | Codemagic, GitHub Actions, Fastlane |

---

## 🏗️ 2. Arquitectura y Gestión de Estado
- **Patrón base:** `MVVM` simplificado o `Feature-First` con capas claras:
  - `Presentation` (UI + Widgets)
  - `Logic` (Providers + Controladores de estado)
  - `Data` (Repositorios, servicios Firebase, DTOs)
  - `Domain` (Entidades puras, casos de uso)
- **State Management:** `Provider` como núcleo.
  - `ChangeNotifierProvider` para estado global (usuario autenticado, tema, carrito)
  - `Consumer` para reconstrucción selectiva de widgets
  - Evitar anidamiento excesivo; usar `MultiProvider` en `main.dart`
- **Navegación:** `go_router` para enrutamiento declarado, protección de rutas y deep linking.
- **Estructura de carpetas sugerida:**
  ```
  lib/
  ├── core/ (temas, constantes, utilidades, enrutador)
  ├── features/
  │   ├── auth/
  │   ├── catalog/
  │   ├── book_detail/
  │   ├── profile/
  │   └── cart/
  ├── models/
  ├── repositories/
  └── main.dart
  ```

---

## 🎨 3. Diseño UI/UX
- **Identidad visual:** Paleta inspirada en papel, tinta y madera suave. Tipografía serif para títulos (elegancia literaria) + sans-serif para cuerpo (legibilidad).
- **Sistema de diseño:**
  - Componentes reutilizables: `BookCard`, `PrimaryButton`, `SearchBar`, `FormField`, `EmptyState`, `LoadingOverlay`
  - Temas: `ThemeData` claro/oscuro con `Brightness`
  - Espaciado: escala de 4px/8px
- **UX Principles:**
  - Feedback inmediato en acciones (snackbars, skeletons, pull-to-refresh)
  - Estados vacíos y de error con acciones claras
  - Navegación predecible: `Splash → Auth → Home (Catálogo) → Detalle → Perfil/Carrito`
  - Accesibilidad: contraste ≥ 4.5:1, soporte de fuentes dinámicas, etiquetas semánticas
- **Responsive:** Layouts adaptativos (`LayoutBuilder`, `MediaQuery`, `ResponsiveGrid`) para móvil, tablet y web.

---

## 🔥 4. Configuración de Firebase
1. Crear proyecto en Firebase Console con nombre `tinta-hojas`
2. Registrar aplicaciones: Android, iOS, Web (y desktop si aplica)
3. Descargar/colocar archivos de configuración:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - Web: integrar snippet en `web/index.html`
4. Habilitar servicios:
   - **Authentication:** Email/Password
   - **Firestore Database:** Modo de prueba inicial, luego reglas de seguridad basadas en `request.auth`
   - **Storage (opcional):** Para portadas de libros, avatares
5. Ejecutar `flutterfire configure` en la raíz del proyecto para generar `firebase_options.dart`
6. Configurar reglas básicas de Firestore:
   - `users/{userId}`: solo lectura/escritura por el mismo `uid`
   - `books`: lectura pública, escritura solo admin
   - `orders`: solo propietario puede ver/modificar

---

## 📦 5. Dependencias (`pubspec.yaml`)
*(Solo listado conceptual. Se usarán versiones `^` estables al momento de la implementación)*
```yaml
dependencies:
  flutter:
    sdk: flutter
  # Firebase
  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest
  # State & Routing
  provider: ^latest
  go_router: ^latest
  # UI/UX Utilities
  cached_network_image: ^latest
  flutter_spinkit: ^latest
  intl: ^latest
  formz: ^latest
  # Dev/Tooling
  flutter_lints: ^latest

dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^latest
  build_runner: ^latest
```
> ✅ *Nota:* Ejecutar `flutter pub get` y `flutterfire configure` antes de compilar.

---

## 📋 6. Plan de Implementación Paso a Paso

### 🔹 Fase 1: Configuración Inicial
1. Crear proyecto Flutter: `flutter create libreria_tinta_hojas --platforms android,ios,web`
2. Configurar `pubspec.yaml` con las dependencias base
3. Ejecutar `flutterfire configure` y vincular Firebase
4. Estructurar carpetas según arquitectura definida
5. Configurar `go_router` básico con rutas: `/`, `/login`, `/register`, `/home`
6. Implementar `main.dart` con `MultiProvider` (Auth, Theme, Router)

### 🔹 Fase 2: Autenticación (Email/Password)
1. Crear servicios: `AuthService` con `firebase_auth`
2. Implementar `AuthProvider` (ChangeNotifier) que exponga:
   - `user`, `isLoading`, `errorMessage`, `isAuthenticated`
   - Métodos: `signIn()`, `signUp()`, `signOut()`, `resetPassword()`
3. Diseñar pantallas: `LoginScreen`, `RegisterScreen`
4. Validar formularios (email formato, contraseña ≥8 chars, confirmación)
5. Proteger rutas con `go_router.redirect`: si no autenticado → `/login`
6. Manejar estados de carga, errores de Firebase y persistencia de sesión automática

### 🔹 Fase 3: Modelos y Base de Datos (Firestore)
1. Definir entidades Dart: `Book`, `User`, `Order`, `CartItem`
2. Crear `BookRepository` con operaciones CRUD: `fetchBooks()`, `getBookById()`, `searchBooks()`
3. Estructurar Firestore:
   - Colección `books`: `{id, title, author, price, isbn, coverUrl, stock, category, rating}`
   - Colección `users`: `{id, email, displayName, role, wishlist, cart}`
4. Implementar paginación (`startAfterDocument`) y búsqueda por categoría/título
5. Habilitar `FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true)` para offline básico
6. Añadir `BookProvider` para gestionar lista, filtros y estado de carga

### 🔹 Fase 4: UI Principal y Navegación
1. Diseñar `HomeScreen` con:
   - AppBar con búsqueda y acceso a perfil
   - `GridView` o `ListView` de `BookCard`
   - Filtros por categoría, precio, popularidad
2. Implementar `BookDetailScreen` con:
   - Portada, metadatos, descripción, botón "Añadir al carrito"
   - Estado de stock y reseñas (si aplica)
3. Configurar navegación fluida con `go_router` y transiciones suaves
4. Aplicar tema global: tipografía, colores, sombras, bordes redondeados
5. Añadir `EmptyState` y `ErrorState` reutilizables

### 🔹 Fase 5: Integración Lógica-UI
1. Conectar `AuthProvider` y `BookProvider` a las pantallas mediante `Consumer`/`Provider.of`
2. Implementar flujo completo: registro → login → catálogo → detalle → acción
3. Manejar estados asíncronos: `FutureBuilder` o `StreamProvider` según necesidad
4. Añadir manejo de errores centralizado (snackbars, diálogos, logs)
5. Optimizar reconstrucciones: usar `select` en Provider, evitar `setState` innecesario

### 🔹 Fase 6: Optimización y Preparación Multiplataforma
1. Configurar iconos, splash screen y metadatos por plataforma
2. Ajustar layout para web (sidebar, grids más amplios) y escritorio
3. Implementar gestión de permisos y archivos de configuración nativos
4. Añadir logging estructurado y métricas básicas (Firebase Analytics opcional)
5. Revisar reglas de seguridad de Firestore antes de pasar a producción

---

## ✅ 7. Pruebas y Despliegue
- **Pruebas unitarias:** `AuthService`, `BookRepository`, validaciones
- **Pruebas de widget:** `LoginScreen`, `BookCard`, flujos de navegación
- **Pruebas de integración:** Emuladores Firebase (Auth + Firestore)
- **Builds:**
  - Android: `flutter build apk --release` / `appbundle`
  - iOS: `flutter build ipa` (requiere Mac + certificado Apple)
  - Web: `flutter build web --web-renderer canvaskit`
- **Distribución:** Firebase App Distribution, Play Console, App Store Connect, Firebase Hosting (web)

---

## 🚀 Siguientes Pasos
1. ✅ Validar y ajustar este plan a tus preferencias (ej. añadir carrito, reseñas, panel admin)
2. 📝 Confirmar fase por la que deseas comenzar a generar código
3. 💡 Recibiré el código modular, documentado y listo para copiar/pegar, con explicaciones de arquitectura y mejores prácticas

> ⚠️ *Este plan excluye código a propósito, tal como solicitaste. Cuando estés listo, indícame la fase objetivo y generaré la implementación correspondiente con estructura, buenas prácticas de Flutter/Firebase y comentarios técnicos.*
