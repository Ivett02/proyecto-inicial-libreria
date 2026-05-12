# 📚 PLAN DE IMPLEMENTACIÓN: “Tinta & Hojas” – Librería Digital Multiplataforma

> **Alcance:** Desarrollo exclusivo para entornos de desarrollo/staging. Sin analíticas, sin Crashlytics y sin despliegue a producción.
> **Plataformas:** Android, iOS, Web y Windows.
> **Roles:** Administrador y Cliente.
> **Gestión de estado:** Provider.
> **Backend:** Firebase (Auth + Firestore + Storage).
> **Concepto visual:** Librería moderna y elegante con estética vino, beige y tonos suaves inspirados en lectura, papelería y creatividad.
> **Sin código en este documento.**

---

# 🏗️ 1. Arquitectura y Estructura de Carpetas (Feature-First)

```plaintext
lib/
├── core/
│   ├── config/          # Configuración dev/staging, constantes, rutas
│   ├── theme/           # ThemeData, paleta vino/beige, tipografías
│   ├── utils/           # Validadores, helpers, formatos de fecha/precio
│   └── services/        # Firebase init, Storage service
├── features/
│   ├── auth/            # Login, registro, recuperación, roles
│   ├── books/           # Libros, géneros, autores, búsqueda y filtros
│   ├── cart/            # Carrito, persistencia y cálculo de totales
│   ├── checkout/        # Pedido, dirección, resumen y confirmación
│   ├── admin/           # CRUD libros, inventario, categorías, pedidos
│   ├── profile/         # Perfil cliente, historial y favoritos
│   └── reviews/         # Comentarios y calificaciones
├── shared/
│   ├── widgets/         # Botones, cards, inputs, diálogos
│   ├── models/          # Entidades Dart
│   └── providers/       # AuthProvider, BookProvider, CartProvider, etc.
└── main.dart            # Punto de entrada

assets/
├── fonts/
├── images/
└── icons/
```

---

# 📚 2. Mapeo Relacional → Firestore (NoSQL)

| Entidad SQL      | Adaptación Firestore                    | Estrategia                              |
| ---------------- | --------------------------------------- | --------------------------------------- |
| `libro`          | Colección `books`                       | Documento principal con datos del libro |
| `categoria`      | Colección `categories`                  | Géneros y categorías literarias         |
| `autor`          | Colección `authors`                     | Información del autor                   |
| `editorial`      | Colección `publishers`                  | Editoriales de libros                   |
| `inventario`     | Campo `stock` dentro de `books`         | Actualización atómica                   |
| `cliente`        | Colección `users`                       | Vinculada a Firebase Auth               |
| `pedido`         | Colección `orders`                      | Detalles embebidos                      |
| `detalle_pedido` | Array `items` dentro de `orders`        | Historial inmutable                     |
| `favoritos`      | Subcolección `users/{uid}/favorites`    | Libros favoritos                        |
| `reseñas`        | Subcolección `books/{id}/reviews`       | Comentarios y puntuaciones              |
| `carrito`        | Persistencia local + Firestore opcional | Sincronización por usuario              |

---

# 🔐 3. Autenticación y Control de Acceso (RBAC)

| Paso | Acción                                 | Entregable        |
| ---- | -------------------------------------- | ----------------- |
| 3.1  | Registro/Login con Firebase Auth       | Flujo funcional   |
| 3.2  | Roles `admin` y `user` mediante claims | Control de acceso |
| 3.3  | Protección de rutas con `go_router`    | Navegación segura |
| 3.4  | Reglas Firestore                       | Seguridad por rol |
| 3.5  | Persistencia de sesión                 | Sesión estable    |

---

# 📊 4. Gestión de Estado con Provider

| Provider           | Responsabilidad                  |
| ------------------ | -------------------------------- |
| `AuthProvider`     | Login, registro, perfil y logout |
| `BookProvider`     | Libros, búsqueda, filtros        |
| `CartProvider`     | Carrito y totales                |
| `CheckoutProvider` | Pedidos y confirmaciones         |
| `AdminProvider`    | CRUD administrativo              |
| `ThemeProvider`    | Tema vino/beige y modo oscuro    |

> Patrón recomendado: `ResultState<T>` → `idle`, `loading`, `success`, `error`.

---

# 🎨 5. UI/UX: Estilo Visual “Tinta & Hojas”

## 🎨 Paleta Principal

