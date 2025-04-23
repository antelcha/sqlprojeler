INSERT INTO personel_cleaned (name, age, gender, salary)
SELECT
    full_name AS name,
    YEAR(GETDATE()) - birth_year AS age,
    CASE 
        WHEN sex = 'M' THEN 'Male'
        WHEN sex = 'F' THEN 'Female'
        ELSE 'Other'
    END AS gender,
    REPLACE(REPLACE(income, '₺', ''), '.', '') AS salary
FROM personel_b;
