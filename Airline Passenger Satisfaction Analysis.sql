-- CASE STUDY: AIRLINE PASSENGER SATISFACTION ANALYSIS FOR BUSINESS DECISION-MAKING
-- PROJECT EXECUTED BY: SAMUEL EFFIOM

-- TABLE OF CONTENT

-- Introduction
-- About the Dataset 
-- Data Analysis
-- Conclusion/Recommendation


/* INTRODUCTION

In this project, the Customer satisfaction scores from 120,000+ airline passengers, including additional information about each passenger, their flight, and type of travel,
as well as ther evaluation of different factors like cleanliness, comfort, service, and overall experience will be analysed and certain key insights drawn to aid the improvement
of the airlines services and in turn improve overall business performance.*/


/* ABOUT THE DATASET

This dataset was culled from Maven Analytics, "link - https://mavenanalytics.io/data-playground?page=2&pageSize=5 ." The dataset has 120,000+ unique rows and 24 columns.*/


/* PROJECT OBJECTIVES

In this project we will look to discovering the following;

1. Which percentage of airline passengers are satisfied? Does it vary by customer type? What about type of travel?

2. What is the customer profile for a repeating airline passenger?

3. Does flight distance affect customer preferences or flight patterns?

4. Which factors contribute to customer satisfaction the most? What about dissatisfaction? */


-- DATA ANALYSIS

-- To get a first look of our dataset
SELECT *
FROM airline_passenger_satisfaction
-- RESULT: The dataset has 129,880 rows and 24 columns.


-- Check to ensure the dataset has no duplicate rows
SELECT COUNT(DISTINCT[ID]) as Distinct_IDs
FROM airline_passenger_satisfaction
-- RESULT: The result shows that the dataset has 129,880 distinct rows, hence there are no duplicate records in the dataset.


-- I will then proceed to answer questions from our project objectives.

-- 1. Which percentage of airline passengers are satisfied? Does it vary by customer type? What about type of travel?

-- To get percentage of airline passengers that are satisfied
SELECT
  COUNT(*) AS total_passengers,
  SUM(CASE WHEN Satisfaction = 'satisfied' THEN 1 ELSE 0 END) AS satisfied_passengers,
  (CAST(SUM(CASE WHEN Satisfaction = 'satisfied' THEN 1 ELSE 0 END) AS DECIMAL) / COUNT(*)) * 100 AS satisfaction_percentage
FROM
  airline_passenger_satisfaction;
-- RESULT: This query shows that 43.45% of the airlines passengers are satisfied with their services.



-- Satisfaction percentage by customer type
SELECT
  [Customer Type],
  COUNT(*) AS total_passengers,
  SUM(CASE WHEN Satisfaction = 'satisfied' THEN 1 ELSE 0 END) AS satisfied_passengers,
  (CAST(SUM(CASE WHEN Satisfaction = 'satisfied' THEN 1 ELSE 0 END) AS DECIMAL) / COUNT(*)) * 100 AS satisfaction_percentage
FROM
  airline_passenger_satisfaction
GROUP BY
  [customer Type];
-- RESULT: First time passengers record a lower satisfaction rate at 23.97%, compared with Returning passengers who record 47.81% satisfaction rate.


-- Satisfaction percentage by type of travel
SELECT
  [Type of Travel],
  COUNT(*) AS total_passengers,
  SUM(CASE WHEN satisfaction = 'satisfied' THEN 1 ELSE 0 END) AS satisfied_passengers,
  (CAST(SUM(CASE WHEN satisfaction = 'satisfied' THEN 1 ELSE 0 END) AS DECIMAL) / COUNT(*)) * 100 AS satisfaction_percentage
FROM
  airline_passenger_satisfaction
GROUP BY
  [Type of Travel];
-- RESULT: Airline passengers who travel for business reasons recorded a 58.37% satisfaction rate, those who travel for personal reasons don't quite share the same sentiments as they recorded a 10.13% satisfaction rate.



-- 2. What is the customer profile for a repeating airline passenger?

/*But first we will ascertain the count of returning passengers on the airline.*/

SELECT COUNT(*)
FROM airline_passenger_satisfaction
WHERE [Customer Type] = 'Returning'
-- RESULT: The number of returning passengers stands at 106,100


/*To determine the customer profile for a returning airline passenger, i will identify the common attributes among passengers who have flown with the airline multiple times.*/

SELECT
  Gender,
  Age,
  [customer Type],
  [Type of Travel],
  Class,
  AVG([Flight Distance]) AS average_flight_distance
FROM
  airline_passenger_satisfaction
WHERE
  [Customer Type] = 'Returning'
GROUP BY
  gender,
  age,
  [Customer Type],
  [Type of Travel],
  Class;
-- RESULT: The resulting query with common attributes among returning passengers, records 832 different customer profiles.




-- 3. Does flight distance affect customer preferences or flight patterns?

