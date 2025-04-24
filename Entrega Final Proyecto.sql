
create database DBFusionMusical
go

use DBFusionMusical
go


/*
**********************************
            TABLAS 
**********************************
*/

-- 1. Tabla TCategorías
CREATE TABLE TCategorias (
    id_categoria INT PRIMARY KEY IDENTITY(1,1), 
    nombre VARCHAR(100) UNIQUE NOT NULL
)

-- 2. Tabla TProveedores
CREATE TABLE TProveedores (
    id_proveedor INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) UNIQUE NOT NULL,
    direccion VARCHAR(MAX),
    telefono VARCHAR(20),
    contacto_principal VARCHAR(100)
)

-- 3. Tabla TClientes
CREATE TABLE TClientes (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(MAX),
    contacto VARCHAR(50)
)

-- 4. Tabla TTipoAcceso
CREATE TABLE TTipoAcceso (
	id_TipoAcceso VARCHAR(100) PRIMARY KEY,
	nombreAcceso VARCHAR(100) NOT NULL
)

-- 5. Productos (requiere id_categoria)
CREATE TABLE TProductos (
    id_producto INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion VARCHAR(MAX),
    precio DECIMAL(10,2) NOT NULL,
    id_categoria INT NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_categoria) REFERENCES TCategorias(id_categoria)
)

-- 6. Usuarios (requiere clientes y tipo de acceso)
CREATE TABLE TUsuarios (
	id_usuario INT PRIMARY KEY IDENTITY(1,1),
	id_cliente INT NOT NULL,
	id_TipoAcceso VARCHAR(100) NOT NULL,
	usuario VARCHAR(50) UNIQUE NOT NULL,
	clave VARCHAR(100) NOT NULL,
	FOREIGN KEY (id_cliente) REFERENCES TClientes(id_cliente),
	FOREIGN KEY (id_TipoAcceso) REFERENCES TTipoAcceso(id_TipoAcceso)
)

-- 7. Compras y detalle
CREATE TABLE TCompras (
    id_compra INT PRIMARY KEY IDENTITY(1,1),
    id_proveedor INT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES TProveedores(id_proveedor)
)

CREATE TABLE TDetalle_Compras (
    id_detalle_compra INT PRIMARY KEY IDENTITY(1,1),
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    costo DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES TCompras(id_compra),
    FOREIGN KEY (id_producto) REFERENCES TProductos(id_producto)
)

-- 8. Ventas y detalle
CREATE TABLE TVentas (
    id_venta INT PRIMARY KEY IDENTITY(1,1),
    id_cliente INT NOT NULL,
    fecha DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (id_cliente) REFERENCES TClientes(id_cliente)
)

CREATE TABLE TDetalle_Ventas (
    id_detalle_venta INT PRIMARY KEY IDENTITY(1,1),
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_venta DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES TVentas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES TProductos(id_producto)
)

/*
********************************************************************
                   IMPLEMENTACIÓN DE LOS ÍNDICES 
********************************************************************
*/

-- Índices en TProductos
CREATE NONCLUSTERED INDEX IX_TProductos_id_categoria ON TProductos(id_categoria);

-- Índices en TDetalle_Compras
CREATE NONCLUSTERED INDEX IX_TDetalle_Compras_id_compra ON TDetalle_Compras(id_compra);
CREATE NONCLUSTERED INDEX IX_TDetalle_Compras_id_producto ON TDetalle_Compras(id_producto);

-- Índices en TDetalle_Ventas
CREATE NONCLUSTERED INDEX IX_TDetalle_Ventas_id_venta ON TDetalle_Ventas(id_venta);
CREATE NONCLUSTERED INDEX IX_TDetalle_Ventas_id_producto ON TDetalle_Ventas(id_producto);

-- Índices en TVentas y TCompras
CREATE NONCLUSTERED INDEX IX_TVentas_id_cliente ON TVentas(id_cliente);
CREATE NONCLUSTERED INDEX IX_TCompras_id_proveedor ON TCompras(id_proveedor);

-- Índices en TUsuarios
CREATE NONCLUSTERED INDEX IX_TUsuarios_usuario ON TUsuarios(usuario);

/*
********************************************************************
                   LLENADO DE LAS TABLAS 
********************************************************************
*/

