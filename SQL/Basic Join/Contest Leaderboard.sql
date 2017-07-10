select ms.hacker_id, (select h.name from hackers h where h.hacker_id = ms.hacker_id) name, sum(ms.score) total_score from 
  (select hacker_id, max(score) score from submissions s
   group by 1, s.challenge_id) ms 
group by 1
having total_score > 0
order by total_score desc, hacker_id