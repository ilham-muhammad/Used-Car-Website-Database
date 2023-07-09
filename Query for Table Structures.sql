-- Final Project RDB & SQL - SE/DE Batch 2 Pacmann
-- Task : Creating Table Structures
-- Author : Muhammad Ilham


-- Creating table : City
CREATE TABLE City(
	city_id int UNIQUE PRIMARY KEY NOT NUll,
	city varchar(50) NOT NULL,
	province varchar(50),
	postal_code int,
	location point
)

-- Creating table : Cars
CREATE TABLE Cars(
	car_id int UNIQUE NOT NULL,
	car_brand varchar(50) NOT NULL,
	car_model varchar(50) NOT NULL,
	car_type varchar(50) NOT NULL,
	trans_type varchar(50) NOT NULL
)

-- Creating table : Users
CREATE TABLE Users(
	user_id int UNIQUE PRIMARY KEY NOT NUll,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	phone int NOT NULL,
	address text NOT NULL,
	city_id int NOT NULL,
	-- Add constrain : foreign key city_id
	CONSTRAINT fk_City
		FOREIGN KEY(city_id)
		REFERENCES City(city_id)
		ON DELETE RESTRICT
)

-- Creating table : Advertisements
CREATE TABLE Advertisements(
	ads_id int UNIQUE PRIMARY KEY NOT NUll,
	user_id int NOT NULL,
	car_id int NOT NULL,
	title text NOT NULL,
	posting_date date,
	year_built int NOT NULL CHECK(year_built >= 0),
	color varchar(50) NOT NULL,
	mileage int NOT NULL CHECK(mileage >= 0),
	price int NOT NULL CHECK(price >= 0),
	-- Add constrain : foreign key user_id
	CONSTRAINT fk_User
		FOREIGN KEY(user_id)
		REFERENCES Users(user_id)
		ON DELETE RESTRICT,
	-- Add constrain : foreign key car_id
	CONSTRAINT fk_Cars
		FOREIGN KEY(car_id)
		REFERENCES Cars(car_id)
		ON DELETE RESTRICT
)

-- Creating table : Bids
CREATE TABLE Bids(
	bid_id int UNIQUE NOT NULL,
	user_id int NOT NULL,
	ads_id int NOT NULL,
	bid_date date,
	bid_price int NOT NULL CHECK(bid_price >= 0),
	-- Add constrain : foreign key user_id
	CONSTRAINT fk_User
		FOREIGN KEY(user_id)
		REFERENCES Users(user_id)
		ON DELETE RESTRICT,
	-- Add constrain : foreign key ads_id
	CONSTRAINT fk_Ads
		FOREIGN KEY(ads_id)
		REFERENCES Advertisements(ads_id)
		ON DELETE RESTRICT
)

