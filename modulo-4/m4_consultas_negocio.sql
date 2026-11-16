-- Motor utilizado: PostgreSQL 17 (pgAdmin 4)
-- Pre-entrega 4 - Consultas SQL de negocio - Patricio Vargas
-- Base: Ventas_Tech_DB (la del Módulo 3). Solo uso la tabla ventas.
-- Como es PostgreSQL, uso EXTRACT(MONTH FROM ...) en vez de MONTH() y LIMIT 5 en vez de TOP 5.


-- CONSULTA 1: Resumen ejecutivo mensual
-- Todas las ventas cargadas son de marzo 2024, así que devuelve una sola fila.
SELECT
    EXTRACT(MONTH FROM fecha_venta)            AS mes,
    SUM(cantidad * precio_unitario)            AS total_facturado,
    COUNT(id_venta)                            AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2)  AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;


-- CONSULTA 2: Ranking de productos (Top 5)
SELECT
    id_producto,
    SUM(cantidad)                   AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;


-- CONSULTA 3: Clientes recurrentes
SELECT
    id_cliente,
    COUNT(*)                        AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- CONSULTA 4: Productos por encima / por debajo del promedio
-- Primero saco el total por producto y después lo comparo contra el promedio
-- de esos totales (no contra el promedio de las filas de ventas).
WITH totales_producto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales_producto) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion
FROM totales_producto
ORDER BY total_facturado DESC;


-- HALLAZGOS
-- 1. El producto 1 (Laptop Pro 15) concentra el 55,9% de lo facturado en marzo (3.600 de 6.444).
--    Junto con el producto 3 (Monitor 4K) suman el 77%, y son los únicos dos por encima del
--    promedio por producto (1.074). Si falta stock de esos dos, se cae casi toda la facturación.
-- 2. Los 5 clientes compraron 2 veces cada uno, así que la consulta 3 devuelve a todos. Pero el
--    gasto está muy desparejo: el cliente 1 gastó 2.640 (41% del total) y el cliente 4 solo 510.
--    Conviene cuidar a los clientes 1 y 5, que entre los dos son el 74% de la facturación.
-- 3. El producto 2 (Mouse) es el que más unidades vende (13) pero factura solo 364, quinto en el
--    ranking. El producto 4 (Auriculares) queda afuera del Top 5 por 4 pesos (360). Se podrían
--    armar combos de mouse y auriculares con las laptops para subir el ticket promedio (644,40).

