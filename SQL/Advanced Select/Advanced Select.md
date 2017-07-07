## Input Format

The TRIANGLES table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Advanced%20Select/TRIANGLES.png)

### Example 1: Type of Triangle

Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:

* Equilateral: It's a triangle with  sides of equal length.
* Isosceles: It's a triangle with  sides of equal length.
* Scalene: It's a triangle with  sides of differing lengths.
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
