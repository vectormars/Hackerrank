
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
