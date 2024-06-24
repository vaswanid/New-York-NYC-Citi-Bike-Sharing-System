
	   -- Average number of bike trips and may also want to compare YOY (year over year) changes
	   -- per day, i.e., Sunday, Monday,...Saturday
   
 SELECT EXTRACT(YEAR from starttime) as year,
   EXTRACT(DAY from starttime) as DAY, 
   -- EXTRACT(DAYOFWEEK from starttime) AS Day_of_week,
   avg(trips.countt) as avgtrip FROM (select count(*) as countt from citi_bikes)as trips
   cross join citi_bikes
   group BY year,day;
   -- , Day_of_week;
   
-- weekday versus weekend
	 SELECT EXTRACT(YEAR from starttime) as yearr,
	EXTRACT(DAY from starttime) as DAY,
	CASE
	WHEN 
	EXTRACT(WEEK from starttime) IN (6,7) THEN 'Weekend'
	ELSE 'Weekday'
	END AS columnnn,
	avg(trips.countt) as avgtrip FROM (select count(*) as countt from citi_bikes)as trips
	cross join citi_bikes 
	group BY yearr,dayy,columnnn;

 -- month
SELECT EXTRACT(YEAR from starttime) as year,
EXTRACT(MONTH from starttime) as MONTH,
avg(trips.countt) as avgtrip FROM (select count(*) as countt from citi_bikes)as trips
cross join citi_bikes
group BY year,MONTH;

-- calender week
SELECT EXTRACT(YEAR from starttime) as year,
EXTRACT(MONTH from starttime) as MONTH,
avg(trips.countt) as avgtrip FROM (select count(*) as countt from citi_bikes)as trips
cross join citi_bikes
group BY year,MONTH;


-- How many bike trips and what is the trend over time
-- calendar year (2017)
SELECT count(*) as number_of_trips, EXTRACT(YEAR FROM starttime) AS year, EXTRACT(MONTH  FROM starttime) AS MONTH  from citi_bikes
group by year, MONTH
having year = 2017;

	-- calendar month & year (2017-09)
	SELECT count(*) as number_of_trips, EXTRACT(YEAR FROM starttime) AS year,
	EXTRACT(MONTH FROM starttime) AS MONTH,EXTRACT(WEEK FROM starttime) AS WEEK from 
	group by year, MONTH,WEEK
	having (year = 2017 and MONTH=9);

-- calendar week (2017-36)
SELECT count(*) as number_of_trips, EXTRACT(YEAR FROM starttime) AS year,
EXTRACT(MONTH FROM starttime) AS MONTH,EXTRACT(WEEK FROM starttime) AS WEEK, EXTRACT(DAY FROM starttime) AS DAY from `steady-anagram-329601.dmdd_final.citibike_trips`
group by year, MONTH,WEEK,DAY
having (year = 2017 and MONTH=9 and WEEK=36);

-- calendar day (2017-09-01)
SELECT count(*) as number_of_trips, EXTRACT(YEAR FROM starttime) AS year,
EXTRACT(MONTH FROM starttime) AS MONTH,EXTRACT(WEEK FROM starttime) AS WEEK,
EXTRACT(DAY FROM starttime) AS DAY,
EXTRACT(HOUR FROM starttime) AS HOUR
from citi_bikes
group by year, MONTH,WEEK,DAY,HOUR
having (year = 2017 and MONTH=9 AND DAY=1);

-- GENDER ANALYSIS
-- How many trips - female vs male
SELECT * FROM citi_bikes_stations LIMIT 5;
-- How many trips - female vs male
SELECT gender, count(`start station id`) FROM citi_bikes
inner join citi_bikes_stations
on citi_bikes.`start station id` = citi_bikes_stations.Stations
group by gender
order by count(`start station id`);

-- Average length of trip - female vs male
SELECT count(*) no_of_trips,gender, usertype
FROM citi_bikes
group by gender,usertype
order by no_of_trips,usertype;

-- Subscriber versus customer trips - female vs male
SELECT gender, avg(tripduration / 60) as Average_Trip_Duration_in_Minutes FROM citi_bikes
group by gender
order by avg(tripduration / 60) desc;

