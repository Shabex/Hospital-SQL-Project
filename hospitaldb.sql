
-- Clean up existing tables

DROP TABLE IF EXISTS billing CASCADE;
DROP TABLE IF EXISTS admission CASCADE;
DROP TABLE IF EXISTS appointment CASCADE;
DROP TABLE IF EXISTS date CASCADE;
DROP TABLE IF EXISTS doctor CASCADE;
DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS patient CASCADE;

-- CASCADE allows SQL to automatically remove or update all dependent objects 
-- (such as foreign key relationships) when a table or record is dropped or deleted, 
--instead of blocking the operation to protect data integrity.

-- CREATE PATIENT DIMENSION TABLE

CREATE TABLE patient (
    patient_key SERIAL PRIMARY KEY,
    patient_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    date_of_birth DATE,
    age INT,
    city VARCHAR(50),
    registration_date DATE
);

-- INSERT PATIENT DATA

INSERT INTO patient (patient_id, first_name, last_name, gender, date_of_birth, age, city, registration_date) VALUES
('P001','Brian','Kamau','Male','1995-06-10',30,'Nairobi','2025-01-05'),
('P002','Faith','Achieng','Female','2001-03-18',24,'Kisumu','2025-01-10'),
('P003','Kevin','Mutua','Male','1988-11-25',36,'Machakos','2025-01-15'),
('P004','Mercy','Wanjiku','Female','1992-07-14',32,'Nakuru','2025-01-18'),
('P005','John','Otieno','Male','1985-01-30',40,'Mombasa','2025-02-01'),
('P006','Susan','Naliaka','Female','1998-09-09',26,'Eldoret','2025-02-05'),
('P007','Peter','Mwangi','Male','1979-12-12',45,'Nairobi','2025-02-10'),
('P008','Alice','Chebet','Female','2003-05-22',21,'Kericho','2025-02-12'),
('P009','Daniel','Omondi','Male','1990-08-17',34,'Kisumu','2025-02-20'),
('P010','Janet','Muthoni','Female','1987-04-03',37,'Thika','2025-03-01');

select * from health.patient p;

-- CREATE DEPARTMENT TABLE

CREATE TABLE department (
    department_key SERIAL PRIMARY KEY,
    department_id VARCHAR(20) UNIQUE NOT NULL,
    department_name VARCHAR(100)
);

-- INSERT DEPARTMENT DATA

INSERT INTO department (department_id, department_name) VALUES
('D001','Cardiology'),
('D002','Pediatrics'),
('D003','Orthopedics'),
('D004','Radiology'),
('D005','General Medicine'),
('D006','Gynecology');

select * from health.department;

-- CREATE DOCTOR TABLE

CREATE TABLE doctor (
    doctor_key SERIAL PRIMARY KEY,
    doctor_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100),
    department_key INT REFERENCES department(department_key),
    hire_date DATE
);

-- INSERT DOCTOR DATA

INSERT INTO doctor (doctor_id, first_name, last_name, specialization, department_key, hire_date) VALUES
('DR001','James','Mwangi','Cardiologist',1,'2023-01-15'),
('DR002','Mercy','Atieno','Pediatrician',2,'2022-07-11'),
('DR003','David','Otieno','Orthopedic Surgeon',3,'2021-05-20'),
('DR004','Ann','Wanjiku','General Physician',5,'2024-02-10'),
('DR005','Samuel','Kiptoo','Radiologist',4,'2020-10-05'),
('DR006','Grace','Njeri','Gynecologist',6,'2023-06-18'),
('DR007','Paul','Ochieng','General Physician',5,'2022-09-12'),
('DR008','Lydia','Chepkemoi','Pediatrician',2,'2021-11-01');

select * from health.doctor;

-- CREATE DATE DIMENSION TABLE

CREATE TABLE date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day_number INT,
    day_name VARCHAR(20),
    week_number INT,
    month_number INT,
    month_name VARCHAR(20),
    quarter_number INT,
    year_number INT
);

-- INSERT DATE DATA

