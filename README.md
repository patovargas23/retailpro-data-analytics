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
