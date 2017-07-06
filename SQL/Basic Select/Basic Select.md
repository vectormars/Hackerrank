**Input Format**

The CITY table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SQL/Basic%20Select/CITY.jpg)

### Example 1: Revising the Select Query I

Query all **columns** for all American cities in CITY with populations larger than 100000. The CountryCode for America is USA.

#### select * from CITY

#### where Population >= 100000 and CountryCode = "USA"

Output:

3878 Scottsdale USA Arizona 202705 

3965 Corona USA California 124966 

3973 Concord USA California 121780 

3977 Cedar Rapids USA Iowa 120758 

3982 Coral Springs USA Florida 117549

### Example 2: Revising the Select Query II

Query the **names** of all American cities in CITY with populations larger than 120000. The CountryCode for America is USA.

#### select name from CITY

#### where Population >= 120000 and CountryCode = "USA"

Output:

Scottsdale

Corona

Concord

Cedar Rapids

### Example 3: Select All

Query all columns (attributes) for every row in the CITY table.

#### select * from CITY

Output:

6 Rotterdam NLD Zuid-Holland 593321 

3878 Scottsdale USA Arizona 202705 

3965 Corona USA California 124966 

3973 Concord USA California 121780 

3977 Cedar Rapids USA Iowa 120758 

3982 Coral Springs USA Florida 117549 

4054 Fairfield USA California 92256 

4058 Boulder USA Colorado 91238 

4061 Fall River USA Massachusetts 90555 


### Example 4: Select By ID

Query all columns for a city in CITY with the ID 1661.

#### select * from City

#### where ID = 1661

Output:

1661 Sayama JPN Saitama 162472 









