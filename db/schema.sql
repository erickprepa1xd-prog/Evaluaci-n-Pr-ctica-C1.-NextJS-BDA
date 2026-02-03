-- 1. Categorías de productos (Café, Postres, Bebidas Frías, etc.)
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Productos disponibles
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES categories(id), -- Relación FK
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    active BOOLEAN DEFAULT TRUE
);

-- 3. Clientes de la cafetería
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- 4. Órdenes (Ventas)
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id), -- Relación FK
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL, -- Ej: 'completed', 'pending'
    channel VARCHAR(50) NOT NULL -- Ej: 'physical', 'online'
);

-- 5. Detalle de los productos en cada orden
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE, -- Relación FK
    product_id INTEGER REFERENCES products(id), -- Relación FK
    qty INTEGER NOT NULL CHECK (qty > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0)
);

-- 6. Pagos realizados
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE, -- Relación FK
    method VARCHAR(50) NOT NULL, -- Ej: 'cash', 'card', 'transfer'
    paid_amount DECIMAL(10, 2) NOT NULL CHECK (paid_amount >= 0)
);