| Nombre        | Hex       | Uso                 |
| ------------- | --------- | ------------------- |
| `vinoDark`    | `#5A1E2D` | Header, navegación  |
| `vinoPrimary` | `#7B2D42` | Botones principales |
| `vinoSoft`    | `#A05C6B` | Hover y acentos     |
| `beige`       | `#F5E6D3` | Fondos              |
| `cream`       | `#FFF9F2` | Tarjetas            |
| `textDark`    | `#2E2A27` | Texto principal     |
| `goldSoft`    | `#C8A96B` | Detalles elegantes  |

---

## 🔤 Tipografía

| Uso           | Fuente             | Peso    |
| ------------- | ------------------ | ------- |
| Títulos       | `Playfair Display` | Bold    |
| Texto general | `Inter`            | Regular |
| Botones       | `Inter`            | Medium  |

---

## 🧩 Componentes Visuales

### 📖 Tarjeta de Libro

```plaintext
┌─────────────────────┐
│ [Portada del libro] │
│                     │
│ Título              │
│ Autor               │
│ ⭐ 4.8              │
│ $399 MXN            │
│ [Agregar al carrito]│
└─────────────────────┘
```

### 🛒 Botones

| Tipo       | Estilo                   |
| ---------- | ------------------------ |
| Primario   | Fondo vino, texto blanco |
| Secundario | Beige con borde vino     |
| Disabled   | Gris claro               |

---

# 👤 6. Flujos de Usuario

## Cliente

1. Registro/Login
2. Explorar libros
3. Buscar por género o autor
4. Ver detalle del libro
5. Agregar al carrito
6. Checkout
7. Historial y favoritos

---

## Administrador

1. Login admin
2. CRUD libros
3. Gestión de inventario
4. Gestión de categorías/autores
5. Ver pedidos
6. Gestionar usuarios
7. Moderar reseñas

---

# 📦 7. Dependencias (`pubspec.yaml` - Conceptual)

| Categoría  | Paquetes                                                                |
| ---------- | ----------------------------------------------------------------------- |
| Firebase   | `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` |
| Estado     | `provider`                                                              |
| Routing    | `go_router`                                                             |
| UI         | `google_fonts`, `cached_network_image`, `flutter_svg`                   |
| Utilidades | `shared_preferences`, `intl`, `uuid`, `equatable`, `formz`              |
| Testing    | `flutter_test`, `mocktail`, `integration_test`                          |

> ❌ Excluidos: Analytics, Crashlytics y servicios de producción.

---

# 🧪 8. Pruebas y Validación

| Tipo            | Alcance                        |
| --------------- | ------------------------------ |
| Unitarias       | Providers, validadores         |
| Widget          | Componentes reutilizables      |
| Integración     | Flujo login → carrito → pedido |
| Firestore Rules | Seguridad por rol              |
| Responsive      | Android, Web y Windows         |

---

# 📅 9. Roadmap de Desarrollo

| Semana | Objetivo                         |
| ------ | -------------------------------- |
| 1      | Setup inicial, tema y estructura |
| 2      | Firebase Auth + roles            |
| 3      | Catálogo de libros               |
| 4      | Carrito y checkout               |
| 5      | Panel administrador              |
| 6      | Perfil e historial               |
| 7      | Responsive y optimización        |
| 8      | Documentación y revisión final   |

---

# 📚 10. Estructura Firestore (Colecciones)

## `books`

| Campo       | Tipo      |
| ----------- | --------- |
| title       | string    |
| description | string    |
| authorId    | reference |
| categoryId  | reference |
| publisherId | reference |
| price       | number    |
| stock       | number    |
| imageUrl    | string    |
| rating      | number    |
| isFeatured  | boolean   |
| createdAt   | timestamp |

---

## `authors`

| Campo     | Tipo   |
| --------- | ------ |
| name      | string |
| biography | string |
| photoUrl  | string |

---

## `categories`

| Campo | Tipo   |
| ----- | ------ |
| name  | string |
| icon  | string |

---

## `orders`

| Campo     | Tipo      |
| --------- | --------- |
| userId    | reference |
| items     | array     |
| subtotal  | number    |
| total     | number    |
| status    | string    |
| createdAt | timestamp |

---

## `reviews`

Subcolección:
`books/{id}/reviews`

| Campo     | Tipo      |
| --------- | --------- |
| userId    | reference |
| comment   | string    |
| rating    | number    |
| createdAt | timestamp |

---

# 🖼️ 11. Concepto Visual General

