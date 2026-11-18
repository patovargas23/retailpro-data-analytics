# RetailPro - Data Analytics (Coderhouse)

Patricio Vargas

Motor: PostgreSQL 17 (pgAdmin 4)

Base: Ventas_Tech_DB

## Pre-entrega 3 - Creación de la base

Script: `modulo-3/ventas_tech_db.sql`

- Crea las tablas categorias, clientes, productos y ventas con sus PK y FK
- Carga datos de ejemplo
- Al final tiene SELECT de validación (4, 5, 6 y 10 filas)

Para correrlo: crear la base Ventas_Tech_DB en pgAdmin, abrir el Query Tool y ejecutar el script.

## Pre-entrega 4 - Consultas SQL de negocio

Script: `modulo-4/m4_consultas_negocio.sql`

Usa la misma base del módulo 3 (solo la tabla ventas). Tiene 4 consultas:

1. Resumen ejecutivo mensual: facturación, cantidad de pedidos y ticket promedio
2. Top 5 productos por facturación
3. Clientes recurrentes (más de un pedido)
4. Productos por encima o por debajo del promedio de facturación (con CTE y CASE)

Como es PostgreSQL usé EXTRACT(MONTH FROM ...) en vez de MONTH() y LIMIT 5 en vez de TOP 5.

Hallazgos principales (están comentados al final del script):

- La Laptop Pro 15 y el Monitor 4K suman el 77% de lo facturado en marzo
- Los 5 clientes compraron 2 veces, pero los clientes 1 y 5 concentran el 74% de la facturación
- El Mouse es lo que más unidades vende pero factura poco: se podrían armar combos con las laptops

Para correrlo: tener creada la base del módulo 3, abrir el Query Tool sobre Ventas_Tech_DB y ejecutar el script.

## Pre-entrega 5 - Consultas con JOINs

Script: `modulo-5/m5_consultas_joins.sql`

Usa la misma base del módulo 3 y cruza las 4 tablas. Tiene 4 consultas:

1. Vista base (INNER JOIN): une ventas con clientes por `id_cliente`, con productos por `id_producto` y con categorias por `id_categoria`. Calcula `total_venta` como `cantidad * precio_unitario`. Es la fuente para Power BI: `clientes.ciudad` para agrupar y `categorias.nombre_categoria` para filtrar
2. Clientes sin ventas (LEFT JOIN con IS NULL): muestra `nombre`, `email` y `fecha_registro` de los clientes que no tienen filas en ventas
3. Productos sin ventas (LEFT JOIN con IS NULL): muestra `nombre_producto`, `nombre_categoria` y `precio` de los productos que no tienen filas en ventas
4. Consolidado por canal (UNION ALL): la columna `origen` no está en las tablas, la creo como texto fijo y separo las ventas por quincena de marzo según `fecha_venta`

Hallazgos principales (están comentados debajo de cada consulta):

- Las 10 ventas cruzan sin perder filas y Computación es la categoría que más factura
- No hay clientes ni productos sin ventas: los 5 clientes compraron y los 6 productos tuvieron movimiento
- La primera quincena facturó 3.620 contra 2.824 de la segunda, por la venta de 2 Laptop Pro 15 del 5/3

Para correrlo: tener creada la base del módulo 3, abrir el Query Tool sobre Ventas_Tech_DB y ejecutar el script.
