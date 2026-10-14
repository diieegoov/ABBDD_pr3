CREATE SCHEMA IF NOT EXISTS "public";

---------------------------------------------------
---                  TABLAS PADRE               ---
---------------------------------------------------

CREATE TABLE "public".zona ( 
	id_zona              serial  NOT NULL  ,
	latitud              real    ,
	longitud             real    ,
	CONSTRAINT pk_tbl_0 PRIMARY KEY ( id_zona )
 );

CREATE TABLE "public".puesto ( 
	id_puesto            serial  NOT NULL  ,
	nombre_puesto        varchar(100)    ,
	CONSTRAINT pk_tbl_3 PRIMARY KEY ( id_puesto )
 );

CREATE TABLE "public".cliente ( 
	id_cliente           serial  NOT NULL  ,
	CONSTRAINT pk_tbl_5 PRIMARY KEY ( id_cliente )
 );

---------------------------------------------------
---            TABLAS CON DEPENDENCIAS          ---
---------------------------------------------------

CREATE TABLE "public".vivero ( 
	id_vivero            serial  NOT NULL  ,
	id_zona              integer    ,
	latitud              real    ,
	longitud             real    ,
	CONSTRAINT pk_tbl PRIMARY KEY ( id_vivero ),
	CONSTRAINT unq_vivero_id_zona UNIQUE ( id_zona ) ,
    CONSTRAINT fk_vivero_zona FOREIGN KEY ( id_zona ) REFERENCES "public".zona( id_zona )
 );

CREATE TABLE "public".empleado ( 
	id_empleado          serial  NOT NULL  ,
	id_vivero            integer    ,
	nombre               varchar(100)  NOT NULL  ,
	apellido             varchar(100)    ,
	CONSTRAINT pk_tbl_2 PRIMARY KEY ( id_empleado ),
	CONSTRAINT fk_empleado_vivero FOREIGN KEY ( id_vivero ) REFERENCES "public".vivero( id_vivero )   
 );

CREATE TABLE "public".bonificacion ( 
	id_bonificacion      serial  NOT NULL  ,
	id_cliente           integer    ,
	nombre_cliente       varchar(100)    ,
	apellido_cliente     varchar(100)    ,
	descuento            numeric(5,2)    ,
	CONSTRAINT pk_tbl_6 PRIMARY KEY ( id_bonificacion ),
	CONSTRAINT fk_bonificacion_cliente FOREIGN KEY ( id_cliente ) REFERENCES "public".cliente( id_cliente )   
 );

CREATE TABLE "public".cliente_plus ( 
	id_cliente           integer    ,
	nombre               varchar(100)    ,
	fecha_ingreso        date    ,
	volumen_compra_mes   numeric(10,2)    ,
	CONSTRAINT fk_cliente_plus_cliente_plus FOREIGN KEY ( id_cliente ) REFERENCES "public".cliente( id_cliente )   
 );

CREATE TABLE "public".pedido ( 
	id_pedido            serial  NOT NULL  ,
	id_empleado          integer    ,
	id_cliente           integer    ,
	importe              real    ,
	CONSTRAINT pk_pedido PRIMARY KEY ( id_pedido ),
	CONSTRAINT fk_pedido_cliente FOREIGN KEY ( id_cliente ) REFERENCES "public".cliente( id_cliente )   
 );

CREATE TABLE "public".producto ( 
	id_producto          serial  NOT NULL  ,
	id_zona              integer    ,
	id_empleado          integer    ,
	CONSTRAINT pk_tbl_1 PRIMARY KEY ( id_producto )
 );

CREATE TABLE "public".detalle_pedido ( 
	id_pedido            integer    ,
	id_producto          integer    ,
	cantidad_producto    integer    ,
	CONSTRAINT fk_detalle_pedido_pedido FOREIGN KEY ( id_pedido ) REFERENCES "public".pedido( id_pedido )   ,
	CONSTRAINT fk_detalle_pedido_producto FOREIGN KEY ( id_producto ) REFERENCES "public".producto( id_producto )   
 );

CREATE TABLE "public".historial_destino ( 
	id_historial         serial  NOT NULL  ,
	id_empleado          integer    ,
	fecha_inicio         date    ,
	fecha_fin            date    ,
	productividad        numeric(5,2)    ,
	id_puesto            integer    ,
	id_vivero            integer    ,
	CONSTRAINT pk_historial_destino PRIMARY KEY ( id_historial ),
	CONSTRAINT fk_historial_destino_empleado FOREIGN KEY ( id_empleado ) REFERENCES "public".empleado( id_empleado )   ,
	CONSTRAINT fk_historial_destino_puesto FOREIGN KEY ( id_puesto ) REFERENCES "public".puesto( id_puesto )   ,
	CONSTRAINT fk_historial_destino_vivero FOREIGN KEY ( id_vivero ) REFERENCES "public".vivero( id_vivero )   
 );

