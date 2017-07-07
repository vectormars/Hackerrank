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

Output:

Aamina(D) 

Ashley(P) 

Belvet(P) 

Britney(P) 

Christeen(S) 

Eve(A) 

Jane(S) 

Jennifer(A) 

Jenny(S) 

Julia(D) 

Ketty(A) 

Kristeen(S) 

Maria(P) 

Meera(P) 

Naomi(P) 

Priya(D) 

Priyanka(P) 

Samantha(A) 

There are a total of 3 doctors. 

There are a total of 4 actors. 

There are a total of 4 singers. 

There are a total of 7 professors.


### Example 3: Occupations

Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

#### SELECT
####     MIN(o.Doctor),MIN(o.Professor),MIN(o.Singer),MIN(o.Actor)
####  FROM
####      (SELECT
####         CASE WHEN occupation='Doctor' THEN @d:=@d+1
####              WHEN occupation='Professor' THEN @p:=@p+1
####              WHEN occupation='Singer' THEN @s:=@s+1
####              WHEN occupation='Actor' THEN @a:=@a+1 END AS row,
####         CASE WHEN occupation='Doctor' THEN name END AS Doctor,
####         CASE WHEN occupation='Professor' THEN name END AS Professor,
####         CASE WHEN occupation='Singer' THEN name END AS Singer,
####         CASE WHEN occupation='Actor' THEN name END AS Actor
####      FROM occupations JOIN (SELECT @d:=0, @p:=0, @s:=0,@a:=0) AS r 
####      ORDER BY name) o
#### GROUP BY row;

## Input Format

The BST table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Advanced%20Select/BST.png)

### Example 4: Binary Tree Nodes

You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.

Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:

* Root: If node is root node.
* Leaf: If node is leaf node.
* Inner: If node is neither root nor leaf node.







