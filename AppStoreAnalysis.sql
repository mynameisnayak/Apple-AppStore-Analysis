-- EDA

--check number of unique apps in both tables
select count(DISTINCT id) as UniqueAppID
from AppleStore
--7197

select count(DISTINCT id) as UniqueAppID
from appleStore_description
--7197


--check for missing values in the key fields
SELECT count(*) as MissingValues
from AppleStore
where track_name is NULL or user_rating is NULL or prime_genre is NULL
-- 0

SELECT count(*) as MissingValues
from appleStore_description
where app_desc is NULL
-- 0

--Find out the number of app in each gerne
select prime_genre, count(*) as NumApps
from AppleStore
GROUP by prime_genre
order by NumApps DESC     --look at which genre is dominent in the market
-- top 5: games, entertainment, education, photo & video, utilities

--Look at a summary of ratings given
select min(user_rating) as MinRating,
	max(user_rating) as MaxRating,
    avg(user_rating) as AvgRating
from AppleStore



select track_name, size_bytes, price, cont_rating, lang_num
FROM AppleStore

--Paid VS Free
SELECT CASE
			when price=0 then "FREE"
            else "PAID"
       End as AppType, avg(user_rating) as AvgUserRating
from AppleStore
GROUP by AppType
-- Paid have slightly better ratings

--Effect of having more supported languages
SELECT CASE
			when lang_num<10 then "<10 Languages"
            When lang_num BETWEEN 10 and 30 then "10-30 Languages"
            else ">30 Languages"
       End as Lang_Supported,
       avg(user_rating) as AvgUserRating
FROM AppleStore
GROUP by Lang_Supported
ORDER by AvgUserRating DESC
-- <10 Languages have the lowest average

--avg rating of each category
select prime_genre, avg(user_rating) as AvgUserRating
from AppleStore
GROUP by prime_genre
order by AvgUserRating
-- Lowest rating for Catalogs, Finance, Book, Navigation, LifestyleAppleStore

--Device Compatability vs user rating
SELECT sup_devices_num, avg(user_rating) as AvgUserRating, rating_count_tot
from AppleStore
GROUP by sup_devices_num
order by AvgUserRating DESC,rating_count_tot DESC
-- Rating Count is mostly increasing with number of user count

--App with zero ratings
SELECT track_name, ver as version
FROM AppleStore
where rating_count_tot = 0
order by version DESC
-- Most of the apps are new

--App size vs user ratings
SELECT CASE
			when size_bytes < 61280000 then "Small Size Apps"
            when size_bytes BETWEEN 61280000 and 138980000 then "Average Size Apps"
            Else "Large Size Apps"
       End as AppSize,
       COUNT(*) as NumOfApps,
       avg(user_rating) as user_rating
From AppleStore
GROUP by AppSize
-- No significant differences, still small size apps tend to have lower ratings

--App size vs Price
SELECT CASE
			when size_bytes < 61280000 then "Small Size Apps"
            when size_bytes BETWEEN 61280000 and 138980000 then "Average Size Apps"
            Else "Large Size Apps"
       End as AppSize,
       max(price) as MaxPrice,
       min(price) as MinPrice,
       avg(price) as AvgPrice
from AppleStore
GROUP by AppSize
-- Large App group has the highest prices and also high Avg Price

--Content rating vs user rating
SELECT cont_rating, user_rating
from AppleStore
GROUP by cont_rating
-- Not so significant

--Content rating vs assumed download count
SELECT cont_rating, rating_count_tot
from AppleStore
GROUP by cont_rating
-- Higher the Content rating, more the download count

--Apps with improved ratings
select track_name, user_rating, user_rating_ver
from AppleStore
where (user_rating_ver - user_rating) > 0
order by user_rating_ver - user_rating Desc

--Apps with same ratings
select track_name, user_rating, user_rating_ver
from AppleStore
where (user_rating_ver - user_rating) = 0
order by user_rating_ver - user_rating

--Apps whose ratings decresed 
select track_name, user_rating, user_rating_ver
from AppleStore
where (user_rating_ver - user_rating) < 0
order by user_rating_ver - user_rating

    
--Comparing app description length to user rating
select CASE
			when length(AppDesc.app_desc) < 500 then "Short"
            when length(AppDesc.app_desc) BETWEEN 500 and 1000 then "Medium"
            Else "Long"
       END as AppDescriptionLength, avg(Store.user_rating) as AvgUserRating
From
	AppleStore as Store
Join
	appleStore_description as AppDesc
on Store.id = AppDesc.id
GROUP by AppDescriptionLength
order by AppDescriptionLength
-- Longer the descripting better the avg rating

--Top Rated apps in each category
select
	prime_genre,
    track_name,
    user_rating
from (
    select
        prime_genre,
        track_name,
        user_rating,
        RANK() OVER(PARTITION by prime_genre order by user_rating desc, rating_count_tot DESC) as rank
    FROM
        AppleStore
) as AppRank
where AppRank.rank = 1



    

    