CREATE TABLE "public".tarea ( 
	id_tarea             serial  NOT NULL  ,
	id_empleado          integer    ,
	descripcion          text    ,
	CONSTRAINT pk_tbl_4 PRIMARY KEY ( id_tarea ),
	CONSTRAINT fk_tarea_empleado FOREIGN KEY ( id_empleado ) REFERENCES "public".empleado( id_empleado )   
 );

CREATE TABLE "public".stock ( 
	id_producto          integer    ,
	id_zona              integer    ,
	cantidad_disponible  integer    ,
	CONSTRAINT fk_stock_producto FOREIGN KEY ( id_producto ) REFERENCES "public".producto( id_producto )   ,
	CONSTRAINT fk_stock_zona FOREIGN KEY ( id_zona ) REFERENCES "public".zona( id_zona )   
 );

---------------------------------------------------
---                 INSERTS                     ---
---------------------------------------------------

INSERT INTO zona (id_zona, latitud, longitud) VALUES (1, 28.48, -16.31), (2, 28.49, -16.32), (3, 28.50, -16.33), (4, 28.51, -16.34), (5, 28.52, -16.35);
INSERT INTO puesto (id_puesto, nombre_puesto) VALUES (1, 'Gerente'), (2, 'Supervisor'), (3, 'Operario'), (4, 'Técnico'), (5, 'Administrativo');
INSERT INTO cliente (id_cliente) VALUES (1), (2), (3), (4), (5);

INSERT INTO vivero (id_vivero, id_zona, latitud, longitud) VALUES (1, 1, 28.48, -16.31), (2, 2, 28.49, -16.32), (3, 3, 28.50, -16.33), (4, 4, 28.51, -16.34), (5, 5, 28.52, -16.35);
INSERT INTO empleado (id_empleado, id_vivero, nombre, apellido) VALUES (1, 1, 'Carlos', 'Ruiz'), (2, 2, 'Elena', 'Martín'), (3, 3, 'Jorge', 'Alonso'), (4, 4, 'Lucía', 'Blanco'), (5, 5, 'David', 'Romero');

INSERT INTO cliente_plus (id_cliente, nombre, fecha_ingreso, volumen_compra_mes) VALUES (1, 'Ana', '2023-01-15', 1500.50), (2, 'Juan', '2023-02-20', 2300.00), (3, 'Luis', '2023-03-10', 800.75), (4, 'Maria', '2023-04-05', 3200.00), (5, 'Pedro', '2023-05-12', 4100.25);
INSERT INTO bonificacion (id_bonificacion, id_cliente, nombre_cliente, apellido_cliente, descuento) VALUES (1, 1, 'Ana', 'García', 10), (2, 2, 'Juan', 'Pérez', 15), (3, 3, 'Luis', 'López', 5), (4, 4, 'Maria', 'Gómez', 20), (5, 5, 'Pedro', 'Díaz', 25);

INSERT INTO producto (id_producto, id_zona, id_empleado) VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5);
INSERT INTO stock (id_producto, id_zona, cantidad_disponible) VALUES (1, 1, 150), (2, 2, 300), (3, 3, 50), (4, 4, 420), (5, 5, 110);
INSERT INTO pedido (id_pedido, id_empleado, id_cliente, importe) VALUES (1, 1, 1, 125.50), (2, 2, 2, 340.00), (3, 3, 3, 50.25), (4, 4, 4, 980.00), (5, 5, 5, 210.75);
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad_producto) VALUES (1, 1, 5), (2, 2, 12), (3, 3, 2), (4, 4, 50), (5, 5, 8);

INSERT INTO tarea (id_tarea, id_empleado, descripcion) VALUES (1, 1, 'Mantenimiento de riego'), (2, 2, 'Abonado de cítricos'), (3, 3, 'Control de plagas'), (4, 4, 'Preparación de pedidos'), (5, 5, 'Inventario mensual');
INSERT INTO historial_destino (id_historial, id_empleado, fecha_inicio, fecha_fin, productividad, id_puesto, id_vivero) VALUES (1, 1, '2022-01-01', '2022-12-31', 85, 3, 1), (2, 2, '2022-02-01', '2022-11-30', 90, 3, 2), (3, 3, '2022-03-01', '2022-10-31', 88, 3, 3), (4, 4, '2022-04-01', '2022-09-30', 95, 3, 4), (5, 5, '2022-05-01', '2022-08-31', 82, 3, 5);