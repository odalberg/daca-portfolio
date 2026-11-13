-- Test koopia sales tabelist
CREATE TABLE sales_test AS SELECT * FROM sales;
-- Taga unikaalne rea-tunnus dedup'i jaoks (lisab `id` AINULT siis, kui see puudub).
-- NB: `CREATE TABLE ... AS SELECT` ei pärandata alati `id`-d — see rida teeb Sammu 3 töökindlaks.
ALTER TABLE sales_test ADD COLUMN IF NOT EXISTS id SERIAL;
-- Kontrolli ridade arvu
SELECT COUNT(*) AS ridade_arv FROM sales_test;

-- Leia duplikaadid — millised tellimused (arved) korduvad?
SELECT invoice_id, COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY invoice_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

-- Loe kokku duplikaatsete ridade arv:
SELECT
    COUNT(*) AS duplikaadid,
    ROUND(SUM(total_price)::numeric, 2) AS rahaline_vaartus_€
    --SUM(quantity) AS duplikaatide_toodete_arv
FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id
);
-- Leia NULL väärtused olulistes väljades:
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;

-- Kontrolli kuupäevade formaati — kas on tuleviku kuupäevi?
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date > CURRENT_DATE
   OR sale_date < DATE '2020-01-01';   -- UrbanStyle.ltd asutati 2020

---
SELECT 
    -- 1. State BEFORE cleaning (entire table)
    COUNT(*) AS ridade_arv,
    ROUND(SUM(total_price)::numeric, 2) AS kaive_€,
    
    -- 2. Duplicate rows to be removed
    COUNT(*) FILTER (
        WHERE id NOT IN (SELECT MIN(id) FROM sales_test GROUP BY invoice_id)
    ) AS duplikaadid,
    ROUND(SUM(total_price) FILTER (
        WHERE id NOT IN (SELECT MIN(id) FROM sales_test GROUP BY invoice_id)
    )::numeric, 2) AS duplikaatid_€,
    
    -- 3. Expected state AFTER cleaning
    COUNT(*) FILTER (
        WHERE id IN (SELECT MIN(id) FROM sales_test GROUP BY invoice_id)
    ) AS korrektsed_read,
    ROUND(SUM(total_price) FILTER (
        WHERE id IN (SELECT MIN(id) FROM sales_test GROUP BY invoice_id)
    )::numeric, 2) AS korrektne_kaive_eur
FROM sales_test;