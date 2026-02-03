-- 1. vw_sales_daily: Ventas diarias y ticket promedio
-- Grain: 1 fila por día
-- Métricas: total_ventas, tickets, ticket_promedio
CREATE OR REPLACE VIEW vw_sales_daily AS
SELECT 
    created_at::DATE AS fecha,
    SUM(paid_amount) AS total_ventas,
    COUNT(DISTINCT o.id) AS tickets,
    ROUND(AVG(paid_amount), 2) AS ticket_promedio
FROM orders o
JOIN payments p ON o.id = p.order_id
GROUP BY created_at::DATE
ORDER BY fecha DESC;

-- VERIFY: SELECT * FROM vw_sales_daily WHERE fecha = '2026-02-01';

-- 2. vw_top_products_ranked: Ranking de productos por ingresos (Usa CTE y Window Function)
-- Grain: 1 fila por producto
-- Requisitos: CTE , Window Function , Prohibido SELECT * [cite: 55]
CREATE OR REPLACE VIEW vw_top_products_ranked AS
WITH product_revenue AS (
    SELECT 
        p.name AS producto,
        SUM(oi.qty * oi.unit_price) AS revenue,
        SUM(oi.qty) AS unidades_vendidas
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.name
)
SELECT 
    producto,
    revenue,
    unidades_vendidas,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS ranking
FROM product_revenue;

-- VERIFY: SELECT * FROM vw_top_products_ranked LIMIT 5;

-- 3. vw_inventory_risk: Productos con stock bajo (Usa CASE y HAVING)
-- Grain: 1 fila por producto en riesgo
-- Requisitos: CASE , HAVING 
CREATE OR REPLACE VIEW vw_inventory_risk AS
SELECT 
    p.name AS producto,
    p.stock,
    c.name AS categoria,
    CASE 
        WHEN p.stock <= 5 THEN 'CRÍTICO'
        WHEN p.stock <= 10 THEN 'ADVERTENCIA'
        ELSE 'OK'
    END AS nivel_riesgo,
    ROUND((p.stock::DECIMAL / 100) * 100, 2) AS porcentaje_disponible
FROM products p
JOIN categories c ON p.category_id = c.id
GROUP BY p.name, p.stock, c.name
HAVING p.stock < 15;

-- VERIFY: SELECT * FROM vw_inventory_risk WHERE nivel_riesgo = 'CRÍTICO';

-- 4. vw_customer_value: Valor del cliente (Usa Agregados y HAVING)
-- Grain: 1 fila por cliente
-- Requisitos: SUM/COUNT/AVG , HAVING 
CREATE OR REPLACE VIEW vw_customer_value AS
SELECT 
    c.name AS cliente,
    c.email,
    COUNT(o.id) AS num_ordenes,
    SUM(p.paid_amount) AS total_gastado,
    ROUND(AVG(p.paid_amount), 2) AS gasto_promedio
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
LEFT JOIN payments p ON o.id = p.order_id
GROUP BY c.name, c.email
HAVING COUNT(o.id) > 0;

-- VERIFY: SELECT * FROM vw_customer_value ORDER BY total_gastado DESC;

-- 5. vw_payment_mix: Mezcla de métodos de pago (Usa COALESCE y Cálculos)
-- Grain: 1 fila por método de pago
-- Requisitos: COALESCE , Campo calculado 
CREATE OR REPLACE VIEW vw_payment_mix AS
SELECT 
    COALESCE(method, 'No especificado') AS metodo_pago,
    COUNT(*) AS total_transacciones,
    SUM(paid_amount) AS monto_total,
    ROUND((SUM(paid_amount) / (SELECT SUM(paid_amount) FROM payments)) * 100, 2) AS porcentaje_del_total
FROM payments
GROUP BY method;

-- VERIFY: SELECT * FROM vw_payment_mix;