## Input Format

The TRIANGLES table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Advanced%20Select/TRIANGLES.png)

### Example 1: Type of Triangle

Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:

* Equilateral: It's a triangle with 3 sides of equal length.
* Isosceles: It's a triangle with 2 sides of equal length.
* Scalene: It's a triangle with 3 sides of differing lengths.
* Not A Triangle: The given values of A, B, and C don't form a triangle.

#### select
#### 	case
#### 		when A=B and B=C then 'Equilateral'
#### 		when A+B <= C then 'Not A Triangle'
#### 		when B+C <= A then 'Not A Triangle'
#### 		when A+C <= B then 'Not A Triangle'	
#### 		when A+B > C and A=B then 'Isosceles'
#### 		when B+C > A and C=B then 'Isosceles'
#### 		when A+C > B and A=C then 'Isosceles'
#### 		else 'Scalene'
#### 	end
#### from TRIANGLES 

Output:

Equilateral 

Equilateral 

Isosceles 

Equilateral 

Isosceles 

Equilateral 

Scalene 

Not A Triangle 

Scalene 

Scalene 

Scalene 

Not A Triangle 

Not A Triangle 

Scalene 

Equilateral 

## Input Format

The OCCUPATIONS table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Advanced%20Select/OCCUPATIONS.png)

### Example 2: The PADS

Generate the following two result sets:

1. Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).

2. Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format: 

There are a total of [occupation_count] [occupation]s.

where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the lowercase occupation name. If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.

#### Select concat(Name,'(',left(Occupation,1),')') as New From Occupations order by New;
#### Select concat('There are a total of ',count(Occupation),' ',lower(Occupation),'s.') from Occupations 
#### Group by Occupation
#### Order by count(Occupation),lower(Occupation);



