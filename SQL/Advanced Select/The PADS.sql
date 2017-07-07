Select concat(Name,'(',left(Occupation,1),')') as New From Occupations order by New;
Select concat('There are a total of ',count(Occupation),' ',lower(Occupation),'s.') from Occupations 
Group by Occupation
Order by count(Occupation),Occupation;