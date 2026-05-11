-- =============================================================
--  DB LIBRERÍA
--  Script de creación de esquema y restricciones
--  Compatibilidad: MySQL 8+ / MariaDB 10.5+
--  Generado: 2025
-- =============================================================

CREATE DATABASE IF NOT EXISTS dblibreria
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE dblibreria;

-- -------------------------------------------------------------
-- 1. IDIOMA
-- -------------------------------------------------------------
CREATE TABLE idioma (
    id          INT             NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(80)     NOT NULL,
    codigo_ISO  CHAR(5)         NOT NULL,
    CONSTRAINT pk_idioma        PRIMARY KEY (id),
    CONSTRAINT uq_idioma_iso    UNIQUE (codigo_ISO)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 2. EDITORIAL
-- -------------------------------------------------------------
CREATE TABLE editorial (
    id          INT             NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(150)    NOT NULL,
    pais        VARCHAR(80),
    contacto    VARCHAR(200),
    sitio_web   VARCHAR(200),
    CONSTRAINT pk_editorial     PRIMARY KEY (id)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 3. AUTOR
-- -------------------------------------------------------------
CREATE TABLE autor (
    id           INT            NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100)   NOT NULL,
    apellido     VARCHAR(100)   NOT NULL,
    nacionalidad VARCHAR(80),
    biografia    TEXT,
    CONSTRAINT pk_autor         PRIMARY KEY (id)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 4. CATEGORIA
-- -------------------------------------------------------------
CREATE TABLE categoria (
    id           INT            NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100)   NOT NULL,
    descripcion  TEXT,
    CONSTRAINT pk_categoria     PRIMARY KEY (id)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 5. LIBRO
-- -------------------------------------------------------------
CREATE TABLE libro (
    id                INT             NOT NULL AUTO_INCREMENT,
    ISBN              VARCHAR(20)     NOT NULL,
    titulo            VARCHAR(300)    NOT NULL,
    anio_publicacion  SMALLINT,
    precio            DECIMAL(10,2)   NOT NULL,
    stock             INT             NOT NULL DEFAULT 0,
    descripcion       TEXT,
    editorial_id      INT             NOT NULL,
    idioma_id         INT             NOT NULL,
    CONSTRAINT pk_libro             PRIMARY KEY (id),
    CONSTRAINT uq_libro_isbn        UNIQUE (ISBN),
    CONSTRAINT fk_libro_editorial   FOREIGN KEY (editorial_id)
        REFERENCES editorial (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_libro_idioma      FOREIGN KEY (idioma_id)
        REFERENCES idioma (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_libro_precio      CHECK (precio >= 0),
    CONSTRAINT ck_libro_stock       CHECK (stock >= 0)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 6. LIBRO_AUTOR  (tabla puente N:M)
-- -------------------------------------------------------------
CREATE TABLE libro_autor (
    libro_id    INT         NOT NULL,
    autor_id    INT         NOT NULL,
    rol         ENUM('autor','coautor','editor','traductor')
                            NOT NULL DEFAULT 'autor',
    CONSTRAINT pk_libro_autor       PRIMARY KEY (libro_id, autor_id),
    CONSTRAINT fk_lautor_libro      FOREIGN KEY (libro_id)
        REFERENCES libro (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_lautor_autor      FOREIGN KEY (autor_id)
        REFERENCES autor (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 7. LIBRO_CATEGORIA  (tabla puente N:M)
-- -------------------------------------------------------------
CREATE TABLE libro_categoria (
    libro_id        INT     NOT NULL,
    categoria_id    INT     NOT NULL,
    CONSTRAINT pk_libro_categoria   PRIMARY KEY (libro_id, categoria_id),
    CONSTRAINT fk_lcat_libro        FOREIGN KEY (libro_id)
        REFERENCES libro (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_lcat_categoria    FOREIGN KEY (categoria_id)
        REFERENCES categoria (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 8. CLIENTE
-- -------------------------------------------------------------
CREATE TABLE cliente (
    id              INT             NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(100)    NOT NULL,
    apellido        VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL,
    telefono        VARCHAR(20),
    direccion       VARCHAR(300),
    fecha_registro  DATE            NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT pk_cliente       PRIMARY KEY (id),
    CONSTRAINT uq_cliente_email UNIQUE (email)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 9. USUARIO
-- -------------------------------------------------------------
CREATE TABLE usuario (
    id              INT             NOT NULL AUTO_INCREMENT,
    cliente_id      INT,
    username        VARCHAR(60)     NOT NULL,
    password_hash   VARCHAR(255)    NOT NULL,
    rol             ENUM('admin','vendedor','cliente')
                                    NOT NULL DEFAULT 'cliente',
    activo          BOOLEAN         NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_usuario           PRIMARY KEY (id),
    CONSTRAINT uq_usuario_username  UNIQUE (username),
    CONSTRAINT fk_usuario_cliente   FOREIGN KEY (cliente_id)
        REFERENCES cliente (id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 10. PEDIDO
-- -------------------------------------------------------------
CREATE TABLE pedido (
    id              INT             NOT NULL AUTO_INCREMENT,
    cliente_id      INT             NOT NULL,
    numero_pedido   VARCHAR(30)     NOT NULL,
    fecha           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado          ENUM('pendiente','confirmado','enviado',
                         'entregado','cancelado')
                                    NOT NULL DEFAULT 'pendiente',
    total           DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    observaciones   TEXT,
    CONSTRAINT pk_pedido            PRIMARY KEY (id),
    CONSTRAINT uq_pedido_numero     UNIQUE (numero_pedido),
    CONSTRAINT fk_pedido_cliente    FOREIGN KEY (cliente_id)
        REFERENCES cliente (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_pedido_total      CHECK (total >= 0)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 11. DETALLE_PEDIDO
-- -------------------------------------------------------------
CREATE TABLE detalle_pedido (
    id              INT             NOT NULL AUTO_INCREMENT,
    pedido_id       INT             NOT NULL,
    libro_id        INT             NOT NULL,
    cantidad        INT             NOT NULL,
    precio_unitario DECIMAL(10,2)   NOT NULL,
    subtotal        DECIMAL(12,2)   NOT NULL,
    CONSTRAINT pk_detalle_pedido        PRIMARY KEY (id),
    CONSTRAINT fk_dpedido_pedido        FOREIGN KEY (pedido_id)
        REFERENCES pedido (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_dpedido_libro         FOREIGN KEY (libro_id)
        REFERENCES libro (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_dpedido_cantidad      CHECK (cantidad > 0),
    CONSTRAINT ck_dpedido_precio        CHECK (precio_unitario >= 0)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 12. PAGO
-- -------------------------------------------------------------
CREATE TABLE pago (
    id          INT             NOT NULL AUTO_INCREMENT,
    pedido_id   INT             NOT NULL,
    metodo      ENUM('efectivo','tarjeta','transferencia','OXXO')
                                NOT NULL,
    monto       DECIMAL(12,2)   NOT NULL,
    fecha       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    referencia  VARCHAR(100),
    estatus     ENUM('pendiente','aprobado','rechazado','reembolsado')
                                NOT NULL DEFAULT 'pendiente',
    CONSTRAINT pk_pago              PRIMARY KEY (id),
    CONSTRAINT fk_pago_pedido       FOREIGN KEY (pedido_id)
        REFERENCES pedido (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_pago_monto        CHECK (monto > 0)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 13. PROVEEDOR
-- -------------------------------------------------------------
CREATE TABLE proveedor (
    id                  INT             NOT NULL AUTO_INCREMENT,
    nombre              VARCHAR(150)    NOT NULL,
    RFC                 VARCHAR(15),
    contacto            VARCHAR(200),
    condiciones_pago    VARCHAR(100),
    CONSTRAINT pk_proveedor     PRIMARY KEY (id),
    CONSTRAINT uq_proveedor_rfc UNIQUE (RFC)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 14. COMPRA
-- -------------------------------------------------------------
CREATE TABLE compra (
    id              INT             NOT NULL AUTO_INCREMENT,
    proveedor_id    INT             NOT NULL,
    fecha           DATE            NOT NULL,
    total           DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    estatus         ENUM('solicitada','recibida','cancelada')
                                    NOT NULL DEFAULT 'solicitada',
    CONSTRAINT pk_compra            PRIMARY KEY (id),
    CONSTRAINT fk_compra_proveedor  FOREIGN KEY (proveedor_id)
        REFERENCES proveedor (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_compra_total      CHECK (total >= 0)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- 15. DETALLE_COMPRA
-- -------------------------------------------------------------
CREATE TABLE detalle_compra (
    id              INT             NOT NULL AUTO_INCREMENT,
    compra_id       INT             NOT NULL,
    libro_id        INT             NOT NULL,
    cantidad        INT             NOT NULL,
    precio_costo    DECIMAL(10,2)   NOT NULL,
    subtotal        DECIMAL(12,2)   NOT NULL,
    CONSTRAINT pk_detalle_compra        PRIMARY KEY (id),
    CONSTRAINT fk_dcompra_compra        FOREIGN KEY (compra_id)
        REFERENCES compra (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_dcompra_libro         FOREIGN KEY (libro_id)
        REFERENCES libro (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_dcompra_cantidad      CHECK (cantidad > 0),
    CONSTRAINT ck_dcompra_precio        CHECK (precio_costo >= 0)
) ENGINE=InnoDB;

-- =============================================================
--  ÍNDICES ADICIONALES (rendimiento en consultas frecuentes)
-- =============================================================
CREATE INDEX idx_libro_titulo       ON libro (titulo);
CREATE INDEX idx_libro_editorial    ON libro (editorial_id);
CREATE INDEX idx_pedido_cliente     ON pedido (cliente_id);
CREATE INDEX idx_pedido_estado      ON pedido (estado);
CREATE INDEX idx_pago_pedido        ON pago (pedido_id);
CREATE INDEX idx_detpedido_pedido   ON detalle_pedido (pedido_id);
CREATE INDEX idx_detpedido_libro    ON detalle_pedido (libro_id);
CREATE INDEX idx_compra_proveedor   ON compra (proveedor_id);
CREATE INDEX idx_detcompra_compra   ON detalle_compra (compra_id);

-- =============================================================
--  DATOS DE CATÁLOGO INICIAL
-- =============================================================

INSERT INTO idioma (nombre, codigo_ISO) VALUES
    ('Español',  'es'),
    ('Inglés',   'en'),
    ('Francés',  'fr'),
    ('Alemán',   'de'),
    ('Portugués','pt');

INSERT INTO categoria (nombre) VALUES
    ('Literatura'),
    ('Ciencia ficción'),
    ('Historia'),
    ('Tecnología'),
    ('Infantil'),
    ('Biografía'),
    ('Filosofía'),
    ('Economía');

-- =============================================================
--  FIN DEL SCRIPT
-- =============================================================
