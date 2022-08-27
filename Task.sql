use world;
select * from employee;
select * from vendor;
select * from insurance;

-- Task #1 : Merge the 3 dataset and create 1 view of data.-----------------------------------------------------
select * from insurance I inner join employee E on I.AGENT_ID=E.AGENT_ID
left join vendor V on V.VENDOR_ID=I.VENDOR_ID;

 -- Task #2 : Business Leader wants to find Top 3 Insurance Type where we are getting most insurance claims?-- ---------------------
select INSURANCE_TYPE,CLAIM_AMOUNT from insurance
order by CLAIM_AMOUNT desc  limit 3;

-- Task #3 : Business Leader wants to find Top 5 States where we are getting most insurance claims for customer belonging to HIGH(H) risk segment?------------------

select STATE ,CLAIM_AMOUNT from insurance 
where RISK_SEGMENTATION="H"
order by CLAIM_AMOUNT desc
limit 5;

-- Task #4 : Business wants to create a new variable “COLOCATION” which will have following values IF
-- Customer State == Incident State == Agent Address State THEN 1 ELSE 0 Find the mean of this new colum
select avg(if(V.STATE=E.STATE and V.STATE=I.STATE ,1,0 )) as "COLOCATION"
from insurance I inner join employee E on I.AGENT_ID=E.AGENT_ID
left join vendor V on V.VENDOR_ID=I.VENDOR_ID;

-- Task #5: Data entry error was detected in the data and you are required to correct it. If for any
-- claim transaction “AUTHORITY_CONTACTED” is NOT “Police” and POLICE_AVAILABLE == 1 Then Update “AUTHORITY_CONTACTED” to Police.
update  insurance
set AUTHORITY_CONTACTED="Police"
where (POLICE_REPORT_AVAILABLE = 1 and AUTHORITY_CONTACTED <> "Police");

-- Task #7 : Find All Agents who have worked on more than 2 types of Insurance Claims. Sort them by
 -- Total Claim Amount Approved under them in descending order
select distinct AGENT_ID, sum(CLAIM_AMOUNT) as "TOTEL_CLAIM_AMOUNT" from insurance 
group by AGENT_ID
having count(INSURANCE_TYPE)>2
order by CLAIM_AMOUNT desc;

-- Task #8 : Mobile & Travel Insurance premium are discounted by 10% -----------------------
-- Health and Property Insurance premium are increased by 7% -----------------------------
-- Life and Motor Insurance premium are marginally increased by 2% -----------------------
-- What will be overall change in % of the Premium Amount Collected for all these Customer? ------------
SELECT 
(sum(CASE 
WHEN INSURANCE_TYPE='Mobile' OR INSURANCE_TYPE='Travel' then PREMIUM_AMOUNT*0.9 - PREMIUM_AMOUNT
WHEN INSURANCE_TYPE='Health' OR INSURANCE_TYPE='Property' THEN PREMIUM_AMOUNT*1.07-PREMIUM_AMOUNT
ELSE PREMIUM_AMOUNT*1.02-PREMIUM_AMOUNT
END ))/sum(PREMIUM_AMOUNT) as "OVER ALL CHANGE IN % "
FROM insurance;
# TASK #9  Business wants to give discount to customer who are loyal and under stress due to Covid 19. They have laid down an eligibility Criteria as follow
#CUSTOMER_TENURE > 60 AND EMPLOYMENT_STATUS = “N”
#AND NO_OF_FAMILY_MEMBERS >=4 THEN 1 ELSE 

select 
AVG(
CASE 
WHEN TENURE > 60 AND EMPLOYMENT_STATUS = 'N' AND NO_OF_FAMILY_MEMBERS >=4 THEN 1 ELSE 0 
END
) AS 'LOYAL'
from insurance ;

-- TASK #12 : Business wants to find all Suspicious Employees (Agents).
select distinct AGENT_ID,if(SUM(CLAIM_AMOUNT)>=15000,1,0) AS "Suspicious" FROM insurance
where CLAIM_STATUS='A' AND RISK_SEGMENTATION ='H' AND INCIDENT_SEVERITY = 'Major Loss'
group by AGENT_ID;


-- Task 10 Business wants to check Claim Velocity which is defined as follow
SELECT MAX(TXN_DATE_TIME) FROM insurance ;
-- MOST RECENT DATE IS 2021-06-30
SELECT COUNT(TXN_DATE_TIME) FROM insurance
WHERE TXN_DATE_TIME >'2021-05-30 00:00:00';
SELECT COUNT(TXN_DATE_TIME) FROM insurance
WHERE TXN_DATE_TIME >'2021-06-26 00:00:00';
-- 811 CLAIMS IN LAST 30 DAYS AND 103 CLAIMS IN LAST 3 DAYS;
select 811/103 as 'velocity';


  
 




 