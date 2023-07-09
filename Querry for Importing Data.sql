-- Project RDB & SQL - SE/DE Batch 2 Pacmann
-- Task : Importing dummy data
-- Author : Muhammad Ilham


-- Import data for City Table
COPY city(city_id, city, province, postal_code, latitude, longitude)
FROM 'C:\Users\Muhammad Ilham\Documents\GitHub\Used-Car-Website-Database\city.csv'
DELIMITER ','
CSV
HEADER;

-- Import data for Cars Table
COPY cars(car_id, car_brand, car_model, car_type, trans_type)
FROM 'C:\Users\Muhammad Ilham\Documents\GitHub\Used-Car-Website-Database\cars.csv'
DELIMITER ','
CSV
HEADER;

-- Import data for Users Table
COPY users(user_id, first_name, last_name, phone, address, city_id)
FROM 'C:\Users\Muhammad Ilham\Documents\GitHub\Used-Car-Website-Database\users.csv'
DELIMITER ','
CSV
HEADER;

-- Import data for Advertisements Table
COPY advertisements(ads_id, user_id, car_id, title, posting_date, year_built, color, mileage, price)
FROM 'C:\Users\Muhammad Ilham\Documents\GitHub\Used-Car-Website-Database\ads.csv'
DELIMITER ','
CSV
HEADER;

-- Import data for Bids Table
COPY bids(bid_id, user_id, ads_id, bid_date, bid_price)
FROM 'C:\Users\Muhammad Ilham\Documents\GitHub\Used-Car-Website-Database\bids.csv'
DELIMITER ','
CSV
HEADER;