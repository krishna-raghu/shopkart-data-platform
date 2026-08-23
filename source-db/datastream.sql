-- =========================================================
-- 1. Datastream CDC account
-- =========================================================

CREATE USER datastream_user
WITH REPLICATION LOGIN
PASSWORD :'datastream_password';


-- =========================================================
-- 2. Database permissions for historical backfill
-- =========================================================

GRANT CONNECT ON DATABASE retail
TO datastream_user;

GRANT USAGE ON SCHEMA public
TO datastream_user;

GRANT SELECT ON ALL TABLES
IN SCHEMA public
TO datastream_user;

ALTER DEFAULT PRIVILEGES
IN SCHEMA public
GRANT SELECT ON TABLES
TO datastream_user;


-- =========================================================
-- 3. CDC publication
-- =========================================================

CREATE PUBLICATION retail_publication
FOR TABLE
    public.customers,
    public.products,
    public.orders,
    public.order_items,
    public.payments;


-- =========================================================
-- 4. Replication slot
--
-- Must be executed by an account with REPLICATION
-- privilege.
-- =========================================================

SELECT PG_CREATE_LOGICAL_REPLICATION_SLOT(
    'retail_replication_slot',
    'pgoutput'
);