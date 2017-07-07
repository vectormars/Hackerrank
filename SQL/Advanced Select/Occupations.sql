SELECT
   MIN(o.Doctor),MIN(o.Professor),MIN(o.Singer),MIN(o.Actor)
FROM
    (SELECT
        CASE WHEN occupation='Doctor' THEN @d:=@d+1
             WHEN occupation='Professor' THEN @p:=@p+1
             WHEN occupation='Singer' THEN @s:=@s+1
             WHEN occupation='Actor' THEN @a:=@a+1 END AS row,
        CASE WHEN occupation='Doctor' THEN name END AS Doctor,
        CASE WHEN occupation='Professor' THEN name END AS Professor,
        CASE WHEN occupation='Singer' THEN name END AS Singer,
        CASE WHEN occupation='Actor' THEN name END AS Actor
     FROM occupations JOIN (SELECT @d:=0, @p:=0, @s:=0,@a:=0) AS r 
     ORDER BY name) o
GROUP BY row;