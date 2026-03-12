-- ================================================================
-- PROJECT  : MYNTRA PRODUCT PRICING & MARKET ANALYSIS — Data Analysis
-- DATABASE : myntra_data_by_scrap
-- TOOL     : MySQL 8.0
-- AUTHOR   : Abhinav
-- DESCRIPTION: End-to-end SQL analysis of Myntra men's pants data
--              scraped from Myntra covering brand performance,
--              pricing strategy, demand analysis, and product insights.
-- ================================================================


-- ================================================================
-- SECTION 1: DATABASE & TABLE SETUP
-- ================================================================

CREATE DATABASE myntra_data;
USE myntra_data;

-- Main product table
CREATE TABLE myntra_dataset (
    brand_name        VARCHAR(200),
    pants_description TEXT,
    price             INT,
    mrp               INT,
    discount_percent  DECIMAL(10,2),
    ratings           DECIMAL(10,2),
    number_of_ratings INT
);

-- Normalized brands lookup table
CREATE TABLE brands (
    brand_id   INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(200) UNIQUE NOT NULL
);

-- Populate brands table from distinct brand names in dataset
INSERT INTO brands (brand_name)
SELECT DISTINCT brand_name
FROM myntra_dataset
WHERE brand_name IS NOT NULL;

-- Quick verification
SELECT * FROM brands ORDER BY brand_id;
SELECT * FROM myntra_dataset;


-- ================================================================
-- SECTION 2: BRAND PERFORMANCE INSIGHTS
-- ================================================================

USE myntra_data;

-- 1. Average Price Per Brand
--    Identifies premium vs budget brand positioning
SELECT
    brands.brand_name,
    ROUND(AVG(myntra_dataset.price), 2) AS avg_price
FROM myntra_dataset
JOIN brands ON myntra_dataset.brand_name = brands.brand_name
GROUP BY brands.brand_name
ORDER BY avg_price DESC;


-- 2. Highest Rated Brands
--    Ranks brands by average customer satisfaction score
SELECT
    brands.brand_name,
    ROUND(AVG(myntra_dataset.ratings), 2) AS avg_ratings
FROM myntra_dataset
JOIN brands ON myntra_dataset.brand_name = brands.brand_name
WHERE ratings IS NOT NULL
GROUP BY brands.brand_name
ORDER BY avg_ratings DESC;


-- 3. Most Popular Brands
--    Uses total number of ratings as a proxy for market demand
SELECT
    brands.brand_name,
    SUM(myntra_dataset.number_of_ratings) AS total_demand
FROM myntra_dataset
JOIN brands ON myntra_dataset.brand_name = brands.brand_name
GROUP BY brands.brand_name
ORDER BY total_demand DESC;


-- 4. Quality & Popularity Combined
--    Side-by-side view of avg rating and avg popularity per brand
SELECT
    brands.brand_name,
    ROUND(AVG(myntra_dataset.ratings), 2)           AS avg_ratings,
    ROUND(AVG(myntra_dataset.number_of_ratings), 2) AS avg_popularity
FROM myntra_dataset
JOIN brands ON myntra_dataset.brand_name = brands.brand_name
GROUP BY brands.brand_name;


-- ================================================================
-- SECTION 3: PRICING & DISCOUNT STRATEGY
-- ================================================================

USE myntra_data;

-- 1. Average Discount Per Brand (as percentage)
--    Reveals which brands rely most heavily on discounting
SELECT
    brands.brand_name,
    ROUND(AVG(myntra_dataset.discount_percent) * 100, 2) AS avg_discount_on_brands
FROM myntra_dataset
JOIN brands ON myntra_dataset.brand_name = brands.brand_name
GROUP BY brands.brand_name
ORDER BY avg_discount_on_brands DESC;


-- 2. Top 20 Most Discounted Products
--    Products offering the highest discount percentages
SELECT
    brands.brand_name,
    myntra_dataset.pants_description,
    myntra_dataset.mrp,
    myntra_dataset.price,
    ROUND(myntra_dataset.discount_percent * 100, 2) AS top_discounted
FROM myntra_dataset
JOIN brands ON myntra_dataset.brand_name = brands.brand_name
ORDER BY top_discounted DESC
LIMIT 20;


