-- Motor utilizado: PostgreSQL 17 (pgAdmin 4)
-- Pre-entrega 5 - Consultas con JOINs - Patricio Vargas
-- Base: Ventas_Tech_DB (la del Módulo 3).
-- Tablas: ventas, clientes, productos y categorias (categorias es una tabla aparte,
-- unida a productos por productos.id_categoria -> categorias.id_categoria).


-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Junta cada venta con su cliente, su producto y la categoría del producto.
-- Es la fuente principal para Power BI: clientes.ciudad sirve para agrupar
-- y categorias.nombre_categoria para filtrar.
SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre                         AS cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario   AS total_venta
FROM ventas v
INNER JOIN clientes   c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  p   ON v.id_producto  = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;
-- Hallazgo: las 10 ventas cruzan sin perder filas, así que todas tienen cliente, producto y categoría válidos.
-- Computación (Laptop Pro 15 y Monitor 4K 27) concentra la mayor parte de v.cantidad * v.precio_unitario.


-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Para CRM: clientes registrados que todavía no tienen ninguna fila en ventas.
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
-- Hallazgo: aparecieron 0 registros. Los 5 clientes de la tabla clientes tienen al menos una venta,
-- así que por ahora CRM no tiene clientes inactivos para una campaña de primera compra.


-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Para el área de producto: artículos del catálogo sin ninguna venta registrada.
SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v        ON p.id_producto  = v.id_producto
WHERE v.id_venta IS NULL;
-- Hallazgo: aparecieron 0 registros. Los 6 productos tienen movimiento,
-- así que el área de producto no tiene artículos sin rotación para revisar o discontinuar.


-- CONSULTA 4: Consolidado por canal (UNION ALL)
-- La columna origen no existe en las tablas: la creo como texto fijo en cada SELECT.
-- Separo las ventas por quincena de marzo 2024 según v.fecha_venta.
SELECT
    origen,
    COUNT(*)           AS cantidad_ventas,
    SUM(total_venta)   AS total_facturado
FROM (
    SELECT 'Primera quincena' AS origen,
           v.cantidad * v.precio_unitario AS total_venta
    FROM ventas v
    WHERE v.fecha_venta BETWEEN '2024-03-01' AND '2024-03-10'

    UNION ALL

    SELECT 'Segunda quincena' AS origen,
           v.cantidad * v.precio_unitario AS total_venta
    FROM ventas v
    WHERE v.fecha_venta BETWEEN '2024-03-11' AND '2024-03-31'
) AS consolidado
GROUP BY origen
ORDER BY total_facturado DESC;
-- Hallazgo: la primera quincena facturó 3.620 contra 2.824 de la segunda, con 5 ventas cada una.
-- La diferencia viene de la venta de 2 Laptop Pro 15 del 5/3, que sola suma 2.400.
