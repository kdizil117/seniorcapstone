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

select *
from bls_national_may2023_wage_data

SELECT top(10) *
from Zillow_zip_price_month

select count(*)
from Zillow_zip_price_month
where StateName = 'TX'

--- leading zeros are missing

select concat('0',[RegionName])
from Zillow_zip_price_month
where LEN(RegionName) = 4

begin tran
update Zillow_zip_price_month
set RegionName = concat('0',[RegionName])
where LEN(RegionName) = 4
rollback

update Zillow_zip_price_month
set RegionName = TRIM(RegionName)


----leading zeros missing in pandas 

alter table Zillow_zip_price_month
alter column RegionName char(10)

---trunating table to load all files into it from python
use Housing
TRUNCATE table [US_zip_codes_geo.min]

select top(10) *
from [az_arizona_zip_codes_geo.min]

update [az_arizona_zip_codes_geo.min] 
set geometry = cast(geometry as nvarchar(max)) as geometry

select
[az_arizona_zip_codes_geo.min].ZCTA5CE10,
cast(geometry as nvarchar(max)) as geometry
from [az_arizona_zip_codes_geo.min]

use Housing

SELECT *
FROM Housing.dbo.avg_hpi_year a 

use location_US_Json

CREATE TABLE US_Zip_Json_test(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    JsonContent NVARCHAR(MAX)
);




SELECT TABLE_SCHEMA, TABLE_NAME 
FROM housing.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%US_zip_codes_geo%';

select top(1) *
from US_Zip_Json u 

truncate table US_Zip_Json
truncate table us_Json

CREATE TABLE US_Json(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    JsonContent NVARCHAR(MAX)
);

use location_US_Json
select top(1) * 
from US_Json u 

select *
from housing.dbo.Zillow_zip_price_month z 

update housing.dbo.Zillow_zip_price_month
set StateName = case when state = 'tx' then 'texas'

use housing

select distinct [state] 
from housing.dbo.Zillow_zip_price_month  
where [state] in (select [state] 
				from Zillow_zip_price_month  
				group by state
				having avg([_05_31_25]) < 310000)

---drop table heatmap_housing



select us.id,us.Jsoncontent into heatmap_housing_affordable 
from location_us_json.dbo.US_Json us

select us.id, zm.StateName, avg(zm.[_05_31_25]) as avg_price,us.JsonContent into heatmap_housing
from location_US_Json.dbo.US_Json us 
left join housing.dbo.Zillow_zip_price_month zm
on SUBSTRING(JsonContent, CHARINDEX('"abbreviation": "', JsonContent) + 17, 2)  = zm.StateName 
group by us.Id, zm.StateName, us.JsonContent

---drop table heatmap_housing_affordable

select * into heatmap_housing_affordable
from heatmap_housing
where avg_price <= 216270.99

select * into heatmap_housing_midlevel
from heatmap_housing
where avg_price <= 315000

select * into heatmap_housing_upperlevel
from heatmap_housing
where avg_price >= 315000


select *
from heatmap_housing_affordable
where statename = 'al'

SELECT TOP 5 JsonContent 
FROM dbo.heatmap_housing_affordable 
WHERE JsonContent NOT LIKE '%"geometry"%'

alter table heatmap_housing
add [iso_3166-2] char (5)

update heatmap_housing
set [iso_3166-2] = concat('US-',StateName)

SELECT *
FROM heatmap_housing

select * from housing.dbo.[house-prices_features]
