-- CUSTOMER
CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT,
    email TEXT,
    address TEXT
);

-- PRODUCT
CREATE TABLE Product (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT,
    price NUMERIC,
    warranty_period INT
);

-- SALES ORDER
CREATE TABLE SalesOrder (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status TEXT,
    total_amount NUMERIC,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- ORDER ITEM
CREATE TABLE OrderItem (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price NUMERIC,
    FOREIGN KEY (order_id) REFERENCES SalesOrder(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- INVOICE
CREATE TABLE Invoice (
    invoice_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE,
    invoice_date DATE,
    total_amount NUMERIC,
    FOREIGN KEY (order_id) REFERENCES SalesOrder(order_id)
);

-- PAYMENT
CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    invoice_id INT,
    payment_date DATE,
    payment_method TEXT,
    amount NUMERIC,
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

-- DELIVERY
CREATE TABLE Delivery (
    delivery_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE,
    delivery_date DATE,
    delivery_status TEXT,
    address TEXT,
    FOREIGN KEY (order_id) REFERENCES SalesOrder(order_id)
);

-- WARRANTY
CREATE TABLE Warranty (
    warranty_id SERIAL PRIMARY KEY,
    product_id INT,
    customer_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- SERVICE REQUEST
CREATE TABLE ServiceRequest (
    request_id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    request_date DATE,
    issue_description TEXT,
    status TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- REPAIR
CREATE TABLE Repair (
    repair_id SERIAL PRIMARY KEY,
    request_id INT UNIQUE,
    repair_date DATE,
    status TEXT,
    cost NUMERIC,
    FOREIGN KEY (request_id) REFERENCES ServiceRequest(request_id)
);

-- SPARE PART
CREATE TABLE SparePart (
    part_id SERIAL PRIMARY KEY,
    part_name TEXT,
    price NUMERIC,
    stock_quantity INT
);

-- REPAIR DETAIL (ASSOCIATIVE)
CREATE TABLE RepairDetail (
    repair_id INT,
    part_id INT,
    quantity INT,
    PRIMARY KEY (repair_id, part_id),
    FOREIGN KEY (repair_id) REFERENCES Repair(repair_id),
    FOREIGN KEY (part_id) REFERENCES SparePart(part_id)
);

-- FEEDBACK
CREATE TABLE Feedback (
    feedback_id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    rating INT,
    comment TEXT,
    feedback_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
UPDATE OrderItem
SET unit_price = Product.price
FROM Product
WHERE OrderItem.product_id = Product.product_id;