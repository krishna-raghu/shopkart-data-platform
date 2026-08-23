INSERT INTO customers
(first_name, last_name, email, city)
VALUES
('Alice', 'Smith', 'alice@example.com', 'London'),
('Bob', 'Patel', 'bob@example.com', 'Manchester'),
('Charlie', 'Jones', 'charlie@example.com', 'Birmingham');

INSERT INTO products
(product_name, category, unit_price)
VALUES
('Laptop', 'Electronics', 899.99),
('Mouse', 'Electronics', 29.99),
('Office Chair', 'Furniture', 199.50);

INSERT INTO orders
(customer_id, order_status, order_total)
VALUES
(1, 'COMPLETED', 929.98),
(2, 'COMPLETED', 199.50);

INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 899.99),
(1, 2, 1, 29.99),
(2, 3, 1, 199.50);