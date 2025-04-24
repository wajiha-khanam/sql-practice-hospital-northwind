
-- EASY: 
-- Q1: Show first name, last name, and gender of patients whose gender is 'M'.
SELECT first_name, last_name, gender
FROM patients
where gender = 'M';

  
-- Q2: Show first name and last name of patients who does not have allergies. (null).
SELECT first_name, last_name
FROM patients
where allergies is null;


-- Q3: Show first name of patients that start with the letter 'C'.
SELECT first_name
FROM patients
where first_name like 'C%';


-- Q4: Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT first_name, last_name
FROM patients
where weight between 100 and 120;


-- Q5: Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'.
update patients
set allergies = 'NKA'
where allergies is null;


-- Q6: Show first name and last name concatinated into one column to show their full name.
select concat(first_name, ' ', last_name) as full_name
from patients;


-- Q7: Show first name, last name, and the full province name of each patient.
-- Example: 'Ontario' instead of 'ON'
select p.first_name, p.last_name, pn.province_name
from patients p 
join province_names pn on p.province_id = pn.province_id;


-- Q8: Show how many patients have a birth_date with 2010 as the birth year.
select count(*)
from patients 
where year(birth_date) = 2010;



-- Q9: Show the first_name, last_name, and height of the patient with the greatest height.
select first_name, last_name, height
from patients 
where height = (select max(height) from patients);


-- Q10: Show all columns for patients who have one of the following patient_ids:
-- 1,45,534,879,1000
select *
from patients 
where patient_id in (1,45,534,879,1000);


-- Q11: Show the total number of admissions.
select count(*)
from admissions;


-- Q12: Show all the columns from admissions where the patient was admitted and discharged on the same day.
select *
from admissions
where admission_date = discharge_date;


-- Q13: Show the patient id and the total number of admissions for patient_id 579.
select patient_id, count(*)
from admissions
where patient_id = 579
group by patient_id;


-- Q14: Based on the cities that our patients live in, show unique cities that are in province_id 'NS'.
select distinct city
from patients
where province_id = 'NS';


-- Q15: Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70.
select first_name, last_name, birth_date
from patients
where height > 160 and weight > 70;


-- Q16: Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton'
select first_name, last_name, allergies
from patients
where allergies is not null and city = 'Hamilton';



-- MEDIUM:
-- Q1: Show unique birth years from patients and order them by ascending.
select distinct year(birth_date)
from patients
order by year(birth_date);


-- Q2: Show unique first names from the patients table which only occurs once in the list.
-- For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
with cte as (
select first_name, count(*) as un_count
from patients
group by first_name
)
select first_name
from cte
where un_count = 1;


-- Q3: Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select patient_id , first_name
from patients
where first_name like 's%s' and length(first_name) >= 6;


-- Q4: Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
-- Primary diagnosis is stored in the admissions table.
select p.patient_id , p.first_name, p.last_name
from patients p 
join admissions a on p.patient_id = a.patient_id
where a.diagnosis = 'Dementia';


-- Q5: Display every patient's first_name.
-- Order the list by the length of each name and then by alphabetically.
select first_name
from patients 
order by length(first_name), first_name;


-- Q6: Show the total amount of male patients and the total amount of female patients in the patients table.
-- Display the two results in the same row.
SELECT 
sum(case when gender = 'M' then 1 else 0 end) as male_count,
sum(case when gender = 'F' then 1 else 0 end) as female_count
FROM patients;


-- Q7: Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
SELECT 
first_name, last_name, allergies
FROM patients
where allergies = 'Penicillin' or allergies = 'Morphine'
order by allergies, first_name, last_name;


-- Q8: Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
SELECT 
patient_id, diagnosis
FROM admissions
group by patient_id, diagnosis
having count(*) > 1;


-- Q9: Show the city and the total number of patients in the city.
-- Order from most to least patients and then by city name ascending.
SELECT city, count(patient_id) as total
FROM patients
group by city
order by total desc, city;


