(select City,length(City) from STATION  order by length(City) asc, city asc limit 1)
UNION
(select City,length(City) from STATION  order by length(City) desc, city asc limit 1)
