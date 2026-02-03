-- 1. Índice para búsqueda rápida por nombre de producto (usado en reportes de ranking) [cite: 35]
CREATE INDEX idx_products_name ON products(name);

-- 2. Índice para filtrar órdenes por fecha (usado en ventas diarias) [cite: 18]
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- 3. Índice para las llaves foráneas más usadas en joins
CREATE INDEX idx_order_items_product_id ON order_items(product_id);