-- Q10: Show first name, last name and role of every person that is either patient or doctor.
-- The roles are either "Patient" or "Doctor".
SELECT first_name, last_name, 'Patient' as Role 
FROM patients 
union all 
 SELECT first_name, last_name, 'Doctor' as Role 
FROM doctors;


-- Q11: Show all allergies ordered by popularity. Remove NULL values from query.
SELECT allergies, count(*) as total_diagnosis
FROM patients
where allergies is not null
group by allergies
order by total_diagnosis desc;


-- Q12: Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
SELECT first_name, last_name, birth_date
FROM patients
where year(birth_date) between 1970 and 1979
order by birth_date;


-- Q13:We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
-- EX: SMITH,jane
SELECT concat(upper(last_name), ',', lower(first_name)) as full_name
FROM patients
order by first_name desc;


-- Q14: Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
SELECT province_id
, sum(height) as total_height
FROM patients
group by province_id
having sum(height)>= 7000;


-- Q15: Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'.
SELECT max(weight) - min(weight)
FROM patients
where last_name is 'Maroni';


-- Q16: Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
SELECT day(admission_date) as day_number, count(patient_id) as number_of_admissions
FROM admissions
group by day(admission_date) 
order by number_of_admissions desc;


-- Q17: Show all columns for patient_id 542's most recent admission_date.
SELECT * 
FROM admissions
where patient_id=542 and admission_date=
(select max(admission_date) from admissions where patient_id=542 group by patient_id);


-- Q18: Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
where  (patient_id %2 <> 0 and (attending_doctor_id = 1 or attending_doctor_id= 5 or attending_doctor_id = 19))
or (attending_doctor_id like '%2%' and (length(patient_id) =3));


-- Q19: Show first_name, last_name, and the total number of admissions attended for each doctor.
-- Every admission has been attended by a doctor.
SELECT d.first_name, d.last_name, count(a.patient_id) as admissions_total
from admissions a 
join doctors d on a.attending_doctor_id = d.doctor_id
group by d.first_name, d.last_name;


-- Q20: For each doctor, display their id, full name, and the first and last admission date they attended.
SELECT d.doctor_id, concat(d.first_name , " " , d.last_name), max(a.admission_date), min(a.admission_date)
FROM doctors d 
join admissions a on a.attending_doctor_id = d.doctor_id
group by d.doctor_id;


-- Q21: Display the total amount of patients for each province. Order by descending.
SELECT pn.province_name,count(*) as tot_count
from patients p 
join province_names pn on p.province_id = pn.province_id
group by p.province_id
order by tot_count desc;


-- Q22: For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
SELECT concat(p.first_name, " ", p.last_name), a.diagnosis, concat(d.first_name,' ', d.last_name)
from patients p 
join admissions a on p.patient_id = a.patient_id
join doctors d on a.attending_doctor_id = d.doctor_id;


-- Q23: display the first name, last name and number of duplicate patients based on their first name and last name.
-- Ex: A patient with an identical name can be considered a duplicate.
SELECT first_name, last_name, count(*)
from patients
group by first_name, last_name
having count(*) > 1;


-- Q24: Display patient's full name,
-- height in the units feet rounded to 1 decimal,
-- weight in the unit pounds rounded to 0 decimals,
-- birth_date,
-- gender non abbreviated.
-- Convert CM to feet by dividing by 30.48.
-- Convert KG to pounds by multiplying by 2.205.
SELECT concat(first_name,' ', last_name) as patient_name
, round((height/30.48),1) as 'height "Feet"'
, round(weight*2.205,0) as 'weight "Pounds"', birth_date, 
case when gender = 'M' then 'MALE'
else 'FEMALE' end as gender_type
from patients;


-- Q25: Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)
SELECT p.patient_id, p.first_name, p.last_name
from patients p 
where p.patient_id not in (select admissions.patient_id from admissions);


