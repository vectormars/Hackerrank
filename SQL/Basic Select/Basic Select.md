**Input Format**

The CITY table is described as follows:

![alt text](https://github.com/vectormars/Hackerrank/blob/master/SOL/Basic%20Select/CITY.jpg)

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
