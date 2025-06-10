-- Using JOIN get the student names, school id, email, phone number (new_stud_details)
CREATE VIEW new_stud_details AS
SELECT contact_details.stud_email, contact_details.phone_number, personal_details.stud_ID, personal_details.stud_name
FROM contact_details
INNER JOIN personal_details ON contact_details.phone_number=personal_details.phone_number;

-- Create a table with all the details from contacts to school and financial details (full_stud_details)
CREATE VIEW full_stud_detail AS
SELECT contact_details.stud_email, contact_details.phone_number, contact_details.next_of_kin_name, contact_details.next_of_kin_relation, contact_details.next_of_kin_contacts, school_details.stud_ID, school_details.current_home_county, school_details.secondary_school_county,school_details.residence, financial_details.stud_name, financial_details.sem_fee, financial_details.fee_paid
FROM contact_details
INNER JOIN school_details ON contact_details.stud_email = school_details.stud_email
INNER JOIN financial_details ON school_details.stud_ID = financial_details.stud_ID

-- Add student names on any empty row of stud_name in financial_details
SET SQL_SAFE_UPDATES = 0;

UPDATE financial_details
JOIN personal_details ON financial_details.stud_ID = personal_details.stud_ID
SET financial_details.stud_name = personal_details.stud_name
WHERE financial_details.stud_name IS NULL OR financial_details.stud_name = '';

-- On the financial_details table add a column, fee_cleared, that has True if student has cleared current fee and False if not (financial_details_view)
ALTER TABLE financial_details
ADD COLUMN fee_cleared BOOLEAN;

UPDATE financial_details
SET fee_cleared = (sem_fee - fee_paid) <= 0;


-- Get the national ID and name of all students who have cleared their fees (fee_cleared)
CREATE VIEW fee_cleared AS
SELECT personal_details.national_ID, personal_details.stud_name, financial_details.fee_cleared
FROM personal_details
JOIN financial_details ON personal_details.stud_ID = financial_details.stud_ID
WHERE financial_details.fee_cleared = 1;

-- Get the total sum of fees paid so far and the total current deficit (total_fee_balance)
CREATE VIEW total_fee_balance AS
SELECT 
    AVG(sem_fee) AS average_sem_fee,
    AVG(fee_paid) AS average_fee_paid,
    AVG(sem_fee) - AVG(fee_paid) AS total_fee_balance
FROM financial_details;

-- Get the count of students who share a current home county i.e., Say Nairobi, get the number of students who’s current_home_county is Nairobi, and so on for all available counties (home_county_count)
CREATE VIEW home_county_count AS
SELECT current_home_county, COUNT(*) AS student_count
FROM school_details
GROUP BY current_home_county
ORDER BY student_count DESC;

-- Get the count of Male and/or Female students from each secondary_school_county (secondary_school_count). The table should contain a column for male student count and female student count for each county.
CREATE VIEW secondary_school_count AS
SELECT 
    school_details.secondary_school_county,
    SUM(CASE WHEN personal_details.gender = 'Male' THEN 1 ELSE 0 END) AS male_student_count,
    SUM(CASE WHEN personal_details.gender = 'Female' THEN 1 ELSE 0 END) AS female_student_count
FROM school_details
JOIN personal_details ON school_details.stud_ID = personal_details.stud_ID
GROUP BY school_details.secondary_school_county
ORDER BY school_details.secondary_school_county;

-- Get the percentage of students who set their next_of_kin as Mother vs those that set it as Father1. (kin_percentage) 
CREATE VIEW kin_percentage AS
SELECT 
    ROUND(100.0 * SUM(CASE WHEN next_of_kin_relation = 'Mother' THEN 1 ELSE 0 END) / COUNT(*), 2) AS mother_percentage,
    ROUND(100.0 * SUM(CASE WHEN next_of_kin_relation = 'Father' THEN 1 ELSE 0 END) / COUNT(*), 2) AS father_percentage
FROM contact_details
WHERE next_of_kin_relation IN ('Mother', 'Father');