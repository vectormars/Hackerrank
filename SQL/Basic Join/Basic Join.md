## Input Format

The CITY and COUNTRY tables are described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Select/CITY.jpg)
![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Country.jpg)



### Example 1. Asian Population

Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

#### Select sum(CITY.Population) from CITY 
#### Join COUNTRY
#### on CITY.CountryCode = COUNTRY.Code
#### where COUNTRY.CONTINENT = 'Asia'

### Example 2. Asian Population

Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.

#### Select City.Name from CITY 
#### Join COUNTRY
#### on CITY.CountryCode = COUNTRY.Code
#### where COUNTRY.CONTINENT = 'Africa'

### Example 3. Average Population of Each Continent 
Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.

#### Select COUNTRY.Continent,floor(Avg(CITY.Population)) from CITY
#### Join COUNTRY
#### on CITY.CountryCode = COUNTRY.Code
#### group by CONTINENT


## Input Format

The Students and Grades tables are described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Student.png)
![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Grades.png)



