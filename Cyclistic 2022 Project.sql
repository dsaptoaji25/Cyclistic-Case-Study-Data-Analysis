--Creating Table
CREATE TABLE IF NOT EXISTS public.bike
(
    ride_id character varying COLLATE pg_catalog."default" NOT NULL,
    rideable_type character varying COLLATE pg_catalog."default",
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    start_station_name character varying COLLATE pg_catalog."default",
    start_station_id character varying COLLATE pg_catalog."default",
    end_station_name character varying COLLATE pg_catalog."default",
    end_station_id character varying COLLATE pg_catalog."default",
    start_lat numeric,
    start_lng numeric,
    end_lat numeric,
    end_lng numeric,
    member_casual character varying COLLATE pg_catalog."default",
    CONSTRAINT ride_pkey PRIMARY KEY (ride_id)
)

--Importing datasets
COPY bike
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202201-divvy-tripdata.csv'
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202202-divvy-tripdata.csv'
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202203-divvy-tripdata.csv'
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202204-divvy-tripdata.csv'
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202205-divvy-tripdata.csv'
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202206-divvy-tripdata.csv'
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202207-divvy-tripdata.csv'
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202208-divvy-tripdata.csv'
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202209-divvy-tripdata.csv'
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202210-divvy-tripdata.csv'
--FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202211-divvy-tripdata.csv'
FROM 'F:\Project_DA_Capstone_Project\Cyclistic_2022_Datasets\202212-divvy-tripdata.csv'
DELIMITER ','
CSV Header;

--Cleaning Data
SELECT *
FROM bike
WHERE
	(start_lat != end_lat AND start_lng != end_lng)
	AND
	(ended_at - started_at) > '00:00:00'
	AND
	start_station_name IS NOT NULL
	AND
	end_station_name IS NOT NULL;
	
	
--Analyze the data

-- Total Number of Trips per month
SELECT TO_CHAR(started_at, 'fmMonth') AS month, member_casual, COUNT(*) AS total_trip
FROM bike_cleaned
--WHERE member_casual = 'casual'
--WHERE member_casual = 'member'
GROUP BY month, member_casual
ORDER BY total_trip DESC

-- Total Number of Trips per Day
SELECT to_char(started_at, 'Day') AS week_day, COUNT(*) AS total_trip
FROM bike_cleaned
--WHERE member_casual = 'casual'
--WHERE member_casual = 'member'
GROUP BY week_day
ORDER BY total_trip DESC

-- Total Trips per Bicycle Type
SELECT rideable_type, member_casual, COUNT(*) AS total_rides
FROM bike_cleaned
GROUP BY rideable_type, member_casual
ORDER BY rideable_type DESC

-- Average Trip Duration per Day
SELECT member_casual, to_char(started_at, 'Day') AS week_day, AVG(ended_at - started_at) AS duration
FROM bike_cleaned
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
	--AND member_casual = 'casual'
	--AND member_casual = 'member'
GROUP BY week_day, member_casual

--Average Duration per month
SELECT member_casual, to_char(started_at, 'fmMonth') AS month, AVG(ended_at - started_at) AS avg_duration
FROM bike_cleaned
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
	--AND member_casual = 'casual'
	--AND member_casual = 'member'
GROUP BY month, member_casual

-- Average Trip Duration in 1 Year (2022)
SELECT member_casual, AVG(ended_at - started_at) AS duration
FROM bike_cleaned
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
GROUP BY member_casual

-- Number of Riders per Hour
SELECT EXTRACT(hour FROM started_at) AS started_hour, member_casual, COUNT(*)
FROM bike_cleaned
--WHERE member_casual = 'casual'
--WHERE member_casual = 'member'
GROUP BY started_hour, member_casual
ORDER BY COUNT(*) DESC

-- Top 10 Busiest Stations 
SELECT start_station_name, member_casual, COUNT(*) AS total_trip
FROM bike
WHERE start_station_name IS NOT NULL
	--AND member_casual = 'casual'
	--AND member_casual = 'member'
GROUP BY start_station_name, member_casual
ORDER BY total_trip DESC
LIMIT 10