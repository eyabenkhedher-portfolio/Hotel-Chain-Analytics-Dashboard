select *
from Hotelproject..dim_date
select* into Hotelproject..dim_date_clean
from Hotelproject..dim_date
-----------------------------------------------------------------------------
/*check nulls*/
select 
sum (case when date is null then 1 else 0 end),
sum (case when mmm_yy is null then 1 else 0 end),
sum (case when week_no is null then 1 else 0 end),
sum (case when day_type is null then 1 else 0 end)
from Hotelproject..dim_date_clean

/*check duplicate*/
select date,mmm_yy,week_no,day_type
from Hotelproject..dim_date_clean
group by date,mmm_yy,week_no,day_type
having count(*)>1;

/*date type*/
select max(week_no),
min(week_no)
from Hotelproject..dim_date_clean

select top 5*
from Hotelproject..dim_date_clean
where date  is null and date is not null

     select  distinct day_type
from Hotelproject..dim_date_clean

      select  distinct week_no
from Hotelproject..dim_date_clean

   select  distinct mmm_yy
from Hotelproject..dim_date_clean             

        select  distinct date
from Hotelproject..dim_date_clean        

/*check empty strings on text columns*/
select count(*)
from Hotelproject..dim_date_clean 
where trim(day_type)='' or trim(mmm_yy)='' 
--------------------------------------------------------------------------------------------------------------------
/*dim_ hotel*/
select * into  Hotelproject..dim_hotels_clean 
from Hotelproject..dim_hotels
/*check nulls*/
select sum(case when property_id is null then 1 else 0 end ),
 sum(case when property_name is null then 1 else 0 end ),
 sum(case when category is null then 1 else 0 end ),
 sum(case when city is null then 1 else 0 end )
from Hotelproject..dim_hotels_clean 
/*second method to check nulls is is perfect thne case when */
select 
count(*)-count(property_id) as property_id_count_dup,
count(*)-count(property_name) as property_name_count_dup,
count(*)-count(category) as category_count_dup,
count(*)-count(city) as city_count_dup
from Hotelproject..dim_hotels_clean 
/*check duplicates)*/
select property_id,property_name,category,city 
from Hotelproject..dim_hotels_clean
group by property_id,property_name,category,city 
having count(*)>1;

/* check empty strings on text columns*/

select count(*)
from Hotelproject..dim_hotels_clean 
where trim(property_name)='' or trim(category)=''  
 or trim(city)='' 
 /* check .type ...*/
 select distinct category
 from Hotelproject..dim_hotels_clean 

  select distinct property_name
 from Hotelproject..dim_hotels_clean 

  select distinct city
 from Hotelproject..dim_hotels_clean 

 -------------------------------------------------------------------
 /*dim_rooms*/
 select *into hotelproject..dim_rooms_clean
 from hotelproject..dim_rooms
 select *
 from  hotelproject..dim_rooms_clean

/*chek nulls */
select 
count(*)-count(room_id) as romm_id_count_null,
count(*)-count(room_class) as room_class_count_null
 from  hotelproject..dim_rooms_clean
 /*check duplicates */
 select room_id,room_class
from Hotelproject..dim_rooms_clean
group by room_id,room_class
having count(*)>1;
-------------------------------------------------------------------
/*fact_aggregated_bookings*/
select * into hotelproject..fact_aggregated_bookings_clean
from Hotelproject..fact_aggregated_bookings

select * 
from hotelproject..fact_aggregated_bookings_clean
/*check nulls*/
select 
count(*)-count( property_id) as property_id_null,
count(*)-count( check_in_date) as check_in_date_null,
count(*)-count( room_category) as room_category_null,
count(*)-count( successful_bookings) as successful_bookings_null,
count(*)-count( capacity) as capacity_null
from hotelproject..fact_aggregated_bookings_clean


select capacity,room_category
from hotelproject..fact_aggregated_bookings_clean
--where capacity is null
select avg(capacity)    --to know the avg capacity for all romm--
from hotelproject..fact_aggregated_bookings_clean
update hotelproject..fact_aggregated_bookings_clean
set capacity=25
where capacity is null 
---second methode --
alter table hotelproject..fact_aggregated_bookings_clean 
add capacity int ;

