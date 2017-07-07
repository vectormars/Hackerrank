
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

### Example 3: Revising Aggregations - Averages
Query the average population for all cities in CITY, rounded down to the nearest integer.