--TABLA TCATEGORIAS
INSERT INTO TCategorias (nombre) VALUES
('Instrumentos de cuerda'),
('Instrumentos de viento'),
('Instrumentos de percusión'),
('Accesorios'),
('Equipos de audio'),
('Micrófonos'),
('Cables'),
('Amplificadores'),
('Teclados'),
('Partituras');

--TABLA TPROVEEDORES
INSERT INTO TProveedores (nombre, direccion, telefono, contacto_principal) VALUES
('Music Pro', 'San José, CR', '2222-1111', 'Carlos Ramírez'),
('Sonido Total', 'Alajuela, CR', '2433-2233', 'Ana López'),
('AudioPlus', 'Cartago, CR', '2555-3344', 'Mario Brenes'),
('Música Ya', 'Heredia, CR', '2299-7788', 'Sofía Herrera'),
('DoReMi SA', 'Puntarenas, CR', '2666-8899', 'Juan Mora'),
('Ritmo S.A.', 'San José', '8888-1234', 'Laura Quirós'),
('BeatStore', 'Cartago', '8974-5566', 'José Araya'),
('StereoMAX', 'San Ramón', '2456-9988', 'Nuria Cruz'),
('StageGear', 'Liberia', '2678-1122', 'Allan Delgado'),
('Musitec', 'Perez Zeledón', '2788-3344', 'Felipe Solís');

--TABLA TPRODUCTOS
INSERT INTO TProductos (nombre, descripcion, precio, id_categoria, stock) VALUES
('Guitarra acústica', 'Instrumento de cuerda', 120000, 1, 15),
('Flauta dulce', 'Instrumento de viento básico', 8000, 2, 50),
('Batería acústica', 'Set completo', 300000, 3, 5),
('Soporte de guitarra', 'Accesorio para guitarra', 9000, 4, 20),
('Parlante JBL', 'Equipo de audio profesional', 200000, 5, 8),
('Micrófono Shure', 'Micrófono dinámico', 75000, 6, 12),
('Cable XLR', 'Cable de audio profesional', 5000, 7, 100),
('Amplificador Fender', 'Para guitarra eléctrica', 180000, 8, 7),
('Teclado Yamaha', 'Teclado de 61 teclas', 250000, 9, 10),
('Libro de partituras', 'Partituras clásicas', 15000, 10, 25);

--TABLA TCLIENTES
INSERT INTO TClientes (nombre, direccion, contacto) VALUES
('Luis Pérez', 'San José centro', 'luisp@gmail.com'),
('María Torres', 'Heredia centro', 'mtorres@hotmail.com'),
('Carlos Jiménez', 'Alajuela', 'cj1985@gmail.com'),
('Sofía Vargas', 'Desamparados', 'sofiav@hotmail.com'),
('Jorge Muñoz', 'Cartago', 'jmuñoz@gmail.com'),
('Karla Rojas', 'San Ramón', 'krojas@correo.com'),
('José Araya', 'Liberia', 'jaraya@yahoo.com'),
('Daniela Castro', 'Puntarenas', 'dcastro@gmail.com'),
('Mauricio León', 'Curridabat', 'mleon@gmail.com'),
('Andrea Mora', 'Tibás', 'andreamora@live.com');

--TABLA TTIPOACCESO
INSERT INTO TTipoAcceso (id_TipoAcceso, nombreAcceso) VALUES
('ADM', 'Administrador'),
('VEN', 'Vendedor'),
('BOD', 'Bodeguero'),
('INV', 'Invitado'),
('SOP', 'Soporte'),
('AUD', 'Auditor'),
('MKT', 'Marketing'),
('USR', 'Usuario General'),
('CLI', 'Cliente'),
('DEV', 'Desarrollador');

--TABLA TUSUARIOS
INSERT INTO TUsuarios (id_cliente, id_TipoAcceso, usuario, clave) VALUES
(1, 'ADM', 'lperez', '1234'),
(2, 'VEN', 'mtorres', 'abcd'),
(3, 'BOD', 'cjimenez', 'pass1'),
(4, 'CLI', 'svargas', 'cliente123'),
(5, 'USR', 'jmunoz', 'miClave!'),
(6, 'VEN', 'krojas', 'kpass'),
(7, 'BOD', 'jaraya', 'secure1'),
(8, 'USR', 'dcastro', 'micontra'),
(9, 'INV', 'mleon', 'inv2025'),
(10, 'DEV', 'amora', 'rootDev');