update  hotelproject..fact_aggregated_bookings_clean 
set capacity =case 
when room_category='RT1' then 2 
when room_category='RT2' then  4  
when room_category='RT3' then 6 
when room_category='RT4' then 8  
end 
where capacity is null;

select * from Hotelproject..fact_aggregated_bookings_clean
select*from Hotelproject..dim_rooms



select check_in_date
from hotelproject..fact_aggregated_bookings_clean
where check_in_date is null;


drop table IF EXISTS  hotelproject..fact_aggregated_bookings_clean;
select 
 property_id,check_in_date,room_category,
count(booking_id) as successful_bookings
into hotelproject..fact_aggregated_bookings_clean
 from hotelproject..fact_bookings 
group by property_id,check_in_date,room_category;





/*check duplicates*/
select property_id,check_in_date,room_category,successful_bookings,capacity
from hotelproject..fact_aggregated_bookings_clean
group by property_id,check_in_date,room_category,successful_bookings,capacity
having count(*)>1;

---------------------------------------------------------------------------------------------------------
/*fact_bookings*/
select* into hotelproject..fact_bookings_cleans
from hotelproject..fact_bookings
------/*check nulls*/
select property_id,booking_date,checkout_date,room_category
from hotelproject..fact_bookings_cleans

select count(*)-count(booking_id) as null_booking,
       count(*)-count(property_id) as null_property_id,
       count(*)-count(check_in_date) as null_chek_in_date,
       count(*)-count(booking_date) as null_date_booking,
       count(*)-count(checkout_date) as null_checkout_date,
       count(*)-count(room_category) as null_booking,
         count(*)-count(booking_platform) as null_booking_platform,
           count(*)-count(ratings_given) as null_ratings_given,
             count(*)-count(booking_status) as null_booking_statues,
             count(*)-count(no_guests) as null_booking_statues
from hotelproject..fact_bookings_cleans

select avg( convert(int,ratings_given))
from hotelproject..fact_bookings_cleans

update  hotelproject..fact_bookings_cleans
set ratings_given=3
where ratings_given is null or ratings_given ='NULL'

select*
from hotelproject..fact_bookings_cleans
where no_guests is null 

select avg( convert(int,no_guests))
from hotelproject..fact_bookings_cleans

update  hotelproject..fact_bookings_cleans
set no_guests=2
where no_guests is null or no_guests ='NULL'

/*check type*/

select
case when no_guests<=0 then 1 else no_guests end   --cz no guests=-3--
from  hotelproject..fact_bookings_cleans

/*conversation type*/
--EXEC sp_help 
--'hotelprojectfact_bookings_cleans';

select COLUMN_NAME,DATA_TYPE      ----CHECK TYPE----
from hotelproject.INFORMATION_SCHEMA.COLUMNS
where table_name='fact_bookings_cleans';

ALTER TABLE  hotelproject..fact_bookings_cleans   ---first try if dosen't work we do where the dry  date after that make updtae and finaly amter--
alter column check_in_date DATE;

/*to show where  the dry date*/
select 
booking_id,check_in_date,booking_date,checkout_date 
 from hotelproject..fact_bookings_cleans
where ISDATE(check_in_date)=0
      or  ISDATE(booking_date)=0
      or  ISDATE(checkout_date)=0
/*update*/
update hotelproject..fact_bookings_cleans 
set check_in_date =convert(date,check_in_date,103)

ALTER TABLE  hotelproject..fact_bookings_cleans 
alter column check_in_date DATE;

update hotelproject..fact_bookings_cleans 
set booking_date =convert(date,booking_date,103)

ALTER TABLE  hotelproject..fact_bookings_cleans 
alter column  booking_date DATE;


update hotelproject..fact_bookings_cleans 
set checkout_date =convert(date,checkout_date,103)

ALTER TABLE  hotelproject..fact_bookings_cleans 
alter column  checkout_date DATE;


