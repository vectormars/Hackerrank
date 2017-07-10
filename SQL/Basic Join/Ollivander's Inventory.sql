select W.id, WP.age, W.coins_needed, W.power from Wands as W 
join Wands_Property as WP
on W.code = WP.code 
where WP.is_evil = 0 and W.coins_needed = (select min(coins_needed) from Wands as W1 join Wands_Property as WP1 on (W1.code = WP1.code) where W1.power = W.power and WP1.age = WP.age) 
order by W.power desc, WP.age desc