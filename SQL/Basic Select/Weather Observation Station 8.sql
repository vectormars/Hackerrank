select distinct city from station
where city REGEXP '^[a|e|i|o|u].*[a|e|i|o|u]$'