--TABLA TCOMPRAS
INSERT INTO TCompras (id_proveedor, fecha) VALUES
(1, '2024-01-10'),
(2, '2024-01-15'),
(3, '2024-02-01'),
(4, '2024-02-18'),
(5, '2024-03-05'),
(6, '2024-03-10'),
(7, '2024-03-20'),
(8, '2024-04-01'),
(9, '2024-04-05'),
(10, '2024-04-10');

--TABLA TDETALLE_COMPRAS
INSERT INTO TDetalle_Compras (id_compra, id_producto, cantidad, costo) VALUES
(1, 1, 10, 100000),
(2, 2, 20, 7000),
(3, 3, 3, 280000),
(4, 4, 15, 8000),
(5, 5, 5, 190000),
(6, 6, 8, 70000),
(7, 7, 50, 4500),
(8, 8, 4, 170000),
(9, 9, 6, 240000),
(10, 10, 10, 14000);

--TABLA TVENTAS
INSERT INTO TVentas (id_cliente, fecha) VALUES
(1, '2024-03-01'),
(2, '2024-03-05'),
(3, '2024-03-10'),
(4, '2024-03-15'),
(5, '2024-03-20'),
(6, '2024-03-25'),
(7, '2024-03-30'),
(8, '2024-04-01'),
(9, '2024-04-05'),
(10, '2024-04-10');

--TABLA TDETALLE_VENTAS
INSERT INTO TDetalle_Ventas (id_venta, id_producto, cantidad, precio_venta) VALUES
(1, 1, 1, 125000),
(2, 2, 2, 8500),
(3, 3, 1, 310000),
(4, 4, 2, 9500),
(5, 5, 1, 205000),
(6, 6, 1, 77000),
(7, 7, 3, 5500),
(8, 8, 1, 185000),
(9, 9, 1, 260000),
(10, 10, 2, 16000);


/*
********************************************************************
                   FUNCIONES DE TIPO ESCALAR 
********************************************************************
*/

--Función que calcula el valor total del inventario disponible
CREATE FUNCTION FN_ValorTotalInventario()
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2)

    SELECT @total = SUM(precio * stock)
    FROM TProductos

    RETURN ISNULL(@total, 0) -- Devuelve 0 si no hay productos
END

--Ejemplo de uso
SELECT dbo.FN_ValorTotalInventario() AS 'Valor Total del Inventario';


--Función que calcula la cantidad total de productos vendidos entre dos fechas dadas
CREATE FUNCTION FN_TotalProductosVendidos (
    @fechaInicio DATE, --Parámetro de fecha inicial
    @fechaFin DATE     --Parámetro de fecha final
)
RETURNS INT
AS
BEGIN
    DECLARE @total INT

    --Suma todas las cantidades vendidas dentro del rango de fechas
    SELECT @total = SUM(DV.cantidad)
    FROM TVentas V
    JOIN TDetalle_Ventas DV ON V.id_venta = DV.id_venta --Se une con TDetalle_Ventas usando el id_venta para sumar las cantidades
    WHERE V.fecha BETWEEN @fechaInicio AND @fechaFin

    RETURN ISNULL(@total, 0) --Devuelve 0 si no hay resultados
END

--Ejemplo de uso
SELECT dbo.FN_TotalProductosVendidos('2024-03-01', '2024-03-31') AS 'Total Vendidos Marzo';
SELECT dbo.FN_TotalProductosVendidos('2024-04-01', '2024-04-30') AS 'Total Vendidos Abril';

/*
********************************************************************
                   FUNCIONES DE TIPO TABLA 
********************************************************************
*/

--Función que devuelve el producto que pertenezca a X categoría 
CREATE FUNCTION fn_ProductosPorCategoria (@id_categoria INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        P.id_producto,
        P.nombre AS 'Nombre Producto',
        P.descripcion AS 'Descripción',
        P.precio AS 'Precio Producto',
        P.stock AS 'Stock Producto',
        C.nombre AS 'Nombre Categoría'
    FROM TProductos P
    JOIN TCategorias C ON P.id_categoria = C.id_categoria
    WHERE P.id_categoria = @id_categoria
);

