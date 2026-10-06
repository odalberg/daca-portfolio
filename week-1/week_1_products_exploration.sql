/* Toomas tahab teada, millised tooted on UrbanStyle'i sortimendis. */

-- Millised veerud ja andmed tabelis on?
SELECT * 
FROM products
LIMIT 10;

-- Mitu toodet on kokku?
SELECT
  COUNT (*) AS toodete_arv, category
FROM
  products;

-- Unikaalsed tootekategooriad + arv
SELECT DISTINCT
  category AS kategooria,
  COUNT (*) AS toodete_arv
FROM
  products
GROUP BY 
  category
ORDER BY
  toodete_arv desc;

-- 10 kalleimat ja odavamat toodet (muuda: asc/desc)
SELECT
  product_name,
  category,
  retail_price
FROM
  products
ORDER BY
  retail_price desc
LIMIT
  10;

-- Keskmised hinnad kategooriati
SELECT
  category,
  COUNT(*) as toodete_arv,
  MIN(retail_price) as min_hind,
  MAX(retail_price) as max_hind,
  ROUND(AVG(retail_price), 2) as keskmine_hind
FROM
  products
GROUP BY
  category
ORDER BY
  max_hind desc;

-- Keskmine bruto kasumimarginaal tootekategooria kaupa
SELECT 
    category AS tootegrupp,
    ROUND(AVG(cost_price), 2) AS keskmine_ostuhind,
    ROUND(AVG(retail_price), 2) AS keskmine_müügihind,
    -- Keskmine brutomarginaal protsentides (%)
    ROUND(AVG((retail_price - cost_price) / retail_price * 100)::numeric) AS keskmine_marginaal_protsent
FROM products
WHERE retail_price > 0 -- Vältimaks nulliga jagamist
GROUP BY category
ORDER BY keskmine_marginaal_protsent DESC;

-- Kas on puuduvaid andmeid?
SELECT *
FROM products p
WHERE NOT (p IS NOT NULL) OR to_jsonb(p)::text LIKE '%""%';

-- Kas on duplikaate?
SELECT 
    COUNT(*) AS tooteid_kokku,
    COUNT(DISTINCT product_name) AS unikaalseid_kirjeldusi,
    COUNT(*) - COUNT(DISTINCT product_name) AS duplikaatide_arv
FROM products;

-- Mis read on duplikaadid?
SELECT product_id, product_name, category, retail_price
FROM products
WHERE product_name IN (
    SELECT product_name
    FROM products
    GROUP BY product_name
    HAVING COUNT(*) > 1
)
ORDER BY product_name, product_id;