```plaintext
┌─────────────────────────────────┐
│ 📚 Tinta & Hojas      🛒 👤 🔍 │
├─────────────────────────────────┤
│ [ Banner principal elegante ]   │
│ “Descubre nuevas historias”     │
│ [Explorar libros]               │
├─────────────────────────────────┤
│ Géneros                         │
│ [Fantasía] [Romance] [Misterio] │
├─────────────────────────────────┤
│ Libros destacados               │
│ ┌─────┐ ┌─────┐ ┌─────┐         │
│ │📕  │ │📘  │ │📗  │         │
│ │$399│ │$299│ │$450│         │
│ └─────┘ └─────┘ └─────┘         │
└─────────────────────────────────┘
```

---

# ✅ Checklist de Validación

* [ ] Firestore estructurado correctamente
* [ ] Roles admin/user definidos
* [ ] Providers organizados
* [ ] Navegación protegida
* [ ] Tema vino/beige implementado
* [ ] Responsive multiplataforma
* [ ] CRUD funcional
* [ ] Carrito persistente
* [ ] Pruebas básicas completadas
* [ ] Documentación iniciada


PROMPT

Necesito desarrollar una aplicación multiplataforma llamada “Tinta & Hojas”, una librería digital moderna y elegante enfocada en la venta de libros, papelería y artículos creativos. El proyecto será desarrollado únicamente para entornos de desarrollo y staging, sin analíticas, sin Crashlytics y sin despliegue a producción. La aplicación debe funcionar en Android, iOS, Web y Windows utilizando Flutter como framework principal, Firebase como backend y Provider para la gestión de estado. Quiero que la arquitectura esté organizada bajo una estructura feature-first, separando correctamente las funcionalidades como autenticación, catálogo de libros, carrito, checkout, perfil de usuario, panel administrativo y reseñas. También necesito que toda la estructura sea escalable, limpia y preparada para crecer en el futuro.

El sistema debe manejar dos roles principales: administrador y cliente. Los usuarios podrán registrarse e iniciar sesión mediante Firebase Authentication usando correo y contraseña. Los administradores tendrán acceso a un panel donde podrán gestionar libros, categorías, autores, editoriales, inventario, pedidos y usuarios. Los clientes podrán explorar libros, buscar por género o autor, agregar productos al carrito, guardar favoritos, realizar pedidos simulados y consultar su historial de compras. Quiero que el control de acceso se maneje mediante roles y reglas de seguridad en Firestore, asegurando que solo los administradores puedan modificar la información del catálogo y que cada usuario únicamente pueda acceder a sus propios datos.

La aplicación debe utilizar Firestore como base de datos NoSQL. Necesito colecciones para libros, categorías, autores, editoriales, usuarios, pedidos, favoritos y reseñas. Los libros deben incluir información como título, descripción, precio, stock, portada, autor, categoría, editorial y calificación. También quiero que existan subcolecciones para comentarios y favoritos. Los pedidos deben guardar el historial completo de compra y mantener los datos históricos aunque el producto cambie después. El carrito debe poder persistir localmente y sincronizarse con Firestore cuando el usuario esté autenticado.

Visualmente quiero una aplicación con una identidad elegante y cálida inspirada en librerías modernas. La paleta principal debe utilizar tonos vino, beige, crema y algunos detalles dorados suaves. El diseño debe sentirse limpio, moderno y agradable para leer. Quiero usar tipografías elegantes para títulos, como Playfair Display, y una fuente moderna y legible como Inter para textos generales. Las tarjetas de libros deben mostrar la portada, el título, el autor, la calificación y el precio con un diseño atractivo y moderno. También quiero que toda la interfaz sea responsive para adaptarse correctamente a móviles, tablets, escritorio y web.

Necesito que se implementen Providers separados para autenticación, libros, carrito, pedidos, tema y administración, utilizando estados como loading, success y error. También quiero navegación protegida con go_router, manejo adecuado de sesiones y persistencia de login. La aplicación debe incluir validaciones de formularios, mensajes de error claros, loaders modernos y componentes reutilizables como botones personalizados, tarjetas, inputs y diálogos. Además, quiero que todo el sistema esté preparado para pruebas unitarias, pruebas de widgets y pruebas de integración utilizando flutter_test e integration_test.

El catálogo debe permitir búsqueda dinámica, filtros por categorías y visualización de libros destacados. El panel administrativo debe permitir crear, editar y eliminar libros con imágenes almacenadas en Firebase Storage. También quiero que el sistema pueda manejar inventario básico, control de stock y estados de pedidos. Todo el proyecto debe mantenerse organizado, profesional y fácil de entender, con una estructura limpia tanto en frontend como backend.