INSERT INTO date VALUES
(20250210,'2025-02-10',10,'Monday',7,2,'February',1,2025),
(20250211,'2025-02-11',11,'Tuesday',7,2,'February',1,2025),
(20250212,'2025-02-12',12,'Wednesday',7,2,'February',1,2025),
(20250301,'2025-03-01',1,'Saturday',9,3,'March',1,2025),
(20250303,'2025-03-03',3,'Monday',10,3,'March',1,2025),
(20250305,'2025-03-05',5,'Wednesday',10,3,'March',1,2025),
(20250308,'2025-03-08',8,'Saturday',10,3,'March',1,2025),
(20250310,'2025-03-10',10,'Monday',11,3,'March',1,2025),
(20250312,'2025-03-12',12,'Wednesday',11,3,'March',1,2025),
(20250315,'2025-03-15',15,'Saturday',11,3,'March',1,2025),
(20250318,'2025-03-18',18,'Tuesday',12,3,'March',1,2025);

select * from health.date;

CREATE TABLE appointment (
    appointment_key SERIAL PRIMARY KEY,
    appointment_id VARCHAR(20),
    patient_key INT REFERENCES patient(patient_key),
    doctor_key INT REFERENCES doctor(doctor_key),
    department_key INT REFERENCES department(department_key),
    appointment_date_key INT REFERENCES date(date_key),
    appointment_date DATE,
    appointment_time TIME,
    appointment_status VARCHAR(20),
    diagnosis VARCHAR(150),
    consultation_fee NUMERIC(10,2)
);

-- INSERT APPOINTMENT DATA

INSERT INTO appointment VALUES
(DEFAULT,'A001',1,1,1,20250210,'2025-02-10','09:00','Completed','Hypertension',2500),
(DEFAULT,'A002',2,2,2,20250211,'2025-02-11','10:30','Completed','Malaria',1800),
(DEFAULT,'A003',3,4,5,20250212,'2025-02-12','14:00','Cancelled','General Checkup',1500),
(DEFAULT,'A004',1,4,5,20250301,'2025-03-01','11:00','Completed','Flu',1200),
(DEFAULT,'A005',4,6,6,20250303,'2025-03-03','08:30','Completed','Routine Review',2200),
(DEFAULT,'A006',5,3,3,20250305,'2025-03-05','13:15','Completed','Fracture',3000),
(DEFAULT,'A007',6,5,4,20250305,'2025-03-05','15:45','Completed','X-Ray Request',2000),
(DEFAULT,'A008',7,1,1,20250308,'2025-03-08','09:20','No-show','Chest Pain',2500),
(DEFAULT,'A009',8,8,2,20250310,'2025-03-10','10:10','Completed','Fever',1700),
(DEFAULT,'A010',9,7,5,20250312,'2025-03-12','12:40','Completed','Diabetes Review',2100);

select * from health.appointment;

-- CREATE BILLING FACT TABLE

CREATE TABLE billing (
    billing_key SERIAL PRIMARY KEY,
    bill_id VARCHAR(20),
    patient_key INT REFERENCES patient(patient_key),
    doctor_key INT REFERENCES doctor(doctor_key),
    department_key INT REFERENCES department(department_key),
    bill_date_key INT REFERENCES date(date_key),
    bill_date DATE,
    service_type VARCHAR(50),
    bill_status VARCHAR(20),
    total_amount NUMERIC(10,2),
    paid_amount NUMERIC(10,2),
    balance_amount NUMERIC(10,2),
    payment_method VARCHAR(30)
);

-- INSERT BILLING DATA