select max(checkout_date),min(checkout_date),
max(booking_date),
min(booking_date),max(check_in_date),
min(check_in_date)
from hotelproject..fact_bookings_cleans

select *
from hotelproject..fact_bookings_cleans
where checkout_date <check_in_date
or check_in_date<booking_date

/*check empty*/
select count(*)
from hotelproject..fact_bookings_cleans
where trim (checkout_date)='' or
       trim (check_in_date)='' or
       trim (booking_date)='' or 
       trim (booking_date)=''

/*check duplicates*/
select booking_id,property_id,booking_date,checkout_date,room_category
from  hotelproject..fact_bookings_cleans
 group by  booking_id,property_id,booking_date,checkout_date,room_category
 having count(*)>1;

 /*remove duplicates*/
 ;with remove_cte as (
 select *,
 row_number () over (partition by booking_id,property_id,booking_date,checkout_date,room_category
                  order by booking_id) as row_hotle
from  hotelproject..fact_bookings_cleans
)
--delete  from remove_cte
select *
from remove_cte
where row_hotle >1;

select *
from  hotelproject..fact_bookings_cleans

-------------------------------------------------------
/*dat    _august*/
/*check nulls*/
select * into Hotelproject..new_data_august_clean
from Hotelproject..new_data_august

select * 
from Hotelproject..new_data_august_clean

select count(*)-count(property_id) as null_property_id,
 count(*)-count(property_name) as null_property_name,
       count(*)-count(category) as null_category,
       count(*)-count(city) as null_city,
       count(*)-count(room_category) as null_room_category,
       count(*)-count(room_class) as null_room_class,
         count(*)-count(check_in_date) as null_check_in_date,
           count(*)-count(mmm_yy) as null_mmm_yy,
 count(*)-count(week_no) as null_week_no,
  count(*)-count(day_type) as null_uday_type,
   count(*)-count(successful_bookings) as null_successful_bookings
from Hotelproject..new_data_august_clean

/*check empty*/
select count(*)
from Hotelproject..new_data_august_clean
where trim (check_in_date) ='' or
trim(mmm_yy)=''or
trim (day_type)='' or
trim (week_no) =''
/*check comptabilty*/
select distinct city
from Hotelproject..new_data_august_clean
group by city

/*check duplicates*/
select property_id,property_name,category,room_category,city,room_class,check_in_date,mmm_yy,week_no,day_type,successful_bookings
from Hotelproject..new_data_august_clean
group by property_id,property_name,category,room_category,city,room_class,check_in_date,mmm_yy,week_no,day_type,successful_bookings
having count(*)>1


select COLUMN_NAME,DATA_TYPE      ----CHECK TYPE----
from hotelproject.INFORMATION_SCHEMA.COLUMNS
where table_name='new_data_august_clean';

alter  table Hotelproject..new_data_august_clean
alter column check_in_date date;

select 
property_id,check_in_date,mmm_yy,day_type
 from Hotelproject..new_data_august_clean
where ISDATE(check_in_date)=0
      or  ISDATE(mmm_yy)=0
      or  ISDATE(day_type)=0
            or     ISDATE( week_no)=0


