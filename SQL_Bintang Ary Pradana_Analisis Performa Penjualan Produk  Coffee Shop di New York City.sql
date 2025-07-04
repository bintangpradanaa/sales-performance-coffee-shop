-- Membuat tabel transaction
CREATE TABLE transactions (
    transaction_id TEXT PRIMARY KEY,
    transaction_date DATE,
    transaction_time TIME,
    transaction_qty INT,
    store_id TEXT,
    store_location VARCHAR(100),
    product_id TEXT,
    unit_price DECIMAL(10,2),
    product_category VARCHAR(50),
    product_type VARCHAR(100),
    product_detail VARCHAR(255)
);

-- Show all data
select * from transactions;

-- 1. Bagaimana tren pendapatan (revenue) perusahaan dari bulan ke bulan?
SELECT 
    EXTRACT(MONTH FROM transaction_date) AS month,
    SUM(unit_price * transaction_qty) AS total_revenue
FROM transactions
GROUP BY month
ORDER BY month ASC;

-- 2. Outlet mana yang memiliki total penjualan (kuantitas) tertinggi?
SELECT 
    store_location, 
    SUM(transaction_qty) AS total_quantity_sold
FROM transactions
GROUP BY store_location
ORDER BY total_quantity_sold DESC;

-- 3. Produk apa yang memberikan pendapatan (revenue) tertinggi?
SELECT 
    product_detail,
    SUM(unit_price * transaction_qty) AS total_revenue
FROM transactions
GROUP BY product_detail
ORDER BY total_revenue DESC
LIMIT 5;

-- 4. Kategori produk apa yang menghasilkan pendapatan tertinggi?
SELECT 
    product_category,
    SUM(unit_price * transaction_qty) AS total_revenue
FROM transactions
GROUP BY product_category
ORDER BY total_revenue DESC
LIMIT 5;

-- 5. Produk apa yang paling banyak terjual di setiap outlet?
WITH OutletProduk AS (
    SELECT 
        store_location AS outlet,
        product_detail AS produk,
        SUM(transaction_qty) AS total_terjual,
        ROW_NUMBER() OVER (PARTITION BY store_location ORDER BY SUM(transaction_qty) DESC) AS rn
    FROM transactions
    GROUP BY store_location, product_detail
)
SELECT outlet, produk, total_terjual
FROM OutletProduk
WHERE rn = 1
ORDER BY outlet;




