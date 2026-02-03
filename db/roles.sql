-- 1. Crear el usuario para la aplicación
-- Nota: En un entorno real, la contraseña vendría de una variable de entorno
CREATE USER app WITH PASSWORD 'password_app';

-- 2. Dar permisos de conexión a la base de datos
GRANT CONNECT ON DATABASE cafeteria_db TO app;

-- 3. Dar permiso de uso al esquema public
GRANT USAGE ON SCHEMA public TO app;

-- 4. El corazón de la seguridad: SOLO SELECT sobre las VIEWS
-- Esto cumple con el requisito de no acceso directo a tablas 
GRANT SELECT ON vw_sales_daily TO app;
GRANT SELECT ON vw_top_products_ranked TO app;
GRANT SELECT ON vw_inventory_risk TO app;
GRANT SELECT ON vw_customer_value TO app;
GRANT SELECT ON vw_payment_mix TO app;

-- 5. Revocar cualquier otro permiso por si acaso
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM app;