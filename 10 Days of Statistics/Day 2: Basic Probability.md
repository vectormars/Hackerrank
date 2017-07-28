### Task 1
In a single toss of 2 fair (evenly-weighted) six-sided dice, find the probability that their sum will be at most 9.

|   | 1 | 2 | 3 | 4  | 5  | 6  |
|---|---|---|---|----|----|----|
| 1 | 2 | 3 | 4 | 5  | 6  | 7  |
| 2 | 3 | 4 | 5 | 6  | 7  | 8  |
| 3 | 4 | 5 | 6 | 7  | 8  | 9  |
| 4 | 5 | 6 | 7 | 8  | 9  | 10 |
| 5 | 6 | 7 | 8 | 9  | 10 | 11 |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |

Total = 36     
Greater than 9 = 6     
Pr(at most 9)=30/36 = 5/6

### Task 2
For a single toss of 2 fair (evenly-weighted) dice, find the probability that the values rolled by each die will be different and their sum is 6.

Condition for sum = 6       
(1,5),(2,4),(3,3),(4,2),(5,1)      
Pr= 4/36 =1/9

### Task 3
There are 3 urns: X, Y and Z.

* Urn X contains 4 red balls and 3 black balls.
* Urn Y contains 5 red balls and 4 black balls.
* Urn Z contains 4 red balls and 4 black balls.

One ball is drawn from each urn. What is the probability that the 3 balls drawn consist of 2 red balls and 1 black ball?

|   | 1 | 2 | 3 |
|---|---|---|---|
|Urn 1 | R | R | B |
|Urn 2 | R | B | R |
|Urn 3 | B | R | R |

Case 1: (4/7)(5/9)(4/8)=80/504      
Case 2: (4/7)(4/9)(4/8)=64/504   
Case 3: (3/7)(5/9)(4/8)=60/504    

Pr= 204/504 = 17/42

### Task 4
Bag 1 contains 4 red balls and 5 black balls.        
Bag 2 contains 3 red balls and 7 black balls. 

One ball is drawn from the Bag 1, and 2 balls are drawn from Bag 2. Find the probability that 2 balls are black and 1 ball is red.

|        | bag1 | bag2 | bag2 |
|--------|------|------|------|
| case 1 | B    | B    | R    |
| case 2 | B    | R    | B    |
| case 3 | R    | B    | B    |

Pr1 = (5/9)((3\*7)/(10\*9))   
Pr2 = (5/9)((3\*7)/(10\*9))   
Pr3 = (4/9)((7\*6)/(10\*9))   

Pr = 7/15

### Task 5
There are 10 people about to sit down around a round table. Find the probability that  particular people will sit next to one another.

Pr = 2/9

### Task 6
Bag X contains 5 white balls and 4 black balls. Bag Y contains 7 white balls and 6 black balls. You draw 1 ball from bag X and, without observing its color, put it into bag Y. Now, if a ball is drawn from bag Y, find the probability that it is black.

|   | W | B |
|---|---|---|
| X | 5 | 4 |
| Y | 7 | 6 |

Case 1: White from X (5/9)(6/14)  
Case 2: Black from X (4/9)(7/14)  

Pr=29/63


### Task 7
A firm produces steel pipes in three plants.

* Plant A produces 500 units per day and has a fraction defective output of 0.005.
* Plant B produces 1000 units per day and has a fraction defective output of 0.008.
* Plant C produces 2000 units per day and has a fraction defective output of 0.010.

At random, a pipe is selected from the day’s total production and it is found to be defective. What is the probability that it came from plant A?

P(D|A)=0.005, P(D|B)=0.008, P(D|C)=0.010   
P(A)=5/35, P(B)=10/35, P(C)=20/35      
P(A|D)=P(D|A)P(A)/P(D) with P(D)=P(D|A)P(A)+P(D|B)P(B)+P(D|C)P(C) = 5/61


### Task 8
In a certain city, the probability of a resident not reading the morning newspaper is 1/2, and the probability of a resident not reading the evening newspaper is 2/5. The probability they will read both newspapers is 1/5.

Find the probability that a resident reads a morning or evening newspaper.

P(not M)=1/2, P(M)=1/2     
P(not E)=2/5, P(E)=3/5      
P(M and E)=1/5    
P(M or E)=1/2+3/5-1/5=9/10