-- Cambiar el número por otra categoría
SELECT * FROM dbo.fn_ProductosPorCategoria(3);  


--Función que devuelve las ventas realizadas por X cliente 
CREATE FUNCTION fn_DetalleVentasPorCliente (@id_cliente INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        V.id_venta AS 'ID Venta',
        V.fecha AS 'Fecha Venta',
        P.nombre AS Producto,
        DV.cantidad AS Cantidad,
        DV.precio_venta AS 'Precio Venta',
        (DV.cantidad * DV.precio_venta) AS Total
    FROM TVentas V
    JOIN TDetalle_Ventas DV ON V.id_venta = DV.id_venta
    JOIN TProductos P ON DV.id_producto = P.id_producto
    WHERE V.id_cliente = @id_cliente
);

-- Cambiar el ID por otro cliente
SELECT * FROM dbo.fn_DetalleVentasPorCliente(3);  

--Función que devuelve los productos con un stock menor al mínimo especificado
CREATE FUNCTION fn_ProductosConStockBajo (@stockMinimo INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        id_producto,
        nombre AS 'Nombre Producto',
        stock AS 'Stock Actual'
    FROM TProductos
    WHERE stock < @stockMinimo
);

--Ejemplo de uso: Productos con menos de 10 unidades en stock
SELECT * FROM dbo.fn_ProductosConStockBajo(8);

/*
********************************************************************
                             VISTAS 
********************************************************************
*/

--Muestra todas las ventas con datos del cliente y fecha.
CREATE VIEW VW_VentasClientes AS
SELECT 
    V.id_venta AS 'ID Venta',
    V.fecha AS 'Fecha Venta',
    C.nombre AS Cliente,
    P.nombre AS Producto,
    DV.cantidad AS Cantidad,
    DV.precio_venta AS 'Precio Venta',
    (DV.cantidad * DV.precio_venta) AS Total
FROM TVentas V
JOIN TClientes C ON V.id_cliente = C.id_cliente --Se une con TClientes usando id_cliente para obtener el nombre del cliente que realizó la venta.
JOIN TDetalle_Ventas DV ON V.id_venta = DV.id_venta --Se une con TDetalle_Ventas usando id_venta para obtener el detalle de productos vendidos, cantidad y precio.
JOIN TProductos P ON DV.id_producto = P.id_producto; --Se une con TProductos usando id_producto para obtener el nombre del producto vendido.

SELECT * FROM VW_VentasClientes;

--Vista que muestra los productos junto a su categoría y stock actual
CREATE VIEW VW_ProductosConCategoria AS
SELECT 
    P.id_producto AS 'ID Producto',
    P.nombre AS 'Nombre Producto',
    C.nombre AS 'Categoría',
    P.stock AS 'Stock Actual'
FROM TProductos P
JOIN TCategorias C ON P.id_categoria = C.id_categoria; --Se une con TCategorias usando id_categoria para mostrar el nombre de cada uno

SELECT * FROM VW_ProductosConCategoria;

--Vista que muestra las compras realizadas por proveedor y fecha
CREATE VIEW VW_ComprasPorProveedorFecha AS
SELECT 
    C.id_compra AS 'ID Compra',
    C.fecha AS 'Fecha Compra',
    P.nombre AS 'Proveedor',
    PR.nombre AS 'Producto',
    DC.cantidad AS 'Cantidad',
    DC.costo AS 'Costo Unitario',
    (DC.cantidad * DC.costo) AS 'Total'
FROM TCompras C
JOIN TProveedores P ON C.id_proveedor = P.id_proveedor --Se une con TProveedores usando id_compra para traerse los datos del proveedor 
JOIN TDetalle_Compras DC ON C.id_compra = DC.id_compra --Se une con TDetalle_Compras usando id_compra para trerse la cantidad y costo 
JOIN TProductos PR ON DC.id_producto = PR.id_producto; --Se une con TProductos usando id_producto para traerse los datos de ese producto 

SELECT * FROM VW_ComprasPorProveedorFecha;