-- Percentage passenger satisfaction by flight distance
SELECT
COUNT(*) AS total_passengers,
  CASE
    WHEN [Flight Distance] < 1000 THEN 'Short Haul'
    WHEN [Flight Distance] >= 1000 AND [Flight Distance] < 3000 THEN 'Medium Haul'
    WHEN [Flight Distance] >= 3000 THEN 'Long Haul'
    ELSE 'Unknown'
  END AS [haul type],
  (CAST(SUM(CASE WHEN satisfaction = 'satisfied' THEN 1 ELSE 0 END) AS DECIMAL(10,2)) / COUNT(*)) * 100 AS percentage_satisfaction
FROM
  airline_passenger_satisfaction
GROUP BY
  CASE
    WHEN [Flight Distance] < 1000 THEN 'Short Haul'
    WHEN [Flight Distance] >= 1000 AND [Flight Distance] < 3000 THEN 'Medium Haul'
    WHEN [Flight Distance] >= 3000 THEN 'Long Haul'
    ELSE 'Unknown' 
  END
ORDER BY percentage_satisfaction DESC;

-- RESULT: The results show that passengers with significantly longer flight distance posed more percentage satisfaction compared with passengers with a shorter flight distance.


-- Average seat comfort by flight distance and class
SELECT
  CASE
    WHEN [Flight Distance] < 1000 THEN 'Short Haul'
    WHEN [Flight Distance] >= 1000 AND [Flight Distance] < 3000 THEN 'Medium Haul'
    WHEN [Flight Distance] >= 3000 THEN 'Long Haul'
    ELSE 'Unknown'
  END AS haul_type,
  Class,
  CAST(AVG([Seat Comfort]) AS DECIMAL (10,2)) AS average_seat_comfort
FROM
  airline_passenger_satisfaction
GROUP BY
Class,
  CASE
    WHEN [Flight Distance] < 1000 THEN 'Short Haul'
    WHEN [Flight Distance] >= 1000 AND [Flight Distance] < 3000 THEN 'Medium Haul'
    WHEN [Flight Distance] >= 3000 THEN 'Long Haul'
    ELSE 'Unknown'
  END
ORDER BY average_seat_comfort DESC;
-- RESULT: Passengers who travel business class experience much higher average seat comfort than other travel classes.



-- 4. Which factors contribute to customer satisfaction the most? What about dissatisfaction?

-- Factors contributing to customer satisfaction

SELECT
  factor,
  average_rating
FROM
  (
    SELECT
      'Departure and Arrival Time Convenience' AS factor,
      AVG(CAST([Departure and Arrival Time Convenience] AS DECIMAL(10, 2))) AS average_rating
    FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'Ease of Online Booking' AS factor,
      AVG(CAST([Ease of Online Booking] AS DECIMAL(10, 2))) AS average_rating
    FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'Check-in Service' AS factor,
      AVG(CAST([Check-in Service] AS DECIMAL(10, 2))) AS average_rating
    FROM
	airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'Online Boarding' AS factor,
      AVG(CAST([Online Boarding] AS DECIMAL(10, 2))) AS average_rating
    FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'Gate Location' AS factor,
      AVG(CAST([Gate Location] AS DECIMAL(10, 2))) AS average_rating
    FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
	'On-board Service' AS factor,
      AVG(CAST([On-board Service] AS DECIMAL(10, 2))) AS average_rating
    FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'Seat Comfort' AS factor,
      AVG(CAST([Seat Comfort] AS DECIMAL(10, 2))) AS average_rating
    FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'Leg Room Service' AS factor,
      AVG(CAST([Leg Room Service] AS DECIMAL(10, 2))) AS average_rating
    FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'Cleanliness' AS factor,
      AVG(CAST([Cleanliness] AS DECIMAL(10, 2))) AS average_rating
FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'Food and Drink' AS factor,
      AVG(CAST([Food and Drink] AS DECIMAL(10, 2))) AS average_rating
    FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'In-flight Service' AS factor,
      AVG(CAST([In-flight Service] AS DECIMAL(10, 2))) AS average_rating
    FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'In-flight Wifi Service' AS factor,
      AVG(CAST([In-flight Wifi Service] AS DECIMAL(10, 2))) AS average_rating
    FROM
	 airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'In-flight Entertainment' AS factor,
      AVG(CAST([In-flight Entertainment] AS DECIMAL(10, 2))) AS average_rating
FROM
      airline_passenger_satisfaction
    WHERE
      satisfaction = 'satisfied'
    UNION ALL
    SELECT
      'Baggage Handling' AS factor,
	  AVG(CAST([Baggage Handling] AS DECIMAL(10, 2))) AS average_rating
FROM
      airline_passenger_satisfaction
    WHERE
	satisfaction = 'satisfied'
	) AS factors
ORDER BY average_rating DESC;

-- RESULT: The airline passengers are most satisfied by the Online Boarding, In-flight Service and Baggage Handling respectively as they have the highest average satisfaction.
-- A visualisation of this analysis was done using Tableau and can be viewed using the link: https://public.tableau.com/app/profile/samuel.effiom/viz/AirlinePassengerSatisfactionAnalysis_16887619049700/Dashboard1 






