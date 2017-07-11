Select T2.name from
(Select F1.ID,P1.Salary as Friend_Salary from Friends F1
Join Packages P1
on F1.Friend_ID = P1.ID) T1
join
(Select S1.name,S1.ID,P2.Salary as Self_Salary from Students S1
Join Packages P2
on S1.ID = P2.ID) T2
on T1.ID = T2.ID
where T1.Friend_Salary > T2.Self_Salary
order by T1.Friend_Salary