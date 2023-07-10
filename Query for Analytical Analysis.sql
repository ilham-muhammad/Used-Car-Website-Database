-- Project RDB & SQL - SE/DE Batch 2 Pacmann
-- Task : Analytical Query
-- Author : Muhammad Ilham

-- 1. Car popularity based on bid count
SELECT ads_count_table.car_model, advertisement_count, bid_count
FROM (
	SELECT
		cars.car_model,
		COUNT(ads_id) AS advertisement_count
	FROM advertisements AS ads
	LEFT JOIN cars
	ON ads.car_id = cars.car_id
	GROUP BY car_model
) AS ads_count_table
LEFT JOIN (
	SELECT
		car_model,
		COUNT(bid_id) AS bid_count
	FROM bids
	LEFT JOIN advertisements as ads
	ON bids.ads_id = ads.ads_id
	LEFT JOIN cars
	ON cars.car_id = ads.car_id
	GROUP BY car_model
) AS bid_count_table
ON ads_count_table.car_model = bid_count_table.car_model
ORDER BY bid_count DESC;

-- 2. Comparing car price with average price on each city
SELECT 
	ads_id,
	city,
	car_brand,
	car_model,
	year_built,
	price,
	AVG(price) OVER(PARTITION BY city) AS avg_price
FROM advertisements as ads
LEFT JOIN users
ON users.user_id = ads.user_id
LEFT JOIN city
ON users.city_id = city.city_id
LEFT JOIN cars
ON ads.car_id = cars.car_id
ORDER BY ads_id ASC

-- 3. Comparing last bid date & price with next entry bid, for the same user & same car
SELECT *
FROM(
	SELECT
		car_model,
		bids.user_id,
		bid_date,
		bid_price,
		LEAD(bid_date) OVER(PARTITION BY car_model, bids.user_id ORDER BY bid_date ASC) AS next_bid_date,
		LEAD(bid_price) OVER(PARTITION BY car_model, bids.user_id ORDER BY bid_date ASC) AS next_bid_price
	FROM bids
	LEFT JOIN advertisements AS ads
	ON ads.ads_id = bids.ads_id
	LEFT JOIN cars
	ON ads.car_id = cars.car_id
) AS compare
WHERE next_bid_date IS NOT NULL;

-- 4. Compare average price, average bid price during 6 month, and difference between them within same car model
CREATE TEMPORARY TABLE avg_price AS
	SELECT 
		car_model,
		AVG(price) as avg_price
	FROM advertisements AS ads
	LEFT JOIN cars
	ON ads.car_id = cars.car_id
	GROUP BY car_model; 

WITH bid_summary AS(
	SELECT
		car_model,
		bid_date,
		AVG(price) OVER(ORDER BY bid_date ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS avg_price_6entry,  -- Dummy data provide randomly 6 date entry, not 6 month consecutive entry
		ROW_NUMBER() OVER(PARTITION BY car_model ORDER BY bid_date DESC) AS row_num -- Filter latest entry
	FROM bids
	LEFT JOIN advertisements as ads
	ON bids.ads_id = ads.ads_id
	LEFT JOIN cars
	ON cars.car_id = ads.car_id
	ORDER BY car_model ASC, bid_date DESC
)
SELECT
	bid_summary.car_model,
	avg_price,
	avg_price_6entry,
	(avg_price - avg_price_6entry) AS difference,
	(avg_price - avg_price_6entry)/avg_price*100 AS difference_percent
FROM bid_summary
LEFT JOIN avg_price
ON avg_price.car_model = bid_summary.car_model
WHERE row_num = 1; -- Filter latest entry

-- 5. Window function average bid price for last 6 month
WITH bid_entry AS(
	SELECT
		car_brand,
		car_model,
		bid_date,
		AVG(bid_price) OVER(ORDER BY car_model ASC, bid_date ASC ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS avg_price_6entry,  -- Dummy data provide randomly 6 date entry, not 6 month consecutive entry
		AVG(bid_price) OVER(ORDER BY car_model ASC, bid_date ASC ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS avg_price_5entry,
		AVG(bid_price) OVER(ORDER BY car_model ASC, bid_date ASC ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS avg_price_4entry,
		AVG(bid_price) OVER(ORDER BY car_model ASC, bid_date ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg_price_3entry,
		AVG(bid_price) OVER(ORDER BY car_model ASC, bid_date ASC ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS avg_price_2entry,
		AVG(bid_price) OVER(ORDER BY car_model ASC, bid_date ASC ROWS BETWEEN 0 PRECEDING AND CURRENT ROW) AS avg_price_1entry,
		ROW_NUMBER() OVER(PARTITION BY car_model ORDER BY bid_date DESC) AS row_num
	FROM bids
	LEFT JOIN advertisements as ads
	ON bids.ads_id = ads.ads_id
	LEFT JOIN cars
	ON cars.car_id = ads.car_id
	ORDER BY car_model ASC, bid_date ASC
)
SELECT *
FROM bid_entry
WHERE row_num = 1 -- filter latest entry
