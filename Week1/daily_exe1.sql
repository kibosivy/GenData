USE ABC_DATA;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
    (1, 'John', 'Doe', 'johndoe@email.com'),
    (2, 'Jane', 'Smith', 'janesmith@email.com'),
    (3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
    (4, 'Alice', 'Brown', 'alicebrown@email.com'),
    (5, 'Charlie', 'Davis', 'charliedavis@email.com'),
    (6, 'Eva', 'Fisher', 'evafisher@email.com'),
    (7, 'George', 'Harris', 'georgeharris@email.com'),
    (8, 'Ivy', 'Jones', 'ivyjones@email.com'),
    (9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
    (10, 'Lily', 'Nelson', 'lilynelson@email.com'),
    (11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
    (12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
    (13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

    INSERT INTO products (product_id, product_name, price) VALUES
    (1, 'Product A', 10.00),
    (2, 'Product B', 15.00),
    (3, 'Product C', 20.00),
    (4, 'Product D', 25.00),
    (5, 'Product E', 30.00),
    (6, 'Product F', 35.00),
    (7, 'Product G', 40.00),
    (8, 'Product H', 45.00),
    (9, 'Product I', 50.00),
    (10, 'Product J', 55.00),
    (11, 'Product K', 60.00),
    (12, 'Product L', 65.00),
    (13, 'Product M', 70.00);
    
    INSERT INTO orders (order_id, customer_id, order_date) VALUES
    (1, 1, '2023-05-01'),
    (2, 2, '2023-05-02'),
    (3, 3, '2023-05-03'),
    (4, 1, '2023-05-04'),
    (5, 2, '2023-05-05'),
    (6, 3, '2023-05-06'),
    (7, 4, '2023-05-07'),
    (8, 5, '2023-05-08'),
    (9, 6, '2023-05-09'),
    (10, 7, '2023-05-10'),
    (11, 8, '2023-05-11'),
    (12, 9, '2023-05-12'),
    (13, 10, '2023-05-13'),
    (14, 11, '2023-05-14'),
    (15, 12, '2023-05-15'),
    (16, 13, '2023-05-16');

    INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (1, 1, 2),
    (1, 2, 1),
    (2, 2, 1),
    (2, 3, 3),
    (3, 1, 1),
    (3, 3, 2),
    (4, 2, 4),
    (4, 3, 1),
    (5, 1, 1),
    (5, 3, 2),
    (6, 2, 3),
    (6, 1, 1),
    (7, 4, 1),
    (7, 5, 2),
    (8, 6, 3),
    (8, 7, 1),
    (9, 8, 2),
    (9, 9, 1),
    (10, 10, 3),
    (10, 11, 2),
    (11, 12, 1),
    (11, 13, 3),
    (12, 4, 2),
    (12, 5, 1),
    (13, 6, 3),
    (13, 7, 2),
    (14, 8, 1),
    (14, 9, 2),
    (15, 10, 3),
    (15, 11, 1),
    (16, 12, 2),
    (16, 13, 3);

-- Which product has the highest price?
SELECT product_id, product_name, price
FROM products
ORDER BY price DESC
LIMIT 1;

-- Which order_id had the highest number of items (in terms of quantity)?
SELECT order_id, SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id
ORDER BY total_quantity DESC
LIMIT 1;

-- Which customer has made the most orders?
SELECT c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY order_count DESC
LIMIT 1;

SELECT p.product_name,
       p.price * SUM(oi.quantity) AS total_revenue
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.price
ORDER BY total_revenue DESC;

-- Find the first order (by date) for each customer
SELECT o.customer_id, o.order_id, o.order_date
FROM orders o
WHERE o.order_date = (
    SELECT MIN(order_date)
    FROM orders o2
    WHERE o2.customer_id = o.customer_id
);

-- What’s the total revenue per product?
SELECT p.product_name,
       p.price * SUM(oi.quantity) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.price
ORDER BY total_revenue DESC;

-- Find the day with the highest revenue
SELECT
    o.order_date,
    SUM(p.price * oi.quantity) AS total_revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY o.order_date
ORDER BY total_revenue DESC
LIMIT 1;
