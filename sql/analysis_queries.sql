-- Country Economy Analysis - SQL component
-- Dataset columns: CountryName, CountryCode, BirthRate, InternetUsers, IncomeGroup
--
-- Notes:
-- - This file is written in portable SQL (works with Postgres; mostly compatible with SQLite).
-- - If your SQL engine doesn't support NUMERIC/DECIMAL, use REAL/DOUBLE as appropriate.


/* ============================================================
   1) TABLE SCHEMA
   ============================================================ */

-- Create a table for the dataset.
-- Table name choice: country_economy
CREATE TABLE IF NOT EXISTS country_economy (
  country_name    TEXT NOT NULL,
  country_code    TEXT NOT NULL,
  birth_rate      NUMERIC NOT NULL,      -- births per 1,000 people (as provided by dataset)
  internet_users  NUMERIC NOT NULL,      -- % of population (as provided by dataset)
  income_group    TEXT NOT NULL,
  CONSTRAINT pk_country_economy PRIMARY KEY (country_code)
);

-- Example load (adjust to your database tooling):
-- Postgres:  COPY country_economy(country_name,country_code,birth_rate,internet_users,income_group)
--            FROM '/absolute/path/to/data.csv' WITH (FORMAT csv, HEADER true);
-- SQLite:    .mode csv
--            .import data/data.csv country_economy


/* ============================================================
   2) BUSINESS-FOCUSED ANALYSIS QUERIES (10)
   ============================================================ */

-- Q1) How many countries are in each income group?
SELECT
  income_group,
  COUNT(*) AS country_count
FROM country_economy
GROUP BY income_group
ORDER BY country_count DESC, income_group;


-- Q2) Income-group benchmarks: median-ish summary using AVG + MIN/MAX.
-- (Median isn't portable in pure SQL; AVG is fine for a portfolio baseline.)
SELECT
  income_group,
  COUNT(*) AS n_countries,
  ROUND(AVG(internet_users), 2) AS avg_internet_users_pct,
  ROUND(AVG(birth_rate), 2) AS avg_birth_rate,
  ROUND(MIN(internet_users), 2) AS min_internet_users_pct,
  ROUND(MAX(internet_users), 2) AS max_internet_users_pct
FROM country_economy
GROUP BY income_group
ORDER BY avg_internet_users_pct DESC;


-- Q3) Which income groups have high average internet usage?
-- Demonstrates HAVING.
SELECT
  income_group,
  ROUND(AVG(internet_users), 2) AS avg_internet_users_pct
FROM country_economy
GROUP BY income_group
HAVING AVG(internet_users) >= 50
ORDER BY avg_internet_users_pct DESC;


-- Q4) Segment countries into adoption tiers using CASE WHEN.
SELECT
  CASE
    WHEN internet_users >= 80 THEN '80%+ (very high)'
    WHEN internet_users >= 50 THEN '50–79% (high)'
    WHEN internet_users >= 20 THEN '20–49% (mid)'
    ELSE '<20% (low)'
  END AS internet_adoption_tier,
  COUNT(*) AS country_count
FROM country_economy
GROUP BY
  CASE
    WHEN internet_users >= 80 THEN '80%+ (very high)'
    WHEN internet_users >= 50 THEN '50–79% (high)'
    WHEN internet_users >= 20 THEN '20–49% (mid)'
    ELSE '<20% (low)'
  END
ORDER BY country_count DESC;


-- Q5) Cross-segmentation: internet adoption tier by income group.
SELECT
  income_group,
  CASE
    WHEN internet_users >= 80 THEN '80%+'
    WHEN internet_users >= 50 THEN '50–79%'
    WHEN internet_users >= 20 THEN '20–49%'
    ELSE '<20%'
  END AS internet_tier,
  COUNT(*) AS country_count
FROM country_economy
GROUP BY income_group,
  CASE
    WHEN internet_users >= 80 THEN '80%+'
    WHEN internet_users >= 50 THEN '50–79%'
    WHEN internet_users >= 20 THEN '20–49%'
    ELSE '<20%'
  END
ORDER BY income_group, country_count DESC;


-- Q6) Top 10 countries by internet usage (global ranking).
SELECT
  country_name,
  income_group,
  internet_users AS internet_users_pct
FROM country_economy
ORDER BY internet_users DESC, country_name
LIMIT 10;


-- Q7) Bottom 10 countries by internet usage (where digital access may be constrained).
SELECT
  country_name,
  income_group,
  internet_users AS internet_users_pct
FROM country_economy
ORDER BY internet_users ASC, country_name
LIMIT 10;


-- Q8) Ranking query: top 3 countries by internet usage within each income group.
-- Demonstrates window functions (DENSE_RANK).
WITH ranked AS (
  SELECT
    country_name,
    income_group,
    internet_users,
    DENSE_RANK() OVER (
      PARTITION BY income_group
      ORDER BY internet_users DESC
    ) AS rnk
  FROM country_economy
)
SELECT
  income_group,
  rnk,
  country_name,
  internet_users AS internet_users_pct
FROM ranked
WHERE rnk <= 3
ORDER BY income_group, rnk, internet_users DESC, country_name;


-- Q9) Ranking query: countries with the highest birth rates within each income group.
WITH ranked AS (
  SELECT
    country_name,
    income_group,
    birth_rate,
    ROW_NUMBER() OVER (
      PARTITION BY income_group
      ORDER BY birth_rate DESC
    ) AS rn
  FROM country_economy
)
SELECT
  income_group,
  rn AS rank_in_group,
  country_name,
  birth_rate
FROM ranked
WHERE rn <= 5
ORDER BY income_group, rank_in_group;


-- Q10) Potential “outliers” within income groups:
-- Countries that have much higher internet usage than their group average (>= +20 points).
-- Demonstrates joining group aggregates back to detail.
WITH group_avgs AS (
  SELECT
    income_group,
    AVG(internet_users) AS avg_internet_users
  FROM country_economy
  GROUP BY income_group
)
SELECT
  c.income_group,
  c.country_name,
  ROUND(c.internet_users, 2) AS internet_users_pct,
  ROUND(g.avg_internet_users, 2) AS group_avg_internet_users_pct,
  ROUND(c.internet_users - g.avg_internet_users, 2) AS uplift_vs_group_avg
FROM country_economy c
JOIN group_avgs g
  ON c.income_group = g.income_group
WHERE (c.internet_users - g.avg_internet_users) >= 20
ORDER BY uplift_vs_group_avg DESC, c.income_group, c.country_name;

