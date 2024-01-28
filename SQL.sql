select *from commodity;
select *from wfp_food_prices_pakistan;
set SQL_SAFE_UPDATES= 0;
create table commodity_backup as select *from commodity;
create table wfp_food_prices_pakistan_backup as select *from wfp_food_prices_pakistan;
-- #●	Select dates and commodities for cities Quetta, Karachi,
-- and Peshawar where price was less than or equal 50 PKR
select mktname,date,price from wfp_food_prices_pakistan 
where price<=50; 
#●	Query to check number of observations against each market/city in PK
select mktname, count(*) as number_of_observation 
from wfp_food_prices_pakistan
where country="Pakistan"
group by mktname;
#●	Show number of distinct cities
select mktname,count(distinct mktname) as distinct_cites
from wfp_food_prices_pakistan
group by mktname;
#●	List down/show the names of cities in the table
select mktname as Cities_Name
from wfp_food_prices_pakistan;
#●	List down/show the names of commodities in the table
select cmname, count(distinct cmname)
from wfp_food_prices_pakistan
group by cmname;
#●	List Average Prices for Wheat flour - Retail in EACH city separately over the entire period.
select cmname,mktname , round(avg(price),2) as Average_Price
from wfp_food_prices_pakistan
where cmname ="Wheat flour - Retail"
group by mktname;
#●	Calculate summary stats (avg price, max price) for each city separately for all cities
--  except Karachi and sort alphabetically the city names,
--  commodity names where commodity is Wheat (does not matter which one) 
--  with separate rows for each commodity
select cmname,mktname,round(avg(price),2) as Average,max(price) as max
from wfp_food_prices_pakistan
where mktname<>"karachi" and cmname like "Wheat flour - Retail"
group by cmname,mktname
order by cmname,mktname asc;
#●	Calculate Avg_prices for each city for Wheat Retail and
# show only those avg_prices which are less than 30
select cmname,mktname ,round(avg(price)) as Average_price
from wfp_food_prices_pakistan
where cmname ="Wheat - Retail"
group by mktname
having Average_price<30;
#●	Prepare a table where you categorize prices based on a logic (price < 30 is LOW,
# price > 250 is HIGH, in between are FAIR)
select cmname,price,
CASE
        WHEN price<30 THEN 'LOW'
        WHEN price>250 THEN 'HIGH'
        ELSE 'FAIR'
END AS price_categorize
 from wfp_food_prices_pakistan;
#●	Create a query showing date, cmname, category, city, price, city_category 
#where Logic for city category is: Karachi and Lahore are 'Big City', Multan 
#and Peshawar are 'Medium-sized city', Quetta is 'Small City'
select cmname ,date,price,category,mktname,admname,
case
   when mktname="Peshawar" then "Medium-sized"
   when mktname = "Multan" then "Medium"
   when mktname="Karachi" then "Big City"
   when mktname ="Lahore" then "Big City"
   else "Small City"
   end as city_category
   from wfp_food_prices_pakistan;
   #●	Create a query to show date, cmname, city, price. Create new column price_fairness 
  # through CASE showing price is fair if less than 100, unfair if more than or equal to 100, 
   #if > 300 then 'Speculative'
select date,cmname,mktname,price,
case
when price <100 then "fair"
when price >100 then 'unfair'
when price >300 then "Speculative"
end as "price_fairness"
from wfp_food_prices_pakistan
order by mktname asc;
#Join the food prices and commodities table with a left join. 
select *from wfp_food_prices_pakistan;
select *from commodity; 
select c.cmname,c.category, fd.price
from wfp_food_prices_pakistan fd
left join commodity c
on c.cmname = fd.cmname;
#●	Join the food prices and commodities table with an inner join
select fd.cmname,fd.price,fd.mktname,c.category
from wfp_food_prices_pakistan fd
inner join commodity c
on c.cmname =fd.cmname;