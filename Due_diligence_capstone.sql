SELECT *
FROM [Housing].[dbo].[quarterly_housing_19632025]
where observation_date like '%2010%' or observation_date like '%2025%'

select (SalePrice * 1.538) as adjusted_current_price
from [house-prices_features]

use Housing
---alter table [house-prices_features]
---add current_price money

select distinct Bedroom_AbvGr, count(Bedroom_AbvGr) as count_bed
from [house-prices_features]
group by Bedroom_AbvGr