INSERT into billing VALUES
(DEFAULT,'B001',1,1,1,20250210,'2025-02-10','Consultation','Paid',4000,4000,0,'Cash'),
(DEFAULT,'B002',2,2,2,20250211,'2025-02-11','Consultation','Partial',3000,1500,1500,'Mobile Money'),
(DEFAULT,'B003',3,4,5,20250212,'2025-02-12','Consultation','Unpaid',1500,0,1500,'Cash'),
(DEFAULT,'B004',1,4,5,20250301,'2025-03-01','Consultation','Paid',1200,1200,0,'Card'),
(DEFAULT,'B005',4,6,6,20250303,'2025-03-03','Procedure','Paid',5000,5000,0,'Insurance'),
(DEFAULT,'B006',5,3,3,20250305,'2025-03-05','Procedure','Partial',8000,5000,3000,'Card'),
(DEFAULT,'B007',6,5,4,20250305,'2025-03-05','Lab','Paid',2500,2500,0,'Mobile Money'),
(DEFAULT,'B008',7,1,1,20250308,'2025-03-08','Consultation','Unpaid',2500,0,2500,'Cash'),
(DEFAULT,'B009',8,8,2,20250310,'2025-03-10','Consultation','Paid',1700,1700,0,'Cash'),
(DEFAULT,'B010',9,7,5,20250312,'2025-03-12','Consultation','Partial',4200,2000,2200,'Insurance');

select * from health.billing;

-- CREATE ADMISSION FACT TABLE

CREATE TABLE admission (
    admission_key SERIAL PRIMARY KEY,
    admission_id VARCHAR(20),
    patient_key INT REFERENCES patient(patient_key),
    doctor_key INT REFERENCES doctor(doctor_key),
    department_key INT REFERENCES department(department_key),
    admission_date DATE,
    discharge_date DATE,
    ward_name VARCHAR(50),
    bed_number VARCHAR(20),
    admission_reason VARCHAR(150),
    discharge_status VARCHAR(30),
    length_of_stay INT,
    admission_cost NUMERIC(10,2)
);

-- INSERT ADMISSION DATA

INSERT INTO admission VALUES
(DEFAULT,'AD001',1,1,1,'2025-02-10','2025-02-14','Cardiac Ward','B01','Hypertension Monitoring','Discharged',4,18000),
(DEFAULT,'AD002',5,3,3,'2025-03-05','2025-03-10','Ortho Ward','B12','Fracture Management','Discharged',5,25000),
(DEFAULT,'AD003',10,6,6,'2025-03-12','2025-03-18','Maternity Ward','M03','Observation','Discharged',6,22000),
(DEFAULT,'AD004',7,1,1,'2025-03-08',NULL,'Cardiac Ward','B05','Chest Pain Observation','Ongoing',NULL,12000),
(DEFAULT,'AD005',9,7,5,'2025-03-10','2025-03-15','General Ward','G07','Diabetes Monitoring','Discharged',5,16000);

select * from health.admission;

SELECT * FROM health.patient;

SELECT * FROM health.department;

SELECT * FROM health.doctor;

SELECT * FROM health.date;

SELECT * FROM health.appointment;

SELECT * FROM health.billing;


-- AGGREGATE FUNCTIONS

-- Q1 Determine the total number of patients registered in the hospital.
create view total_patients as
select count(*) 
	from health.patient p;

-- Q2 Find the average age of patients in the system.
select 
	avg(age) from health.patient;

-- Q3 Calculate the total revenue generated from all hospital bills.
create view total_revenue as
select sum(b.total_amount) sum_rev
	from health.billing b;

-- Q4 Identify the highest single bill recorded in the hospital.
select max(b.total_amount) highest_bill
	from health.billing b;

-- Q5 Determine the total amount of money that has been paid by patients so far.
select sum(paid_amount) cleared_bill
	from health.billing b;

-- Q6 Calculate the total outstanding balance across all bills.
select sum(b.balance_amount) arrears
	from billing b;

-- Q7 Find the average consultation fee charged during appointments.
select avg(a.consultation_fee) avg_consultation
	from health.appointment a;

-- Q8 Determine how many admissions have been recorded in the hospital.
select count(*) total_admissions
	from health.admission a;


-- GROUP BY

-- Q9 Determine how many patients come from each city.
select city, 
		count(*) patient_count
	from health.patient p 
	group by city;

-- Q10 Find how many doctors work in each department.
select department_key,
		count(*) doctors_count
	from health.doctor d
	group by department_key;

-- Q11 Calculate the total number of appointments handled by each doctor.
select a.doctor_key,
		count(*) appointment_count	
