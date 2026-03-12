#  Myntra Men's Pants – Data Analysis Project

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-Web%20Scraping-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

---

## 📌 Project Overview

This project is an end-to-end data analysis of **men's pants listed on Myntra** — one of India's largest fashion e-commerce platforms. The dataset was collected via **web scraping** and contains over **52,000+ product records** across multiple brands.

The analysis covers brand performance, pricing strategies, discount patterns, customer demand, and product quality — delivered through **MySQL queries** and an interactive **Power BI dashboard**.

---

## 🎯 Objectives

- Analyze brand-wise performance across pricing, ratings, and popularity
- Identify high-discount products and pricing strategies
- Understand customer demand through review/rating volume
- Derive value-for-money scores across brands
- Classify products by fit type and segment the market

---

## 🗂️ Project Structure

```
myntra-pants-analysis/
│
├── 📁 dataset/
│   └── myntra_dataset_ByScraping.csv       # Raw scraped dataset (52,000+ records)
│
├── 📁 sql/
│   └── myntra_analysis.sql                 # All MySQL queries (schema + analysis)
│
├── 📁 powerbi/
│   └── myntra_dashboard.pbix               # Power BI dashboard file
│   └── dashboard_preview.png               # Dashboard screenshot
│
└── README.md
```

---

## 📊 Dataset Description

> **Source:** Web scraped from Myntra  
> **Records:** 52,121 rows  
> **Domain:** Men's Pants / Bottom Wear

| Column | Type | Description |
|--------|------|-------------|
| `brand_name` | VARCHAR | Name of the clothing brand |
| `pants_description` | TEXT | Product title/description |
| `price` | INT | Selling price (INR) |
| `mrp` | INT | Maximum Retail Price (INR) |
| `discount_percent` | DECIMAL | Discount as a decimal (e.g., 0.45 = 45%) |
| `ratings` | DECIMAL | Customer rating (out of 5) |
| `number_of_ratings` | INT | Total number of customer ratings |

---

## 🗄️ Database Schema

```sql
CREATE DATABASE myntra_data;

CREATE TABLE myntra_dataset (
    brand_name       VARCHAR(200),
    pants_description TEXT,
    price            INT,
    mrp              INT,
    discount_percent DECIMAL(10,2),
    ratings          DECIMAL(10,2),
    number_of_ratings INT
);

CREATE TABLE brands (
    brand_id   INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(200) UNIQUE NOT NULL
);
```

The `brands` table is populated using `INSERT INTO brands SELECT DISTINCT brand_name FROM myntra_dataset`.

---

## 🔍 SQL Analysis Modules

### 1. 🏷️ Brand Performance Insights
| Query | Description |
|-------|-------------|
| Average price per brand | Which brands are positioned as premium vs budget |
| Highest-rated brands | Brands ranked by average customer rating |
| Most popular brands | Brands ranked by total number of ratings (demand proxy) |
| Quality & popularity combined | Avg ratings vs avg popularity per brand |

### 2. 💰 Pricing & Discount Strategy
| Query | Description |
|-------|-------------|
| Average discount per brand | Which brands offer the most discounts on average |
| Top 20 discounted products | Products with the highest discount percentage |
| Highest discounted amount | Products with largest INR savings (MRP − Price) |

### 3. 📈 Demand & Popularity Analysis
| Query | Description |
|-------|-------------|
| Top 20 most popular products | Products with the highest number of customer ratings |
| Brand demand ranking | Total products and total demand volume per brand |

### 4. ⭐ Value & Quality Analysis
| Query | Description |
|-------|-------------|
| Value-for-money score | Ratings divided by price — best quality per rupee |

### 5. 🛍️ Product & Customer Insights
| Query | Description |
|-------|-------------|
| Fit type analysis | Products classified as Slim / Regular / Relaxed / Loose / Other |
| Overall price range | Min, Max, Avg price across all products |
| Average discount amount | Mean INR discount across the catalog |
| Ratings distribution | Product count per brand per rating score |
| High-rated, low-visibility products | Hidden gems: good ratings but very few reviews |

---

## 📉 Power BI Dashboard

The Power BI dashboard presents all key insights visually across multiple pages:

- **Brand Overview** – Price, ratings, and demand per brand
- **Discount Analysis** – Top discounted products and brand-level discount trends  
- **Demand Heatmap** – Popularity distribution across brands
- **Value Score** – Value-for-money ranking
- **Fit Type Segmentation** – Market share by product fit category

> 📸 Dashboard preview:

![Dashboard Preview](powerbi/dashboard_preview.png)

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| Python (BeautifulSoup / Selenium) | Web scraping from Myntra |
| MySQL 8.0 | Data storage, schema design, SQL analysis |
| Power BI Desktop | Interactive data visualization & dashboard |
| GitHub | Version control and project hosting |

---

## 🚀 How to Run

### Step 1 – Set up MySQL Database
```sql
CREATE DATABASE myntra_data;
USE myntra_data;
```

### Step 2 – Import the Dataset
Import `myntra_dataset_ByScraping.csv` into the `myntra_dataset` table using MySQL Workbench Table Data Import Wizard or:
```bash
mysqlimport --local --fields-terminated-by=',' --lines-terminated-by='\n' myntra_data myntra_dataset_ByScraping.csv
```

### Step 3 – Run SQL Scripts
Open `sql/myntra_analysis.sql` in MySQL Workbench and execute all queries section by section.

### Step 4 – Open Power BI Dashboard
Open `powerbi/myntra_dashboard.pbix` in **Power BI Desktop** and refresh the data source to point to your local MySQL connection.

---

## 💡 Key Insights

- 🏆 **Premium brands** maintain high prices with moderate discounts, while budget brands rely heavily on discounting.
- 📦 A small number of brands dominate total demand, suggesting high market concentration.
- 💎 Several products show **high ratings but very low visibility** — potential for better marketing.
- 🎯 **Regular fit** and **Slim fit** dominate the catalog, with fewer Relaxed/Loose fit options.
- 💸 Average discount across the platform is significant, indicating aggressive promotional strategies.

---

## 👤 Author

Abhinav
📧 abhinav.aj1028@gmail.com
🔗 linkedin.com/in/abhinav-a-63050a3b4
🐙 https://github.com/abhinav1028-bit

---

> ⭐ If you found this project useful, please consider giving it a star!