-- Any trends from 2014 to 2020 regarding above
SELECT * FROM citi_bikes LIMIT 5;
SELECT  gender, count(`start station id`) as no_of_trips, EXTRACT(YEAR FROM starttime) AS year  FROM citi_bikes
inner join citi_bikes_stations
on citi_bikes.`start station id` = citi_bikes_stations.Stations
group by  year, gender
order by count(`start station id`) desc;

-- AGE ANALYSIS
-- Age analysis (note: age at the time of the ride i.e., age is year of bike trip vs birth year)
SELECT EXTRACT(YEAR FROM starttime) FROM citi_bikes limit 5;
-- What are the number of trips per age
	SELECT count(*) as no_of_trips,(ride_year-birth)as age,birth,
	ride_year from (select distinct(`birth year`) as birth,
	extract(YEAR from starttime) as ride_year from citi_bikes
	group by birth,ride_year) as sub
	group by age,birth,ride_year
	order by no_of_trips desc;

-- Average length of trip per age

SELECT avg(tripduration / 60) as Average_Trip ,(ride_year-birth)as age,birth,
ride_year from 
(select distinct(`birth year`) as birth,
extract(year from starttime) as ride_year,tripduration from citi_bikes
group by birth,ride_year,tripduration) sub
group by age,birth,ride_year;

-- Subscriber versus customer trips – per age

SELECT usertype,(ride_year-birth)as age,birth,
ride_year from
(select distinct(`birth year`) as birth,
extract(year from starttime) as ride_year,usertype from citi_bikes
group by birth,ride_year,usertype) sub
group by usertype,age,birth,ride_year;

-- Subscriber versus customer trips – per age

  -- Subscriber versus customer grouped together query
SELECT usertype,(ride_year-birth)as age,birth,
ride_year from 
(select distinct(`birth year`) as birth,
extract(year from starttime) as ride_year,usertype from citi_bikes
group by birth,ride_year,usertype) sub
group by usertype,age,birth,ride_year;

  -- Subscriber versus customer individual query
SELECT usertype,(ride_year-birth)as age,birth,
ride_year from 
   (select distinct(`birth year`) as birth,
   extract(year from starttime) as ride_year,usertype from citi_bikes
   group by birth,ride_year,usertype) sub
   where usertype = "Customer"
group by usertype,age,birth,ride_year;

SELECT usertype,(ride_year-birth)as age,birth,
ride_year from 
   (select distinct(`birth year`) as birth,
   extract(year from starttime) as ride_year,usertype from citi_bikes
   group by birth,ride_year,usertype) sub
   where usertype = "Subscriber"
group by usertype,age,birth,ride_year;

-- Any trends from 2014 to 2020 regarding above
SELECT count(*) as no_of_trips,(ride_year-birth)as age,birth,
ride_year from (select distinct(`birth year`) as birth,
extract(year from starttime) as ride_year from citi_bikes
group by birth,ride_year) group by age,birth,ride_year
order by no_of_trips desc;


-- BIKE ANALYSIS
-- What are the top 5 bikes (bike id) for latest (full) year by
    -- Total trips
select distinct bikeid, count(*) as total_trips, EXTRACT(YEAR FROM starttime) as Year from citi_bikes
group by bikeid, Year
order by Year desc, total_trips desc limit 5;	

-- Total time
select distinct bikeid,(tripduration/60) as trip_duation_minutes, EXTRACT(YEAR FROM starttime) as Year from citi_bikes
group by bikeid, Year, trip_duation_minutes
order by Year desc, trip_duation_minutes desc limit 5;

-- Average trip time
select distinct bikeid,avg(tripduration / 60) as Average_Trip_minutes, EXTRACT(YEAR FROM starttime) as Year from citi_bikes 
group by bikeid, Year
order by Year desc, Average_Trip_minutes desc limit 5;

-- For top bike (by total trips) create a history for the latest (full) year
-- Bike id
select distinct bikeid, count(*) as total_trips, EXTRACT(YEAR FROM starttime) as Year from citi_bikes
group by bikeid, Year
order by Year desc, total_trips desc,  bikeid desc ;

