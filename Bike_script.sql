-- Table overview --
select * from bike_share_yr_0;
select * from bike_share_yr_1;
select * from cost_table;

-- Creating staged tables --
select * 
into bike_share_yr1
from
bike_share_yr_0;

select * 
into bike_share_yr2
from
bike_share_yr_1;

select * 
into cost_table1
from
cost_table;

select * from bike_share_yr1;
select * from bike_share_yr2;
select * from cost_table1;

-- Stannderdizing data -- 
select convert(date, dteday, 103) as date
from bike_share_yr1;

update bike_share_yr1
set dteday = convert(date, dteday, 103);

select convert(date, dteday, 103) as date
from bike_share_yr2;

update bike_share_yr2
set dteday = convert(date, dteday, 103);


exec sp_rename 'bike_share_yr1.dteday', 'date', 'column';

exec sp_rename 'bike_share_yr2.dteday', 'date', 'column';

-- Dropping columns not needed --
alter table bike_share_yr1
drop column mnth, holiday, workingday, weathersit, temp, atemp, hum, windspeed;

select * from bike_share_yr1;

alter table bike_share_yr2
drop column mnth, holiday, workingday, weathersit, temp, atemp, hum, windspeed;

select * from bike_share_yr2;

-- Stacking tables, performimg join and aggregation --
with cte as
	(select * from bike_share_yr1
	union 
	select * from bike_share_yr2)
		select *, 
		riders * price as revenue,
		riders * price - COGS as profit
		from cte as bk
		left join cost_table1 as ct
		on bk.yr = ct.yr;