-------------------------------exploration-------------------------------------------
/*what is the total revenue relased for each room category */
select room_category,sum(convert(float,revenue_realized)) as total_revenue
from Hotelproject..fact_bookings_cleans
group by room_category
order by total_revenue desc
/*what is the averge rating given by customers for each hotel*/
select  property_name,round(AVG(convert(float,ratings_given)),2) as avg_rating
from Hotelproject..fact_bookings_cleans fb
join Hotelproject..dim_hotels_clean dh
on fb.property_id=dh.property_id
group by property_name 
order by avg_rating desc
/*what is the total number of successful bookings for each booking platform */
select booking_platform,sum(convert(int,successful_bookings)) as total_successful_bookings
from Hotelproject..fact_aggregated_bookings_clean agg
join  Hotelproject..fact_bookings_cleans    fb
on agg.property_id=fb.property_id
group by booking_platform
order by total_successful_bookings desc
/*what is the total revenue generated versus revenue realised for each city*/
select city,sum(convert(float,revenue_generated)) as total_revenue_generated,
sum(convert(float,revenue_realized)) as total_revenue_realised
from  Hotelproject..fact_bookings_cleans fb
join  Hotelproject..dim_hotels_clean dh
on fb.property_id=dh.property_id
group by city 
order by total_revenue_generated desc
/*what is the concellation rate for bookings across differnt bookings platformm */
select booking_platform,count(*) as total_booking,
round(sum(convert(float, case when booking_status= 'cancelled' then 1 else 0 end ))/count(*) *100,2) as percentage_booking_cancelled
from  Hotelproject..fact_bookings_cleans
group by booking_platform
order by percentage_booking_cancelled desc
/*what is the total revenue realized for each booking status*/
select booking_status,sum(convert(float,revenue_realized)) as total_revenue_realized
from  Hotelproject..fact_bookings_cleans fb
group by booking_status
order by total_revenue_realized desc
/*what is the occupancy rate for each room category?*/
select room_category,sum(convert(float,successful_bookings)) as total_successful_bookings,sum(convert(float,capacity)) as total_capacity,
round(sum(convert(float,successful_bookings))/(sum(convert(float,capacity)))*100,2) as percentage_occupancy
from  Hotelproject..fact_aggregated_bookings_clean
group by room_category
order by percentage_occupancy desc
/*what is the averge rating given by customers for each city*/
select city,avg(convert(float,ratings_given))as avg_ratings_given
from Hotelproject..fact_bookings_cleans fb
join    Hotelproject..dim_hotels dh
on fb.property_id=dh.property_id
group by city
order by avg_ratings_given desc 
/*what is the total revenue realized per city and what is the its percentage contribuation to the overall company revenue*/
select dh.city,sum(convert(float,revenue_realized)) as total_revenue_realized,sum(convert(float,revenue_generated)) as total_revenue_generated,
round(sum(convert(float,revenue_realized)) /sum(sum(convert(float,revenue_generated))) over()*100,2)as percentage_company_revenue -- percentage contribuation---
from  Hotelproject..fact_bookings_cleans fb
join   Hotelproject..dim_hotels dh 
  on fb.property_id=dh.property_id
  group by dh.city
  order by percentage_company_revenue desc 
/*rank the hotel in each city base on their taotal revenue generated from highest to lowest */
;with rank_hotel as (
select property_name,
city,sum(convert(float,fb.revenue_generated)) as total_revenue_generated,
dense_rank()over (partition by   city order by sum(convert(float,fb.revenue_generated))  desc) as rank_revenue
from   Hotelproject..fact_bookings_cleans fb
join   Hotelproject..dim_hotels dh 
  on fb.property_id=dh.property_id
  group by property_name,dh.city
) 
select city,property_name,total_revenue_generated,rank_revenue
from rank_hotel
--where rank_revenue >1
order by city ,rank_revenue
/*what is the month _over_month total_revenue growth from july to agust*/
--in this table i don't have august rev---
--;with July_Rev  as (
--select sum (convert(float,revenue_realized)) as July_total
--from Hotelproject..fact_bookings_cleans
--),

--August_Rev  as( 
--select 
--sum (convert(float,revenue_realized)) as August_total
--from Hotelproject..new_data_august_clean
--)

--select j.July_total,
--       a. August_total
--        Round(((a.August_total-j.July_total)/j.July_total)*100,2) as MOM_Growth_Percentage ----mom _growth--
--from July_Rev j,
--    August_Rev a;
/* what is the averge lead time (difference betweein booking date and check in for cancelled  booking versus successful bookings*/
select booking_status,
avg(convert(float,DATEDIFF(day,booking_date,check_in_date))) as avg_lead_time
from   Hotelproject..fact_bookings_cleans
group by booking_status
order by avg_lead_time desc






select*
from Hotelproject..new_data_august_clean
select *
from Hotelproject..dim_date_clean

select*
from   Hotelproject..fact_bookings_cleans fb