from health.appointment a
group by doctor_key;

-- Q12 Determine the number of appointments handled by each department.
select a.department_key ,
		count(*) appointment_count	
from health.appointment a
group by a.department_key;

-- Q13 Calculate the total revenue generated by each department.
select 
		department_key,
		sum(total_amount) rev_depart
	from health.billing b 
	group by b.department_key;

-- Q14 Determine the number of bills recorded under each billing status.
select 
		bill_status,
		count(*)
	from health.billing b
	group by b.bill_status;

-- Q15 Find the total admission cost generated by each department.
select department_key,
		sum(admission_cost)
	from health.admission
	group by department_key;


-- HAVING

-- Q16 Identify departments that have handled more than two appointments.
select 
		department_key
	from health.appointment a
	group by a.department_key 
	having count(*) > 2;

-- Q17 Find doctors who have attended at least two patients.
select a.doctor_key 
	from health.appointment a
	group by a.doctor_key 
	having count(a.patient_key) >= 2;

-- Q18 Determine which cities have more than one registered patient.
select p.city 
	from health.patient p
	group by city
	having count(*) > 1;

-- Q19 Identify departments whose total billing amount exceeds 5,000.
select b.department_key
	from health.billing b
	group by b.department_key 
	having sum(total_amount)>5000;

-- Q20 Find doctors whose patients have generated more than 4,000 in billing.
select b.doctor_key 
	from health.billing b
	group by b.doctor_key 
	having sum(total_amount)>4000;


-- INNER JOINS

-- Q21 Produce a list showing each appointment along with the patient’s full name.

select  concat(p.first_name, ' ',p.last_name) full_name
	from health.patient p
	join health.appointment a
	using(patient_key);

-- Q22 Show the doctor responsible for each appointment together with the diagnosis.
select concat(d.first_name, ' ',d.last_name) full_name
	from health.doctor d 
	join health.appointment a 
		using(doctor_key);
		
-- Q23 Display the department name for each doctor.
select concat(d.first_name, ' ',d.last_name) doc_name, department_name 
	from health.doctor d 
	join health.department d2 
	using(department_key);

-- Q24 Produce a list showing patient names, their doctors, and the department visited during appointments.
select * from patient p;
select * from doctor d;
select * from department d2;
select * from appointment a;

select 
		concat(p.first_name, ' ',p.last_name) patient_name,
		concat(d.first_name, ' ',d.last_name) doc_name,
		d2.department_name 
	from appointment a 
	join department d2 
		using(department_key)
	join patient p 
		using(patient_key)
	join doctor d 
		using(doctor_key);
		

-- Q25 Show the bill details together with the patient names responsible for each bill.
select 
		concat(p.first_name, ' ',p.last_name) patient_name,
		b.* 
	from billing b
	join patient p 
		using(patient_key);

-- Q26 Display the doctor who handled each billed service together with the total amount.
select 
		concat(d.first_name, ' ',d.last_name) doc_name,
		b.total_amount 
	from billing b
	join doctor d 
		using(doctor_key);

-- LEFT JOINS

-- Q27 Produce a list of all patients and indicate whether they have had an appointment.
select * from health.patient p;
select * from health.appointment a;


select 
		p.patient_id,
		a.appointment_id,
		a.appointment_date,
		case 
			when a.appointment_date is null then 'No appointment'
			else 'Appointment'
		end as status	
	from health.patient p 
	left join health.appointment a 
		using(patient_key)
	order by a.patient_key;

-- Q28 Display all doctors and show the appointments they have handled, including those with none.
select * from doctor d;
select * from appointment a;

select 
		d.doctor_id,
		a.appointment_id 
	from doctor d
	left join appointment a 
		using(doctor_key)
	order by d.doctor_key;

-- Q29 Show every department and any appointments associated with them.
select * from department d ;
select * from appointment a;

select 
		d.department_id,
		a.appointment_id 
	from department d 
	left join appointment a 
		using(department_key)
	order by a.department_key;


