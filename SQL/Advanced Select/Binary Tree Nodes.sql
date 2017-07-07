Select 
    N,(Case
            when P is NULL then 'Root'
            when (select count(*) from BST as BST2 where BST2.P = BST.N) = 0 then 'Leaf'
            else 'Inner'
    End)
from BST order by N