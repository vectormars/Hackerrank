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

### Example 4. The Report
Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. Ketty doesn't want the NAMES of those students who received a grade lower than 8. The report must be in descending order by grade -- i.e. higher grades are entered first. If there is more than one student with the same grade (8-10) assigned to them, order those particular students by their name alphabetically. Finally, if the grade is lower than 8, use "NULL" as their name and list them by their grades in descending order. If there is more than one student with the same grade (1-7) assigned to them, order those particular students by their marks in ascending order.

Write a query to help Eve.

#### Select if(Grades.Grade < 8, concat('NULL'),Students.Name), Grades.Grade, Students.Marks from Students 
#### Join Grades
#### On Students.Marks >= Grades.Min_Mark and Students.Marks <= Grades.Max_Mark 
#### Order by Grades.Grade desc, Students.Name, Students.Marks asc

## Input Format

The Hackers, Difficulty, Challenges and Submissions tables are described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Hackers.png)
![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Difficulty.png)
![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Challenges.png)
![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Submissions.png)


### Example 5. Top Competitors
Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! Write a query to print the respective hacker_id and name of hackers who achieved full scores for more than one challenge. Order your output in descending order by the total number of challenges in which the hacker earned a full score. If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.
#### Select H.hacker_id, H.name from Submissions S
#### inner join Challenges C
#### on S.challenge_id = C.challenge_id
#### inner join Difficulty D
#### on C.difficulty_level = D.difficulty_level 
#### inner join Hackers H
#### on S.hacker_id = H.hacker_id
#### where S.score = D.score and C.difficulty_level = D.difficulty_level
#### group by H.hacker_id, H.name
#### having count(S.hacker_id) > 1
#### order by count(S.hacker_id) desc, S.hacker_id asc

### Example 6. Contest Leaderboard

You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too!

The total score of a hacker is the sum of their maximum scores for all of the challenges. Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score. If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. Exclude all hackers with a total score of  from your result.


## Input Format

The Wands and Wands_Property tables are described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Wands.png)
![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Wands_Property.png)

### Example 7. Ollivander's Inventory

Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.

Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age. Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. If more than one wand has same power, sort the result in order of descending age.

#### select W.id, WP.age, W.coins_needed, W.power from Wands as W 
#### join Wands_Property as WP
#### on W.code = WP.code 
#### where WP.is_evil = 0 and W.coins_needed=(Select min(W1.coins_needed) from Wands as W1 join Wands_Property as WP1 on (W1.code = WP1.code) where W1.power = W.power and WP1.age = WP.age)
#### order by W.power desc, WP.age desc

## Input Format

The Hackers and Challenges tables are described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Hackers.png)
![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Join/Challenge.png)

### Example 8. Challenges 

Julia asked her students to create some coding challenges. Write a query to print the hacker_id, name, and the total number of challenges created by each student. Sort your results by the total number of challenges in descending order. If more than one student created the same number of challenges, then sort the result by hacker_id. If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result.
