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

```plaintext id="rxnqco"
lib/
├── nucleo/
│   ├── configuracion/       # Configuración dev/staging, constantes y rutas
│   ├── tema/                # ThemeData, paleta vino/beige, tipografías
│   ├── utilidades/          # Validadores, helpers y formatos
│   └── servicios/           # Firebase init y Storage service
├── funcionalidades/
│   ├── autenticacion/       # Login, registro y recuperación
│   ├── libros/              # Catálogo, filtros, búsqueda y detalles
│   ├── carrito/             # Gestión del carrito y totales
│   ├── confirmacion_compra/ # Checkout y pedidos
│   ├── administracion/      # CRUD administrativo
│   ├── perfil/              # Perfil e historial
│   └── resenas/             # Comentarios y calificaciones
├── compartido/
│   ├── componentes/         # Botones, cards, inputs y diálogos
│   ├── modelos/             # Entidades Dart
│   └── proveedores_estado/  # Providers globales
└── main.dart

assets/
├── fonts/
├── images/
└── icons/
```

---

# 📚 2. Mapeo Relacional → Firestore (NoSQL)

| Entidad SQL       | Adaptación Firestore       | Estrategia                      |
| ----------------- | -------------------------- | ------------------------------- |
| `IDIOMA`          | Colección `idiomas`        | Catálogo de idiomas disponibles |
| `EDITORIAL`       | Colección `editoriales`    | Empresas editoriales            |
| `AUTOR`           | Colección `autores`        | Información de autores          |
| `CATEGORIA`       | Colección `categorias`     | Géneros y categorías            |
| `LIBRO`           | Colección `libros`         | Entidad principal               |
| `LIBRO_AUTOR`     | Array `autorIds`           | Relación muchos a muchos        |
| `LIBRO_CATEGORIA` | Array `categoriaIds`       | Relación muchos a muchos        |
| `CLIENTE`         | Colección `usuarios`       | Clientes registrados            |
| `USUARIO`         | Firebase Auth + `usuarios` | Control de acceso               |
| `PEDIDO`          | Colección `pedidos`        | Historial de compras            |
| `DETALLE_PEDIDO`  | Array `detalles`           | Libros incluidos                |
| `PAGO`            | Campo embebido `pago`      | Información de pago             |
| `PROVEEDOR`       | Colección `proveedores`    | Distribuidores                  |
| `COMPRA`          | Colección `compras`        | Reabastecimiento                |
| `DETALLE_COMPRA`  | Array `detallesCompra`     | Productos comprados             |

---

# 🔐 3. Autenticación y Control de Acceso (RBAC)

| Paso | Acción                              | Entregable        |
| ---- | ----------------------------------- | ----------------- |
| 3.1  | Registro/Login con Firebase Auth    | Flujo funcional   |
| 3.2  | Roles `admin` y `cliente`           | Claims y permisos |
| 3.3  | Protección de rutas con `go_router` | Navegación segura |
| 3.4  | Reglas Firestore                    | Seguridad por rol |
| 3.5  | Persistencia de sesión              | Login persistente |

---

# 📊 4. Gestión de Estado con Provider

| Provider          | Responsabilidad                  |
| ----------------- | -------------------------------- |
| `AuthProvider`    | Login, registro, perfil y logout |
| `LibroProvider`   | Catálogo, filtros y búsqueda     |
| `CarritoProvider` | Carrito y cálculos               |
| `PedidoProvider`  | Confirmación y pedidos           |
| `AdminProvider`   | CRUD administrativo              |
| `TemaProvider`    | Tema visual y modo oscuro        |

> Patrón recomendado: `ResultState<T>` → `idle`, `loading`, `success`, `error`.

---

# 🎨 5. UI/UX: Estilo Visual “Tinta & Hojas”

## 🎨 Paleta Principal

