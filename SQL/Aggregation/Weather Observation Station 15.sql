Select round(LONG_W,4) from Station
where LAT_N = (select max(LAT_N) from Station where LAT_N<137.2345) 