-- Route (state and end location)
select distinct(bikeid),count(*) as TotalTrips,EXTRACT(YEAR FROM starttime) AS year,start_station_id,end_station_id
FROM citi_bikes
group by bikeid,year,start station id,end_station_id
order by year desc,TotalTrips desc;

-- Start time
select distinct(bikeid),count(*) as TotalTrips,EXTRACT(YEAR FROM starttime) AS year,starttime
FROM citi_bikes
group by bikeid,year,starttime
order by year desc,starttime desc;

 
-- Duration
select distinct(bikeid),count(*) as TotalTrips,
(tripduration/60) TripDurationInMin,
EXTRACT(YEAR FROM starttime) AS year
FROM citi_bikes
group by bikeid,year,TripDurationInMin
order by year desc,TripDurationInMin desc;


SELECT EXTRACT(HOUR from starttime) as hour, count(*) as biketrips
from citi_bikes
where (starttime > '2013-06-01' and  starttime < '2021-12-07')
group by hour
order by hour;

SELECT (select count(*) as common_trip from citi_bikes where start_station_name = end_station_name) as round,
(select count(*) as diff_trip from citi_bikes where start_station_name != end_station_name) as nonround 
from citi_bikes group by round,nonround;

SELECT EXTRACT(HOUR from starttime) as hour, count(*) as biketrips
from citi_bikes
group by hour
order by hour;

SELECT (select count(*) as common_trip from citi_bikes where start_station_name = end_station_name) as round,
(select count(*) as diff_trip from citi_bikes where start_station_name != end_station_name) as nonround 
from citi_bikes group by round,nonround;

SELECT (select count(*) as common_trip from citi_bikes where start_station_name = end_station_name) as round,
(select count(*) as diff_trip from citi_bikes where start_station_name != end_station_name) as nonround , usertype
from citi_bikes group by round,nonround, usertype;

SELECT (select count(*) as common_trip from citi_bikes where start_station_name = end_station_name) as round,
(select count(*) as diff_trip from citi_bikes where start_station_name != end_station_name) as nonround , usertype, avg(tripduration) as tripduration
from citi_bikes group by round,nonround, usertype;

SELECT avg(tripduration / 60) as Average_Trip FROM citi_bikes;

SELECT avg(tripduration / 60) as Average_Trip FROM citi_bikes
 where usertype='Subscriber' ;

SELECT avg(tripduration / 60) as Average_Trip FROM citi_bikes
where usertype='Customer' ;

select count(*) as count from citi_bikes
 where (tripduration/60) < 15;
 


SELECT count(*) as no_of_trips FROM citi_bikes
where (tripduration / 60) > 60 ;
 
SELECT start_station_id,start_station_name, count(station_id) as no_of_trips FROM citi_bikes
inner join citi_bikes
on Station_id = start_station_id 
group by start_station_id, start_station_name
order by count(start_station_id) desc
limit 10;

SELECT start_station_id,start_station_name, count(station_id) as no_of_trips FROM citi_bikes 
inner join citi_bikes
on Station_id = start_station_id 
group by start_station_id, start_station_name
order by count(start_station_id) desc
limit 10;
 -- As a trip destination

SELECT end_station_id, end_station_name, count(end_station_id) as no_of_trips FROM citi_bikes
inner join citi_bikes
on Station_id = end_station_id 
group by end_station_id, end_station_name
order by count(end_station_id) desc
limit 10;


select count(*) as no_of_trips from citi_bikes
 inner join citi_bikes
 on Station_id = start_station_id
 and Station_id = end_station_id
 order by no_of_trips desc;
 
 select count(*) as no_of_trips, u.usertype from citi_bikes
 inner join citi_bikes as u
 on Station_id = start_station_id
 and Station_id = end_station_id
 where u.usertype in ('Subscriber','Customer')
 group by u.usertype
 order by no_of_trips desc,no_of_trips;


SELECT count(bikeid) AS no_of_trips,start_station_name, end_station_name,
CASE WHEN
(EXTRACT(DAYOFWEEK FROM (starttime))IN (1,7)) THEN "WEEKEND"
ELSE "WEEKDAY"
END AS TYPE_OF_DAY
FROM city_
where usertype != ""
group by start_station_name,end_station_name,TYPE_OF_DAY
order by count(bikeid) desc