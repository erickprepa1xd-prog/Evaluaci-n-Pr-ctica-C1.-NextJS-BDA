-- Insertar Categorías
INSERT INTO categories (name) VALUES 
('Café Caliente'), ('Bebidas Frías'), ('Repostería'), ('Sándwiches'), ('Granos');

-- Insertar Productos (incluimos algunos con stock bajo para el reporte de riesgo)
INSERT INTO products (category_id, name, price, stock) VALUES 
(1, 'Americano 12oz', 35.00, 100),
(1, 'Cappuccino 12oz', 45.00, 80),
(2, 'Frappé Nutella', 65.00, 50),
(3, 'Croissant de Mantequilla', 30.00, 5), -- Stock bajo para prueba
(3, 'Muffin de Arándano', 25.00, 3),    -- Stock bajo para prueba
(4, 'Bagel de Lomo', 85.00, 15),
(5, 'Bolsa Café Chiapas 500g', 180.00, 10);

-- Insertar Clientes
INSERT INTO customers (name, email) VALUES 
('Erick Garcia', 'erick@example.com'),
('Laura Mendez', 'laura@example.com'),
('Carlos Ruiz', 'carlos@example.com'),
('Ana Lopez', 'ana@example.com');

-- Insertar Órdenes (con fechas distintas para el reporte diario)
INSERT INTO orders (customer_id, created_at, status, channel) VALUES 
(1, '2026-02-01 08:30:00', 'completed', 'physical'),
(2, '2026-02-01 09:15:00', 'completed', 'physical'),
(3, '2026-02-02 10:00:00', 'completed', 'online'),
(1, '2026-02-02 14:20:00', 'completed', 'physical'),
(4, '2026-02-03 08:00:00', 'completed', 'online');

-- Insertar Detalles de Órdenes
INSERT INTO order_items (order_id, product_id, qty, unit_price) VALUES 
(1, 1, 2, 35.00), -- 2 Americanos
(1, 4, 1, 30.00), -- 1 Croissant
(2, 2, 1, 45.00), -- 1 Cappuccino
(3, 6, 2, 85.00), -- 2 Bagels
(4, 3, 1, 65.00), -- 1 Frappé
(5, 7, 1, 180.00); -- 1 Bolsa Café

-- Insertar Pagos (mezcla de métodos para el reporte de mix de pagos)
INSERT INTO payments (order_id, method, paid_amount) VALUES 
(1, 'cash', 100.00),
(2, 'card', 45.00),
(3, 'transfer', 170.00),
(4, 'card', 65.00),
(5, 'card', 180.00);