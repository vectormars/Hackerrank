select H.hacker_id, H.name from Submissions S
inner join Challenges C
on S.challenge_id = C.challenge_id
inner join Difficulty D
on C.difficulty_level = D.difficulty_level 
inner join Hackers H
on S.hacker_id = H.hacker_id
where S.score = D.score and C.difficulty_level = D.difficulty_level
group by H.hacker_id, H.name
having count(S.hacker_id) > 1
order by count(S.hacker_id) desc, S.hacker_id asc