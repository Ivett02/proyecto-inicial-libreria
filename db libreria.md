actua como un administrador de base de datos: proyecto libreria, que entidades se necesitan para su gestion

## Entidades para un Sistema de Gestión de Librería

Aquí están las entidades principales organizadas por módulo:

---

### 📚 Catálogo

| Entidad | Atributos clave |
|---|---|
| **Libro** | ISBN, título, año_publicación, precio, stock, descripción |
| **Autor** | nombre, apellido, nacionalidad, biografía |
| **Editorial** | nombre, país, contacto, sitio_web |
| **Categoría** | nombre, descripción |
| **Idioma** | nombre, código_ISO |

---

### 👤 Clientes y Usuarios

| Entidad | Atributos clave |
|---|---|
| **Cliente** | nombre, apellido, email, teléfono, dirección, fecha_registro |
| **Usuario** | username, password_hash, rol, activo |
| **Dirección** | calle, ciudad, estado, CP, país |

---

### 🛒 Ventas y Pedidos

| Entidad | Atributos clave |
|---|---|
| **Pedido** | número_pedido, fecha, estado, total |
| **Detalle_Pedido** | cantidad, precio_unitario, subtotal |
| **Factura** | número_factura, fecha_emisión, RFC, total |
| **Pago** | método, monto, fecha, referencia, estatus |

---

### 🏭 Inventario y Proveedores

| Entidad | Atributos clave |
|---|---|
| **Proveedor** | nombre, RFC, contacto, condiciones_pago |
| **Compra** | fecha, total, estatus |
| **Detalle_Compra** | cantidad, precio_costo, subtotal |
| **Movimiento_Inventario** | tipo (entrada/salida/ajuste), cantidad, fecha, motivo |

---

### 🔁 Relaciones Intermedias (tablas puente)

| Relación | Entidades que conecta |
|---|---|
| **Libro_Autor** | Libro ↔ Autor (un libro puede tener varios autores) |
| **Libro_Categoría** | Libro ↔ Categoría (multietiqueta) |

---

### 🔗 Diagrama de relaciones clave

```
Cliente  ──────< Pedido >────── Detalle_Pedido >──── Libro
                   │                                    │
                Factura                          Libro_Autor ──── Autor
                   │                             Libro_Categoría ─ Categoría
                 Pago                                   │
                                                    Editorial
Proveedor ─────< Compra >────── Detalle_Compra >─── Libro
```

---

### Consideraciones adicionales

- **Reseña / Valoración** — si se quiere permitir que clientes califiquen libros
- **Lista_Deseos** — para e-commerce
- **Cupón / Descuento** — promociones aplicables a pedidos o libros
- **Devolución** — gestión de libros devueltos

¿Quieres que genere el **DDL completo en SQL**, el **diagrama ER** visual, o profundizamos en algún módulo específico?
<img width="680" height="781" alt="image" src="https://github.com/user-attachments/assets/3afde8e7-9859-4fe3-b2a5-a04487030bb4" />


### las entidades con sus atributos y tipo en forma de tabla para cada una de las entidades

<img width="1440" height="7996" alt="image" src="https://github.com/user-attachments/assets/effc404c-6994-4f19-9a62-f1215e998717" />

## de acuerdo a tu respuesta anterior puedes generar un script en sql para descargar con el nombre de dblibreria.sql para las 10 entidades y sus relaciones
