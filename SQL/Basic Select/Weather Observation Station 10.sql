select distinct city from station
where city not REGEXP '^.*[a|e|i|o|u]$'