-- Q30 Display all patients and their billing information, including patients who have never been billed.
select 
		concat(p.first_name, ' ',p.last_name) patient_name,
		b.*
	from patient p
	left join billing b 
		using(patient_key);


-- CASE

-- Q31 Categorize bills into payment groups such as fully paid, partially paid, or unpaid.
select bill_id, b.total_amount, b.paid_amount, b.balance_amount,
		case 
			when total_amount = paid_amount then 'Fully_paid'
			when total_amount > paid_amount and paid_amount>0 then 'Partialy_paid'
			else 'Unpaid'
		end payment_status	
	from billing b
	order by payment_status;

-- Q32 Create a category showing whether a patient is considered young, middle-aged, or senior based on age.
select patient_id,
		age,
		case
			when age between 0 and 24 then 'Young'
			when age between 25 and 40 then 'Middle_aged'
			else 'Senior'
		end	age_category
	from patient;

-- Q33 Classify admissions into short stay or long stay depending on the length of stay.
select admission_id,
		length_of_stay,
		case 
			when a.length_of_stay <= 4 then 'Short_stay'
			else 'long_stay'
		end	stay_ctaegory
	from admission a
	where a.length_of_stay is not null;

-- Q34 Create a category that flags appointments as successful or unsuccessful based on their status.
select 
		appointment_id,
		appointment_status,
		case
			when appointment_status like 'Completed' then 'Successful'
			else 'Unsuccessful'
		end	
	from appointment a;


-- ALIASES AND CALCULATED COLUMNS

-- Q35 Display patient names as a single column combining first and last name.
select 
		concat(p.first_name, ' ',p.last_name) patient_name
	from patient p;

-- Q36 Create a column showing the total bill amount still owed for each billing record.
select 
		b.bill_id,
		b.total_amount - b.paid_amount bill_owed
	from billing b;

-- Q37 Calculate the percentage of each bill that has been paid.
select 
		b.bill_id,
		b.total_amount,
		b.paid_amount,
		round((b.paid_amount/b.total_amount ),2)  as  percentage_paid
	from billing b
	where b.paid_amount != 0;

-- Q38 Display the length of stay for each admission calculated from the admission and discharge dates.
select a.admission_date,
		discharge_date,
		(a.discharge_date - a.admission_date ) length_stay
	from admission a;


-- SUBQUERIES

-- Q39 Find patients who are older than the average age of all patients.
select 
		patient_id,
		age
	from patient p 
	where age > (select AVG(age) from patient p2);

-- Q40 Identify the doctor who handled the highest number of appointments.
select doctor_key, d.doctor_id,
	d.first_name, d.last_name 
	from (select a.doctor_key,
		count(a.appointment_id) as count_app,
		dense_rank() over(order by count(a.appointment_id) desc) rankings
	from appointment a 
	group by a.doctor_key)
	join doctor d 
		using(doctor_key)
	where rankings = 1;
	
-- Q41 Find the patient responsible for the highest bill in the system.
select b.patient_key, p.first_name, p.last_name, b.total_amount 
	from billing b
	join patient p 
		using(patient_key)
	where b.total_amount = (select max(b.total_amount ) from billing b);

-- Q42 Identify patients who have at least one admission recorded.
select patient_key,
		count(a.admission_id) 
	from admission a
	group by a.patient_key 
	having count(a.admission_id) >=1;

-- Q43 Determine departments whose billing totals are above the hospital average.
select department_key, b.total_amount
	from billing b 
	group by b.department_key, b.total_amount  
	having sum(b.total_amount)>(select AVG(b2.total_amount) from billing b2);


-- CTES

-- Q44 Calculate total billing per department and determine which department generates the most revenue.
with cte as 
			(
			select 
					department_key,
					sum(b.total_amount),
					dense_rank() over(order by sum(b.total_amount) desc) as bill_rank
				from billing b
				group by b.department_key
			)
	select department_key
		from cte
		where bill_rank = 1;

-- Q45 Calculate total appointments handled by each doctor and determine the top three doctors.
with cte as 
			(
			select 
					doctor_key,
					count(appointment_id),
					dense_rank() over(order by count(appointment_id) desc) as app_rank
				from appointment a 
				group by a.doctor_key 
			)
		select doctor_key
			from cte
			where app_rank <=3;
		
		
