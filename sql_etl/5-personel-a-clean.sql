SELECT
    ad_soyad AS name,
    yas AS age,
    CASE 
        WHEN cinsiyet = 'erkek' THEN 'Male'
        WHEN cinsiyet = 'kadın' THEN 'Female'
        ELSE 'Other'
    END AS gender,
    maas AS salary
INTO personel_cleaned
FROM personel_a;
