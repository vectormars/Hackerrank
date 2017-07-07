select
	case
		when A=B and B=C then 'Equilateral'
		when A+B <= C then 'Not A Triangle'
		when B+C <= A then 'Not A Triangle'
		when A+C <= B then 'Not A Triangle'	
		when A+B > C and A=B then 'Isosceles'
		when B+C > A and C=B then 'Isosceles'
		when A+C > B and A=C then 'Isosceles'
		else 'Scalene'
	end
from TRIANGLES 