-- Q46 Compute the total payments received from each patient and list them in descending order.

select 
		p.patient_key,
		sum(b.paid_amount) as sum_paid
	from patient p
	join billing b 
		using(patient_key)
	group by p.patient_key
	order by sum_paid desc;


-- WINDOW FUNCTIONS

-- Q47 Rank all doctors based on the number of appointments they have handled.
select a.doctor_key,
		count(a.appointment_id),
		dense_rank() over(order by count(a.appointment_id) desc) as rankin
	from appointment a 
	group by a.doctor_key;

-- Q48 Rank departments based on the revenue they have generated.
select department_key,
		sum(b.total_amount),
		dense_rank() over(order by sum(b.total_amount) desc )
	from billing b 
	group by b.department_key;

-- Q49 Assign a rank to patients based on the total billing amount associated with them.
select patient_key,
		sum(b.total_amount),
		dense_rank() over(order by sum(b.total_amount) desc )
	from billing b 
	group by b.patient_key;

-- Q50 Determine how each bill compares to the average bill amount.
with cte as 
			(
			select bill_id,
					sum(b.total_amount) sum_rev,
					AVG(total_amount) over() avg_rev
				from billing b
				group by b.bill_id, b.total_amount
				order by b.bill_id
			)
		select 
				bill_id,
				sum_rev,
				round(sum_rev/avg_rev,2) total_vs_avg 
			from cte;

-- Q51 Display a running total of revenue collected over time based on bill dates.
select 
		b.bill_id,
		b.total_amount,
		sum(b.total_amount) over(order by b.billing_key) rolling_sum
	from billing b;


-- STORED PROCEDURES OR FUNCTIONS

select * from health.billing;

-- Q52 Create a routine that returns all billing records for a specific patient.
create or replace function billing_record() 
returns table(
	billing_key int,
	billing_id varchar,
	patient_key int,
	doctor_key int,
	department_key int,
	bill_date_key int,
	bill_date date,
	service_type varchar,
	bill_status varchar,
	total_amount numeric,
	paid_amount numeric,
	balance_amount numeric,
	payment_method varchar
)
language plpgsql
as $$
begin
	return query
	select *
	from health.billing;
end;
$$;

select * from billing_record();


-- Q53 Build a routine that calculates the total revenue generated by a given department.
create or replace function department_rev()
returns table (
		department_key int,
		department_id varchar,
		department_name varchar,
		total_rev numeric		
	)
language plpgsql
as $$
begin
	return query
		select 
				b.department_key,
				d.department_id,
				d.department_name,
				sum(b.total_amount) as total_rev
			from health.department d
			join health.billing b
				using(department_key)
			group by 1,2,3
			order by total_rev desc;
end;
$$;

select * from department_rev()
	order by total_rev desc;


-- Q54 Create a routine that lists all appointments handled by a specific doctor.
create or replace function appointment_list()
returns table (
	appointment_id varchar,
	doctor_id varchar,
	diagnosis varchar
)
language plpgsql
as $$
begin
	return query
	select 
		a.appointment_id,
		d.doctor_id,
		a.diagnosis	
	from health.appointment a 
	join health.doctor d 
		using(doctor_key);
end;
$$;

select * from appointment_list();

-- Q55 Develop a routine that returns all unpaid bills in the hospital.
create or replace function unpaid_bills()
returns table (
		bill_id varchar
	)
language plpgsql
as $$
begin
	return query
		select  	
				b.bill_id
			from health.billing b
			where b.paid_amount = 0;	
end;
$$;

select * from unpaid_bills();


-- Q56 Create a routine that returns the top performing doctors based on number of appointments.

drop function if exists top_doc();

create or replace function top_doc()
returns table(
		doctor_id varchar,
		ranking int
	)
