Select round(LONG_W,4) from STATION
where LAT_N = (Select min(LAT_N) from Station where LAT_N>38.7780) 