## Input Format

The CITY table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Select/CITY.jpg)

### Example 1: Revising the Select Query I

Query all **columns** for all American cities in CITY with populations larger than 100000. The CountryCode for America is USA.

#### Select * from CITY

#### where Population >= 100000 and CountryCode = "USA"

Output:

3878 Scottsdale USA Arizona 202705 

3965 Corona USA California 124966 

3973 Concord USA California 121780 

3977 Cedar Rapids USA Iowa 120758 

3982 Coral Springs USA Florida 117549

### Example 2: Revising the Select Query II

Query the **names** of all American cities in CITY with populations larger than 120000. The CountryCode for America is USA.

#### Select name from CITY

#### where Population >= 120000 and CountryCode = "USA"

Output:

Scottsdale

Corona

Concord

Cedar Rapids

### Example 3: Select All

Query all columns (attributes) for every row in the CITY table.

#### Select * from CITY

Output:

6 Rotterdam NLD Zuid-Holland 593321 

3878 Scottsdale USA Arizona 202705 

3965 Corona USA California 124966 

3973 Concord USA California 121780 

3977 Cedar Rapids USA Iowa 120758 

3982 Coral Springs USA Florida 117549 

4054 Fairfield USA California 92256 

4058 Boulder USA Colorado 91238 

4061 Fall River USA Massachusetts 90555 


### Example 4: Select By ID

Query all columns for a city in CITY with the ID 1661.

#### select * from City

#### where ID = 1661

Output:

1661 Sayama JPN Saitama 162472 


### Example 5: Japanese Cities' Attributes

Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.

#### select * from City

#### where Countrycode = "JPN"

Output:

1613 Neyagawa JPN Osaka 257315 

1630 Ageo JPN Saitama 209442 

1661 Sayama JPN Saitama 162472 

1681 Omuta JPN Fukuoka 142889 

1739 Tokuyama JPN Yamaguchi 107078 

### Example 6: Japanese Cities' Names

Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.

#### select name from City

#### where Countrycode = "JPN"

Output:

Neyagawa 

Ageo 

Sayama 

Omuta 

Tokuyama 

## Input Format

The Station table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Select/Station.jpg)


### Example 7: Weather Observation Station 1

Query a list of CITY and STATE from the STATION table.

#### Select City, State from STATION 

### Example 8: Weather Observation Station 3

Query a list of CITY names from STATION with **even** ID numbers only. You may print the results in any order, but must exclude duplicates from your answer.

#### select distinct city from station

#### where mod(id, 2) = 0;

### Example 9: Weather Observation Station 4

Let N be the number of CITY entries in STATION, and let N' be the number of distinct CITY names in STATION; query the value of N-N' from STATION. In other words, find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.

#### select count(city)-count(distinct city) from Station

Output: 13

### Example 9: Weather Observation Station 5

Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.

#### (select City,length(City) from STATION  order by length(City) asc, city asc limit 1)

#### UNION

#### (select City,length(City) from STATION  order by length(City) desc, city asc limit 1)

Output:

Amo 3 

Marine On Saint Croix 21 

### Example 10: Weather Observation Station 6

Query the list of CITY names **starting with** vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.

#### select distinct city from station
#### where city REGEXP '^[a|e|i|o|u].*$'

### Example 11: Weather Observation Station 7

Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.

#### select distinct city from station
#### where city REGEXP '^.*[a|e|i|o|u]$'

### Example 12: Weather Observation Station 8

Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.

#### select distinct city from station
#### where city REGEXP '^[a|e|i|o|u].*[a|e|i|o|u]$'

### Example 13: Weather Observation Station 9

Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.

#### select distinct city from station
#### where city not REGEXP '^[a|e|i|o|u].*$'

### Example 14: Weather Observation Station 10

Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.

#### select distinct city from station
#### where city not REGEXP '^.*[a|e|i|o|u]$'

### Example 15: Weather Observation Station 11

Query the list of CITY names from STATION that either do not start with vowels **or** do not end with vowels. Your result cannot contain duplicates.

#### Select distinct city from station
#### where city not REGEXP '^[a|e|i|o|u].\*$' or city not REGEXP '^.\*[a|e|i|o|u]$'

### Example 16: Weather Observation Station 12

Query the list of CITY names from STATION that do not start with vowels **and** do not end with vowels. Your result cannot contain duplicates.

#### select distinct city from station
#### where city not REGEXP '^[a|e|i|o|u].\*$' and city not REGEXP '^.\*[a|e|i|o|u]$'

## Input Format

The Student table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Select/student-1.png)

### Example 17: Higher Than 75 Marks

Query the Name of any student in STUDENTS who scored higher than 75 Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID

#### select name from STUDENTS 
#### where Marks>75
#### order by SUBSTRING(Name,-3),ID

## Input Format

The Employee table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Select/Employee.png)

### Example 18: Employee Names

Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.

#### select name from Employee 
#### order by name

### Example 19: Employee Salaries

Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than $2000 per month who have been employees for less than 10 months. Sort your result by ascending employee_id.

#### select name from Employee 
#### where months < 10 and salary > 2000
#### order by employee_id asc


### Example 20: 
Show the name and the population for 'Sweden', 'Norway' and 'Denmark'.
#### SELECT name, population FROM world
#### WHERE name IN ('Sweden', 'Norway', 'Denmark')

### Example 21: 
Which countries are not too small and not too big? BETWEEN allows range checking (range specified is inclusive of boundary values). The example below shows countries with an area of 250,000-300,000 sq. km. 
#### SELECT name, area FROM world
#### WHERE area BETWEEN 200000 AND 250000


### Example 22: 
Show the countries which have a name that includes the word 'United'
#### Select name from world
#### where name regexp 'United'

### Example 23: 
Exclusive OR (**XOR**). Show the countries that are big by area or big by population but not both. Show name, population and area.
(Either one of, but not both)
#### Select name,population,area from world
#### where population>250000000 xor area >3000000

### Example 23: 
Show the name and per-capita GDP for those countries with a GDP of at least one trillion (1000000000000; that is 12 zeros). Round this value to the **nearest 1000**.
#### Select name, round((gdp/population),-3) from world
#### where GDP > 1000000000000

### Example 24
The capital of Sweden is Stockholm. Both words start with the letter 'S'.

Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.

#### SELECT name, capital FROM world
#### where LEFT(name,1)=LEFT(capital ,1) and name <> capital 





