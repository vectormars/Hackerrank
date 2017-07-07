
## Input Format

The CITY table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Select/CITY.jpg)

### Example 1: Revising Aggregations - The Count Function
Query a count of the number of cities in CITY having a Population larger than 100,000.
#### Select Count(*) from City
#### where Population > 100000

### Example 2: Revising Aggregations - The Sum Function
Query the total population of all cities in CITY where District is California.
#### Select sum(population) from City
#### where District = 'California'

### Example 3: Revising Aggregations - Averages
Query the average population of all cities in CITY where District is California.
#### Select avg(population) from City
#### where District = 'California'

### Example 4: Average Population
Query the average population for all cities in CITY, rounded down to the nearest integer.
#### Select floor(Avg(population)) from City

### Example 5: Japan Population
Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
#### Select Sum(Population) from City
#### where CountryCode = 'JPN'

### Example 6: Population Density Difference
Query the difference between the maximum and minimum populations in CITY.
#### Select max(population)-min(population) from City

## Input Format

The Employee table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Aggregation/employees.png)

### Example 7: The Blunder

Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's  key was broken until after completing the calculation. She wants your help finding the difference between her miscalculation (using salaries with any zeroes removed), and the actual average salary.

Write a query calculating the amount of error, and round it up to the next integer.

#### Select ceil(avg(salary)-avg(replace(salary,0,''))) from EMPLOYEES 



## Input Format

The Employee table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Select/Employee.png)

### Example 8: Top Earners
We define an employee's total earnings to be their monthly salary by months worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as 2 space-separated integers.





## Input Format

The Station table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Select/Station.jpg)

### Example 9: Weather Observation Station 2

Query the following two values from the STATION table:
1. The sum of all values in LAT_N rounded to a scale of 2 decimal places.
2. The sum of all values in LONG_W rounded to a scale of 2 decimal places.
#### Select round(sum(LAT_N),2),round(sum(LONG_W),2) from Station

### Example 10: Weather Observation Station 13
Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.2345. Truncate your answer to 4 decimal places.

#### Select round(sum(LAT_N),4) from STATION 
#### where LAT_N>38.7880 and LAT_N<137.2345

### Example 11: Weather Observation Station 14

Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345. Truncate your answer to 4 decimal places.
#### Select round(max(LAT_N),4) from STATION 
#### where LAT_N<137.2345

### Example 12: Weather Observation Station 15
Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345. Round your answer to 4 decimal places.

#### Select round(LONG_W,4) from Station
#### where LAT_N = (select max(LAT_N) from Station where LAT_N<137.2345) 

### Example 13: Weather Observation Station 16
Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780. Round your answer to 4 decimal places.

Select round(min(LAT_N),4) from STATION 
where LAT_N>38.7780

### Example 14: Weather Observation Station 17

Query the Western Longitude (LONG_W) for the smallest Northern Latitude (LAT_N) in STATION that is greater than 38.7780. Round your answer to 4 decimal places.

#### Select round(LONG_W,4) from STATION
#### where LAT_N = (Select min(LAT_N) from Station where LAT_N>38.7780) 

### Example 15: Weather Observation Station 18

Consider P1(a,b) and P2(c,d) to be two points on a 2D plane.

* a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
* b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
* c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
* d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places.
#### Select round(max(LAT_N)-min(LAT_N)+max(LONG_W)-min(LONG_W),4) from STATION 

### Example 16: Weather Observation Station 19
Consider P1(a,b) and P2(c,d) to be two points on a 2D plane where (a,b) are the respective minimum and maximum values of Northern Latitude (LAT_N) and  are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.

Query the Euclidean Distance between points P1 and P2 and format your answer to display 4 decimal digits
#### Select round(sqrt(((power((max(lat_n)- min(lat_n)),2)))+(power((max(long_w)- min(long_w)),2))),4) from station

### Example 17: Weather Observation Station 20
A median is defined as a number separating the higher half of a data set from the lower half. Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to 4 decimal places.

#### SELECT ROUND(S.LAT_N,4) from STATION S, STATION S1 
#### GROUP BY S.LAT_N 
#### HAVING SUM(SIGN(1-SIGN(S1.LAT_N - S.LAT_N))) = (COUNT(*)+1)/2