-- 3. Highest Discounted Amount (INR Savings)
--    Products with the largest absolute price drop from MRP
SELECT
    brands.brand_name,
    myntra_dataset.pants_description,
    (myntra_dataset.mrp - myntra_dataset.price) AS discounted_amount
FROM myntra_dataset
JOIN brands ON myntra_dataset.brand_name = brands.brand_name
WHERE myntra_dataset.mrp   IS NOT NULL
  AND myntra_dataset.price IS NOT NULL
ORDER BY discounted_amount DESC;


-- ================================================================
-- SECTION 4: DEMAND & POPULARITY ANALYSIS
-- ================================================================

USE myntra_data;

-- 1. Top 20 Most Popular Products
--    Ranked by number of customer ratings with brand details
SELECT
    ROW_NUMBER() OVER (ORDER BY myntra_dataset.number_of_ratings DESC) AS serial_no,
    brands.brand_id,
    brands.brand_name,
    myntra_dataset.pants_description,
    myntra_dataset.ratings,
    myntra_dataset.number_of_ratings
FROM myntra_dataset
JOIN brands ON myntra_dataset.brand_name = brands.brand_name
ORDER BY myntra_dataset.number_of_ratings DESC
LIMIT 20;


-- 2. Brand Demand Ranking
--    Total product count and cumulative demand volume per brand
SELECT
    brands.brand_name,
    COUNT(*)                              AS total_products,
    SUM(myntra_dataset.number_of_ratings) AS total_demand
FROM myntra_dataset
JOIN brands ON myntra_dataset.brand_name = brands.brand_name
GROUP BY brands.brand_name
ORDER BY total_demand DESC;


-- ================================================================
-- SECTION 5: VALUE & QUALITY ANALYSIS
-- ================================================================

USE myntra_data;

-- 1. Value-for-Money Score
--    Ratio of rating to price — higher means better quality per rupee
SELECT
    brands.brand_name,
    ROUND(AVG(myntra_dataset.ratings / NULLIF(myntra_dataset.price, 0)), 4) AS value_for_money
FROM myntra_dataset
JOIN brands ON myntra_dataset.brand_name = brands.brand_name
WHERE myntra_dataset.ratings IS NOT NULL
GROUP BY brands.brand_name
ORDER BY value_for_money DESC;


-- ================================================================
-- SECTION 6: PRODUCT & CUSTOMER INSIGHTS
-- ================================================================

USE myntra_data;

-- 1. Fit Type Classification
--    Add a new column and classify products based on description keywords
ALTER TABLE myntra_dataset
ADD COLUMN fit_type VARCHAR(90);

UPDATE myntra_dataset
SET fit_type = CASE
    WHEN pants_description LIKE '%Slim%'    THEN 'Slim-Fit'
    WHEN pants_description LIKE '%Regular%' THEN 'Regular-Fit'
    WHEN pants_description LIKE '%Relaxed%' THEN 'Relaxed-Fit'
    WHEN pants_description LIKE '%Loose%'   THEN 'Loose-Fit'
    ELSE 'Other'
END;


-- 2. Overall Price Range
--    Platform-wide minimum, maximum, and average selling price
SELECT
    MIN(price)          AS min_price,
    MAX(price)          AS max_price,
    ROUND(AVG(price), 2) AS avg_price
FROM myntra_dataset;


-- 3. Average Discount Amount (INR)
--    Mean rupee savings across all products on the platform
SELECT
    ROUND(AVG(mrp - price), 2) AS avg_discount_amount
FROM myntra_dataset
WHERE price IS NOT NULL
  AND mrp   IS NOT NULL;


-- 4. Ratings Distribution Per Brand
--    Number of products at each rating level per brand
SELECT
    brand_name,
    ratings,
    COUNT(*) AS product_count
FROM myntra_dataset
WHERE ratings IS NOT NULL
GROUP BY brand_name, ratings
ORDER BY ratings DESC;


-- 5. High Rated But Low Visibility Products (Hidden Gems)
--    Good quality products that haven't gained enough traction yet
SELECT
    brand_name,
    pants_description,
    ratings,
    number_of_ratings
FROM myntra_dataset
WHERE ratings           >= 4.5
  AND number_of_ratings  < 50
ORDER BY ratings DESC;


-- ================================================================
-- END OF ANALYSIS
-- ================================================================