-- Q26: Display a single row with max_visits, min_visits, average_visits where the maximum, minimum and average number of admissions per day is calculated. Average is rounded to 2 decimal places.
with cte as (
SELECT admission_date, count(*) as tot
from admissions
group by admission_date
)
select max(tot), min(tot), round(avg(tot),2)
from cte;


-- HARD:
-- Q1: Show all of the patients grouped into weight groups.
-- Show the total amount of patients in each weight group.
-- Order the list by the weight group decending.
-- For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
SELECT count(patient_id) , floor(weight/10) * 10 as weight_group
FROM patients
group by weight_group
order by weight_group desc;


-- Q2: Show patient_id, weight, height, isObese from the patients table.
-- Display isObese as a boolean 0 or 1.
-- Obese is defined as weight(kg)/(height(m)2) >= 30.
-- weight is in units kg.
-- height is in units cm.
SELECT patient_id, weight, height,
case when weight/((height*0.01)*(height*0.01)) >= 30 then 1 else 0 end as isObese
from patients;


-- Q3: Show patient_id, first_name, last_name, and attending doctor's specialty.
-- Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
-- Check patients, admissions, and doctors tables for required information.
SELECT p.patient_id, p.first_name, p.last_name, d.specialty
from patients p 
join admissions a on p.patient_id = a.patient_id
join doctors d on a.attending_doctor_id = d.doctor_id
where a.diagnosis is 'Epilepsy' and d.first_name = 'Lisa';


-- Q4: All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
-- The password must be the following, in order:
-- 1. patient_id
-- 2. the numerical length of patient's last_name
-- 3. year of patient's birth_date
SELECT distinct a.patient_id, concat(a.patient_id, length(p.last_name), year(p.birth_date)) as temp_password
from patients p 
join admissions a ON P.patient_id = A.patient_id;


-- Q5: Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
-- Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.
SELECT 
case when patient_id % 2 = 0 then 'Yes' else 'No' end as has_insurance,
sum(case when patient_id % 2 is 0 then 10 else 50 end) as cost_after_insurance
FROM admissions
group by has_insurance;


-- Q6: Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name.
with cte as (
SELECT province_id,
sum(case when gender = 'M' then 1 else 0 end ) as male_count,
sum(case when gender = 'F' then 1 else 0 end) as female_count
from patients
group by province_id
)
select province_name
from cte ct 
join province_names pn on pn.province_id = ct.province_id
where male_count > female_count;


-- Q7: We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- - First_name contains an 'r' after the first two letters.
-- - Identifies their gender as 'F'
-- - Born in February, May, or December
-- - Their weight would be between 60kg and 80kg
-- - Their patient_id is an odd number
-- - They are from the city 'Kingston'
select *
from patients
where first_name like '__r%' 
and gender = 'F' 
and Month(birth_date) in (2,5,12)
and weight between 60 and 80
and patient_id % 2 <> 0
and city = 'Kingston';


-- Q8: Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.
SELECT 
   CONCAT(ROUND(SUM(gender='M') / 
                CAST(COUNT(*) AS float),4) * 100, '%')
FROM patients;


-- Q9: For each day display the total amount of admissions on that day. Display the amount changed from the previous date.
with cte as (
SELECT admission_date, count(patient_id) as admission_count,
  lag(count(patient_id)) over(order by admission_date) as prev_count
from admissions
group by admission_date
)
select admission_date, admission_count, admission_count - prev_count as admission_count_change
from cte;


-- Q10: Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.
SELECT province_name
FROM province_names
order by (case when province_name = 'Ontario' then 0 else 1 end), province_name;


-- Q11: We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
SELECT doctor_id, concat(first_name, ' ', last_name) as doctor_name,
specialty, year(admission_date) as selected_year, count(patient_id) as total_admissions
from admissions a 
join doctors d on a.attending_doctor_id = d.doctor_id
group by doctor_id, concat(first_name, ' ', last_name) ,
specialty, year(admission_date);





