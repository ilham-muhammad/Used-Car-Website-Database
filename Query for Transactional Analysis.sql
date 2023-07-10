-- Project RDB & SQL - SE/DE Batch 2 Pacmann
-- Task : Transactional Query
-- Author : Muhammad Ilham

-- 1. Find car that were built beyond 2015
SELECT 
	year_built,
	car_brand,
	car_model,
	price
FROM advertisements AS ads
LEFT JOIN cars
ON ads.car_id = cars.car_id
WHERE year_built >= 2015;

-- 2. Add bid entries
INSERT INTO bids(bid_id, user_id, ads_id, bid_date, bid_price)
VALUES(9910,333,212,'2006-07-17',100000000);

-- 3. Summarize newest advertisement post from an account
SELECT
	first_name,
	last_name,
	car_brand,
	car_model,
	posting_date,
	price
FROM advertisements AS ads
LEFT JOIN users
ON ads.user_id = users.user_id
LEFT JOIN cars
ON ads.car_id = cars.car_id
WHERE 
	first_name LIKE 'Latif' AND
	last_name LIKE 'Mansur'
ORDER BY posting_date DESC;


-- 4. Finding cheapest car based on keyword
SELECT
	ads_id,
	car_brand,
	car_model,
	year_built,
	posting_date,
	price
FROM advertisements AS ads
LEFT JOIN cars
ON ads.car_id = cars.car_id
WHERE car_model LIKE 'Mustang'
ORDER BY price;

-- 5. Finding nearby car based on buyer & seller location
CREATE TEMPORARY TABLE user_location AS
	SELECT
		user_id,
		users.city_id,
		latitude,
		longitude
	FROM users
	LEFT JOIN city
	ON users.city_id = city.city_id;


WITH combine_user_loc as (
	SELECT
		ads.user_id as seller_id,
		bids.user_id as buyer_id,
		car_brand,
		car_model,
		price,
		bid_price,
		latitude as seller_lat,
		longitude as seller_long
	FROM advertisements AS ads
	LEFT JOIN users
	ON ads.user_id = users.user_id
	LEFT JOIN cars
	ON ads.car_id = cars.car_id
	LEFT JOIN bids
	ON ads.ads_id = bids.ads_id
	LEFT JOIN user_location
	ON ads.user_id = user_location.user_id
)
SELECT
	seller_id,
	buyer_id,
	city_id,
	car_brand,
	car_model,
	price,
	bid_price,
	seller_lat,
	seller_long,
	latitude as buyer_lat,
	longitude as buyer_long,
	SQRT(POW((seller_lat - latitude), 2) + POW((seller_long - longitude), 2)) AS distance
FROM combine_user_loc as combine
LEFT JOIN user_location
ON combine.buyer_id = user_location.user_id
WHERE city_id = 3174
ORDER BY SQRT(POW((seller_lat - latitude), 2) + POW((seller_long - longitude), 2)) ASC;