| Nombre        | Hex       | Uso                 |
| ------------- | --------- | ------------------- |
| `vinoDark`    | `#5A1E2D` | Header y navegación |
| `vinoPrimary` | `#7B2D42` | Botones principales |
| `vinoSoft`    | `#A05C6B` | Hover y detalles    |
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

```plaintext id="ltdibf"
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

---

# 👤 6. Flujos de Usuario

## Cliente

1. Registro/Login
2. Explorar libros
3. Buscar por género, idioma o autor
4. Ver detalles del libro
5. Agregar al carrito
6. Confirmar compra
7. Consultar historial y favoritos

---

## Administrador

1. Login administrador
2. CRUD libros
3. Gestión de inventario
4. Gestión de categorías y autores
5. Gestión de editoriales y proveedores
6. Visualización de pedidos
7. Moderación de reseñas

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

> ❌ Excluidos: Analytics, Crashlytics y herramientas de producción.

---

# 🧪 8. Pruebas y Validación

| Tipo            | Alcance                   |
| --------------- | ------------------------- |
| Unitarias       | Providers y validadores   |
| Widget          | Componentes reutilizables |
| Integración     | Login → carrito → pedido  |
| Firestore Rules | Seguridad por rol         |
| Responsive      | Android, Web y Windows    |

---

# 📅 9. Roadmap de Desarrollo

| Semana | Objetivo                   |
| ------ | -------------------------- |
| 1      | Setup inicial y estructura |
| 2      | Firebase Auth y roles      |
| 3      | Catálogo y filtros         |
| 4      | Carrito y confirmación     |
| 5      | Panel administrador        |
| 6      | Perfil e historial         |
| 7      | Responsive y optimización  |
| 8      | Documentación final        |

---

# 📚 10. Estructura de Colecciones Firestore

## `libros`

| Campo        | Tipo      |
| ------------ | --------- |
| titulo       | string    |
| descripcion  | string    |
| autorIds     | array     |
| categoriaIds | array     |
| editorialId  | reference |
| idiomaId     | reference |
| precio       | number    |
| stock        | number    |
| portadaUrl   | string    |
| calificacion | number    |
| destacado    | boolean   |
| createdAt    | timestamp |

---

## `autores`

| Campo     | Tipo   |
| --------- | ------ |
| nombre    | string |
| biografia | string |
| fotoUrl   | string |

---

## `categorias`

| Campo  | Tipo   |
| ------ | ------ |
| nombre | string |
| icono  | string |

---

## `editoriales`

| Campo    | Tipo   |
| -------- | ------ |
| nombre   | string |
| pais     | string |
| sitioWeb | string |

---

## `idiomas`

| Campo  | Tipo   |
| ------ | ------ |
| nombre | string |
| codigo | string |

---

## `usuarios`

| Campo     | Tipo      |
| --------- | --------- |
| nombre    | string    |
| correo    | string    |
| rol       | string    |
| telefono  | string    |
| createdAt | timestamp |

---

## `pedidos`

| Campo     | Tipo      |
| --------- | --------- |
| usuarioId | reference |
| detalles  | array     |
| subtotal  | number    |
| total     | number    |
| estado    | string    |
| pago      | map       |
| createdAt | timestamp |

---

## `compras`

| Campo          | Tipo      |
| -------------- | --------- |
| proveedorId    | reference |
| detallesCompra | array     |
| total          | number    |
| fecha          | timestamp |

---

## `proveedores`

| Campo     | Tipo   |
| --------- | ------ |
| nombre    | string |
| telefono  | string |
| correo    | string |
| direccion | string |

---

## `resenas`

Subcolección:
`libros/{id}/resenas`

| Campo        | Tipo      |
| ------------ | --------- |
| usuarioId    | reference |
| comentario   | string    |
| calificacion | number    |
| createdAt    | timestamp |

---

# 🖼️ 11. Concepto Visual General

```plaintext id="xpkcqp"
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
* [ ] Roles admin/cliente definidos
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
