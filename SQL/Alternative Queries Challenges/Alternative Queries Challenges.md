### Example 1: Draw The Triangle 1
Write a query to print the pattern P(20).

#### SELECT REPEAT('o ', @NUMBER := @NUMBER - 1) 
#### FROM information_schema.tables, (SELECT @NUMBER:=21) t LIMIT 20

o o o o o o o o o o o o o o o o o o o o      
o o o o o o o o o o o o o o o o o o o      
o o o o o o o o o o o o o o o o o o     
o o o o o o o o o o o o o o o o o     
o o o o o o o o o o o o o o o o     
o o o o o o o o o o o o o o o     
o o o o o o o o o o o o o o     
o o o o o o o o o o o o o       
o o o o o o o o o o o o     
o o o o o o o o o o o     
o o o o o o o o o o     
o o o o o o o o o     
o o o o o o o o     
o o o o o o o     
o o o o o o     
o o o o o      
o o o o     
o o o     
o o     
o      

### Example 2: Draw The Triangle 2
Write a query to print the pattern P(20).
#### SELECT REPEAT('* ', @NUMBER := @NUMBER + 1) 
#### FROM information_schema.tables, (SELECT @NUMBER:=0) t LIMIT 20

o       
o o    
o o o     
o o o o     
o o o o o     
o o o o o o     
o o o o o o o     
o o o o o o o o     
o o o o o o o o o     
o o o o o o o o o o      
o o o o o o o o o o o     
o o o o o o o o o o o o     
o o o o o o o o o o o o o     
o o o o o o o o o o o o o o    
o o o o o o o o o o o o o o o    
o o o o o o o o o o o o o o o o     
o o o o o o o o o o o o o o o o o     
o o o o o o o o o o o o o o o o o o     
o o o o o o o o o o o o o o o o o o o     
o o o o o o o o o o o o o o o o o o o o      

### Example 3: Print Prime Numbers

Write a query to print all prime numbers less than or equal to 1000. Print your result on a single line, and use the ampersand (\&) character as your separator (instead of a space).
