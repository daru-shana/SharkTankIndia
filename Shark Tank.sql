select * from project..data

alter table project..data
drop column column33,column34,column35,column36,column37,column38,column39,column40,column41,column42

-- total episodes

select max(ep_no) from project..data
select count(distinct ep_no) from project..data

-- pitches 

select count(distinct brand) from project..data

--pitches converted
select * from project..data;

select cast(sum(a.converted_not_converted) as float) /cast(count(*) as float) from (
select amount_invested_lakhs , case when amount_invested_lakhs>0 then 1 else 0 end as converted_not_converted from project..data) a

-- total male

select sum(male) from project..data

-- total female

select sum(female) from project..data

--gender ratio

select sum(female)/sum(male) from project..data

-- total invested amount

select sum(amount_invested_lakhs ) from project..data

-- avg equity taken
select * from project..data;

select avg(a.equity_taken) from
(select * from project..data where equity_taken>0) a

--highest deal taken

select max(amount_invested_lakhs) from project..data 

--higheest equity taken

select max(equity_taken) from project..data

-- pitches converted having atleast ne women

select * from project..data


select sum(b.female_count) 
from
(select case when a.female>0 then 1 else 0 end as female_count ,a.*from (
(select * from project..data where deal!='No Deal')) a)b

-- avg team members

select avg(team_members) from project..data

-- amount invested per deal

select avg(a.amount_invested_lakhs) amount_invested_per_deal 
from
(select * 
from project..data where deal!='No Deal') a

-- avg age group of contestants
select * from project..data;

select avg_age,count(avg_age) cnt 
from project..data 
group by avg_age 
order by cnt desc

-- location group of contestants

select location,count(location) cnt 
from project..data 
group by location 
order by cnt desc

-- sector group of contestants

select sector,count(sector) cnt 
from project..data 
group by sector 
order by cnt desc


--partner deals

select partners,count(partners) cnt 
from project..data  
where partners!='-' 
group by partners 
order by cnt desc

-- making the matrix


select * from project..data

select 'Ashnner' as keyy,count(ashneer_amount_invested) 
from project..data 
where ashneer_amount_invested is not null


select 'Ashnner' as keyy,count(ashneer_amount_invested) 
from project..data 
where ashneer_amount_invested is not null AND ashneer_amount_invested!=0

SELECT 'Ashneer' as keyy,SUM(C.ashneer_amount_invested),AVG(C.ASHNEER_EQUITY_TAKEN) 
FROM 
(SELECT * 
FROM PROJECT..DATA  
WHERE ASHNEER_EQUITY_TAKEN!=0 AND ASHNEER_EQUITY_TAKEN IS NOT NULL) C


select m.keyy,m.total_deals_present,m.total_deals,n.total_amount_invested,n.avg_equity_taken 
from
(select a.keyy,a.total_deals_present,b.total_deals 
from(
select 'Ashneer' as keyy,count(ashneer_amount_invested) total_deals_present 
from project..data 
where ashneer_amount_invested is not null) a
inner join 
(select 'Ashneer' as keyy,count(ashneer_amount_invested) total_deals 
from project..data 
where ashneer_amount_invested is not null AND ashneer_amount_invested!=0) b 
on a.keyy=b.keyy) m
inner join 
(SELECT 'Ashneer' as keyy,SUM(C.ashneer_amount_invested) total_amount_invested,
AVG(C.ASHNEER_EQUITY_TAKEN) avg_equity_taken
FROM 
(SELECT * 
FROM PROJECT..DATA 
WHERE ASHNEER_EQUITY_TAKEN!=0 AND ASHNEER_EQUITY_TAKEN IS NOT NULL) C) n
on m.keyy=n.keyy

-- which is the startup in which the highest amount has been invested in each domain/sector

select c.* 
from 
(select brand,sector,amount_invested_lakhs,rank() over(partition by sector order by amount_invested_lakhs desc) rnk 
from project..data) c
where c.rnk=1