--Muestra los usuarios registrados en el sistema con sus respectivos tipos de acceso y datos de cliente.
CREATE VIEW VW_UsuariosSistema AS
SELECT 
    U.id_usuario AS 'ID Usuario',
    U.usuario AS Usuario,
    U.clave AS Clave,
    C.nombre AS 'Nombre Cliente',
    TA.nombreAcceso AS 'Tipo Acceso'
FROM TUsuarios U
JOIN TClientes C ON U.id_cliente = C.id_cliente --Se une con TClientes usando id_cliente para obtener el nombre del cliente asociado al usuario.
JOIN TTipoAcceso TA ON U.id_TipoAcceso = TA.id_TipoAcceso; --Se une con TTipoAcceso usando id_TipoAcceso para mostrar el tipo de acceso del usuario.

SELECT * FROM VW_UsuariosSistema;

/*
********************************************************************
                     PROCEDIMIENTOS ALMACENADOS
********************************************************************
*/

--Procedimiento para listar las ventas asociadas a un ID de un cliente 
CREATE PROCEDURE SP_ListarVentasPorCliente
    @id_cliente INT
AS
BEGIN
    SELECT 
        V.id_venta,
        V.fecha,
        P.nombre AS producto,
        DV.cantidad,
        DV.precio_venta,
        (DV.cantidad * DV.precio_venta) AS total_linea
    FROM TVentas V
    JOIN TDetalle_Ventas DV ON V.id_venta = DV.id_venta
    JOIN TProductos P ON DV.id_producto = P.id_producto
    WHERE V.id_cliente = @id_cliente;
END

EXEC SP_ListarVentasPorCliente @id_cliente = 2;

--Procedimiento para registrar una venta (inserta en TVentas y TDetalle_Ventas)
CREATE PROCEDURE SP_RegistrarVenta
    @id_cliente INT,
    @id_producto INT,
    @cantidad INT,
    @precio DECIMAL(10,2)
AS
BEGIN
    DECLARE @id_venta INT

    --Registrar la venta
    INSERT INTO TVentas (id_cliente, fecha)
    VALUES (@id_cliente, GETDATE())

    SET @id_venta = SCOPE_IDENTITY() --Obtiene el ID generado por el identity despúes del insert 

    --Registrar el detalle de la venta
    INSERT INTO TDetalle_Ventas (id_venta, id_producto, cantidad, precio_venta)
    VALUES (@id_venta, @id_producto, @cantidad, @precio)
END

--Ejemplo de Prueba
EXEC SP_RegistrarVenta 
    @id_cliente = 3, 
    @id_producto = 5, 
    @cantidad = 2, 
    @precio = 120000;


--Procedimiento para registrar una compra (inserta en TCompras y TDetalle_Compras)
CREATE PROCEDURE SP_RegistrarCompra
    @id_proveedor INT,
    @id_producto INT,
    @cantidad INT,
    @costo DECIMAL(10,2)
AS
BEGIN
    DECLARE @id_compra INT

    --Registrar la compra
    INSERT INTO TCompras (id_proveedor, fecha)
    VALUES (@id_proveedor, GETDATE())

    SET @id_compra = SCOPE_IDENTITY() --Obtiene el ID generado por el identity despúes del insert 

    --Registrar el detalle de la compra
    INSERT INTO TDetalle_Compras (id_compra, id_producto, cantidad, costo)
    VALUES (@id_compra, @id_producto, @cantidad, @costo)
END


--Ejemplo de Prueba
EXEC SP_RegistrarCompra 
    @id_proveedor = 2, 
    @id_producto = 6, 
    @cantidad = 8, 
    @costo = 105000;


/*
********************************************************************
                             TRIGGERS
********************************************************************
*/

--Aumenta el stock de los productos
CREATE TRIGGER TRG_AumentarStock_Compra
ON TDetalle_Compras
AFTER INSERT
AS
BEGIN
    UPDATE TProductos
    SET stock = stock + I.cantidad
    FROM TProductos P
    JOIN inserted I ON P.id_producto = I.id_producto;
END

--Disminuye el stock de los productos
CREATE TRIGGER TRG_DisminuirStock_Venta2
ON TDetalle_Ventas
AFTER INSERT
AS
BEGIN
    UPDATE TProductos
    SET stock = stock - I.cantidad
    FROM inserted I 
    WHERE TProductos.id_producto = I.id_producto
END
