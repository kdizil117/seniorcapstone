select * from [house-prices_features]
---generate price based on current housing prices by multiplyling by the percent increase
use Housing

SELECT *
FROM [Housing].[dbo].[quarterly_housing_19632025]
where observation_date like '%2010%' or observation_date like '%2025%'

select (SalePrice * 1.538) as adjusted_current_price
from [house-prices_features]

---check how many of each bed room there are to get a good idea of what the customer needs
select distinct Bedroom_AbvGr, count(Bedroom_AbvGr) as count_bed
from [house-prices_features]
group by Bedroom_AbvGr

---check housing worth

select sum(cast(current_price as money)) as total_stock_worth
from [house-prices_features]

/* the median annual wage is 61030.00 the real median seems to be 48060 from the table I got from the BLS(bureau of labor statistics) 
website I think using the averages insted of raw data drove the mean and median up. if we multiply this by 4.5 we get 216270. (house price/4.5 = needed income) is the affordability measurement we use.
now im going to check how many houses in our inventory are affordable*/

select count(*)
from [house-prices_features]
where cast (current_price as money) > 216270 and cast(Bedroom_AbvGr as int) <= 3
---1557 homes are above this price and have 3 or less bedrooms

select count(*), sum(current_price)
from [house-prices_features]
where cast (SalePrice as money) > 216270
---1898 are above this price all together

---do analysis of worker pay
use Worker_pay

select *
from bls_national_may2023_wage_data
where A_MEAN is null

select *
from total_bls_national

---delete total from dataset so a histogram can be created in jupyternotebook
begin tran
delete from bls_national_may2023_wage_data
where O_GROUP = 'total'
rollback

---these values will mess up analysis need to change them to 0
BEGIN TRAN
update bls_national_may2023_wage_data
set A_MEAN = case when A_MEAN = '*' then '0'
                  when A_Mean = '**' then '0'
                  else A_MEAN
                  end
rollback

--- check max and min for graphing
select min(cast(A_MEAN as money)) as min, max(cast(A_MEAN as money)) as max
from bls_national_may2023_wage_data