language plpgsql
as $$
begin
	return query
		with cte as 
		(
		select 
				d.doctor_id,
				dense_rank() over(order by count(a.appointment_id)desc)::int ranking
			from health.doctor d
			join health.appointment a 
				using(doctor_key)
			group by d.doctor_id
		)
	select 
			cte.doctor_id,
			cte.ranking
		from cte
		where cte.ranking = 1;
end;
$$;

select * from top_doc();





-- ADVANCED MULTI-CONCEPT QUESTIONS

-- Q57 Determine the total billing amount generated by each department and return the departments from highest to lowest revenue.
select * from health.department d;
select * from health.billing b;

select 
		d.department_id,
		sum(b.total_amount) as sum_rev
	from health.billing b
	join health.department d
		using(department_key)
	group by d.department_id
	order by sum_rev desc;

-- Which Department Generated the third highest income? and how much was it?
with cte as 
			(
			select 
					d.department_id as department,
					sum(b.total_amount) sum_rev,
					dense_rank() over(order by sum(b.total_amount)desc) as ranks
				from health.billing b
				join health.department d
					using(department_key)
				group by d.department_id
				order by sum_rev desc
			)
	select 
			department,
			sum_rev
		from cte
		where ranks = 3;

-- Q58 Find the total number of appointments handled by each doctor together with the department each doctor belongs to.
select 
		d.doctor_id,
		d2.department_name, 
		count(a.appointment_id)
	from health.appointment a
	join health.doctor d 
		using(doctor_key)
	join health.department d2 
		on a.department_key = d2.department_key 
	group by d.doctor_id,d2.department_name;

-- Q59 Identify patients whose total billing amount is greater than the overall average billing amount across all patients.

select 
		b.patient_key,
		sum(b.total_amount)
	from health.billing b 
	group by b.patient_key 
	having sum(b.total_amount) > (select avg(b2.total_amount) from health.billing b2);

-- Q60 Find doctors whose total number of appointments is higher than the average number of appointments handled by all doctors.
with cte as
			(
			select 
					a.doctor_key doc_key,
					count(a.appointment_id) count_app
				from health.appointment a
				group by a.doctor_key
			),
	cte2 as 
			(
			select avg(count_app) from cte
			)
	select 
			doc_key,
			sum(count_app)
		from cte 
		group by cte.doc_key
		having sum(count_app)>(select avg(count_app) from cte);


-- Q61 Calculate the total billing amount for each patient and rank patients from highest to lowest total billing.
select 
		patient_key,
		sum(b.total_amount) as sum_rev
	from health.billing b
	group by b.patient_key
	order by sum_rev desc;

-- Q62 Compute total revenue for each department and assign a dense rank from the highest earning department to the lowest.
select 
		department_key,
		sum(b.total_amount) as sum_rev
	from health.billing b
	group by b.department_key
	order by sum_rev desc;

-- Q63 Calculate the total number of appointments handled by each doctor and return the top three doctors based on workload.
select 
		concat(d.first_name,' ',d.last_name) doc_name,
		count(a.appointment_key) count_app
	from health.appointment a
	join health.doctor d 
		using(doctor_key)
	group by d.first_name,d.last_name
	order by count_app desc
	limit 3;

-- Q64 Determine the total billing amount generated by each doctor, show the doctor's full name and department name, and rank doctors from highest to lowest revenue.
select 
			concat(d.first_name,' ',d.last_name) doc_name,
			d2.department_name dep_name,
			sum(b.total_amount) as sum_rev,
			dense_rank() over(order by sum(b.total_amount) desc) ranks
		from health.doctor d
		join health.billing b 
			using(doctor_key)
		join health.department d2
			on d.department_key = d2.department_key
		group by d.first_name,d.last_name,d2.department_name 
		
-- Q65 Calculate the total billing amount for each patient, include the patient's city, and rank patients within each city from highest spender to lowest.
select 
		p.patient_id,
		p.city,
		SUM(b.total_amount) as sum_rev,
		dense_rank() over(partition by p.city order by p.city, SUM(b.total_amount) desc) as ranks
	from health.patient p
	join health.billing b 
		using(patient_key)
	group by p.patient_id,p.city;

