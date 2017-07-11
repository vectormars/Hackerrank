
## Input Format

The Students, Friends and Packages table are described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Advanced%20Join/Friends.png)

### Example 2: Placements

Write a query to output the names of those students whose best friends got offered a higher salary than them. Names must be ordered by the salary amount offered to the best friends. It is guaranteed that no two students got same salary offer.

**Approach 1**:

#### Select T2.name from
#### (Select F1.ID,P1.Salary as Friend_Salary from Friends F1
#### Join Packages P1
#### on F1.Friend_ID = P1.ID) T1
#### join
#### (Select S1.name,S1.ID,P2.Salary as Self_Salary from Students S1
#### Join Packages P2
#### on S1.ID = P2.ID) T2
#### on T1.ID = T2.ID
#### where T1.Friend_Salary > T2.Self_Salary
#### order by T1.Friend_Salary


**Approach 2**:

#### Select S.Name
#### From ( Students S join Friends F Using(ID)
####        join Packages P1 on S.ID=P1.ID
####        join Packages P2 on F.Friend_ID=P2.ID)
#### Where P2.Salary > P1.Salary
#### Order By P2.Salary;
