SELECT ROUND(S.LAT_N,4) from STATION S, STATION S1 
GROUP BY S.LAT_N 
HAVING SUM(SIGN(1-SIGN(S1.LAT_N - S.LAT_N))) = (COUNT(*)+1)/2