-- Q66 Determine the total appointments handled by each doctor, include the department name, and identify the top doctor in each department.
with cte as
			(
			select 
					d.doctor_id doc_id,
					d2.department_name dep_name,
					count(a.appointment_key) as app_count,
					dense_rank() over(partition by d2.department_name order by count(a.appointment_key) desc) as ranks
				from health.appointment a
				join health.doctor d 
					using(doctor_key)
				join health.department d2 
				on d.department_key = d2.department_key
				group by d.doctor_id, d2.department_name
			)
		select 
				doc_id,
				dep_name,
				app_count
			from cte 
			where ranks = 1;

-- Q67 Calculate the total revenue generated by each department and show the difference between each department’s revenue and the highest department revenue.
with cte as
			(
			select 
					d.department_name dep_name,
					sum(total_amount) as sum_rev
				from health.billing
				join health.department d 
					using(department_key)
				group by d.department_name
			)
	select 
			dep_name,
			sum_rev,
			max(sum_rev) over() max_rev,
			sum_rev - max(sum_rev) over() as diff
		from cte;

-- Q68 Calculate the total billing amount for each patient, include patient and doctor details, and rank patients by total billing within each doctor’s patient list.
select 
			concat(p.first_name, ' ', p.last_name) as full_name,
			concat(d.first_name, ' ', d.last_name) as doc_name,
			sum(b.total_amount) sum_rev,
			dense_rank() over(partition by d.doctor_id order by sum(b.total_amount) desc) as ranks
		from health.patient p
		join health.billing b 
			using(patient_key)
		join health.doctor d 
			on d.doctor_key = b.doctor_key
		group  by p.first_name, p.last_name, d.first_name, d.last_name, d.doctor_id;	

-- Q69 For each patient, compare their total billing amount to the hospital-wide average patient billing amount and label them as Above Average or Below Average.
with cte1 as
				(
				select
						patient_id,
						sum(total_amount) total_bill
					from health.patient p 
					join health.billing b
						using(patient_key)
					group by p.patient_id
				),
		cte2 as 
				(
				select avg(total_amount) as avg_bill from health.billing
				)
		select 
				cte1.patient_id,
				cte1.total_bill,
				cte2.avg_bill,
				case 
					when cte1.total_bill > cte2.avg_bill then 'Above_Average'
					when cte1.total_bill < cte2.avg_bill then 'Below Average'
					else 'Average'
				end	as bill_class
			from cte1
			cross join cte2
			order by bill_class;
;

-- Q70 For each doctor, compare their total appointment count to the overall average appointment count and classify them as High Workload or Low Workload.
with cte as 		
			(	
			select 
					doctor_id,
					count(appointment_id) as count
				from health.doctor d
				join health.appointment p
				using(doctor_key)
				group by d.doctor_id
				),
		cte2 as 
				(
				select avg(count) as average from cte
				)
		select 
				cte.doctor_id,
				cte.count,
				cte2.average,
				case 
					when cte.count > cte2.average then 'High Workload'
					else 'Low Workload'
				end Workload
			from cte
			cross join cte2;

-- Q71 Display each bill together with the patient name and department name and assign a rank to the bills from the highest amount to the lowest amount.
select 
		concat(p.first_name,' ', p.last_name) patient_name,
		d.department_name,
		sum(b.total_amount) total_bill,
		dense_rank() over(order by sum(b.total_amount) desc)
	from health.patient p
	join health.billing b
		using(patient_key)
	join health.department d
	on d.department_key = b.department_key
	group by p.first_name,p.last_name,d.department_name;

-- Q72 Calculate the total revenue generated by each department and show the difference between each department’s revenue and the overall highest department revenue.
with cte as
			(
			select 
					d.department_name dep_name,
					sum(total_amount) as sum_rev
				from health.billing
				join health.department d 
					using(department_key)
				group by d.department_name
			),
	cte2 as 	
			(
			select 
					max(total_amount) max_rev
				from health.billing b
			)
	select 
			dep_name,
			sum_rev,
			max_rev,
			sum_rev - max_rev as diff
		from cte
		cross join cte2;












