# Nädal 1: SQL Basics - UrbanStyle'i andmete uurimine

<img width="500" height="200" alt="hd1" src="https://github.com/user-attachments/assets/b6a4724a-36f9-454a-a91c-c67a8b926939" />
<img width="500" height="200" alt="hd2" src="https://github.com/user-attachments/assets/80d3c62d-e7b5-4935-bbd3-b4417b4af1fa" />

## Mida ma tegin
Uurisin Products tabelit SQL päringutega

## Products Tabel
| Key           | Type    | Description                                        |
| ------------- | ------- | -------------------------------------------------- |
| product_id    | int     | Toote unikaalne ID vahemikus 1001-1350             |
| product_name  | varchar | Toote nimetus (nt Villane mantel, Linane kleit)    |
| category      | varchar | Kategooria: (nt naiste_riided, meeste_riided)      |
| subcategory   | varchar | Alamkategooria (nt kleidid, mantlid, seelikud)     |
| supplier      | varchar | Tarnija nimi — loogiline seos tarnijate tabeliga   |
| cost_price    | numeric | Omahind eurodes (hankehind tarnijalt)              |
| retail_price  | numeric | Jaehind eurodes (müügihind kliendile)              |
| eco_certified | bool    | Kas toode on ökomärgisega                          |
| created_at    | date    | Toote lisamise kuupäev kataloogi                   |

## Päringud products tabeli uurimiseks

<table>
<tr>
<td><strong>SQL Query</strong></td>
<td><strong>Tulemus</strong></td>
</tr>
 
<tr>
<td valign="top" width="50%">

```sql
-- Toodete koguarv
SELECT
   COUNT(*) AS toodete_arv
FROM
   products;
```

</td>
<td valign="top" width="50%">
 
<img width="90" height="55" alt="rs1" src="https://github.com/user-attachments/assets/689349db-bb9c-4f5f-a9eb-274b049cc26d" />

</td>
</tr>

<tr>
<td valign="top" width="50%">
 
```sql
-- Kõik unikaalsed tootekategooriad
SELECT DISTINCT
  category AS kategooria
FROM
  products;
```


</td>
<td valign="top" width="50%">

<img width="90" height="205" alt="rs2" src="https://github.com/user-attachments/assets/f53768d6-1f81-4291-83c5-c2581acb6f63" />

</td>
</tr>

<tr>
<td valign="top" width="50%">
 
```sql
-- Hinnavahemikud
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
```


</td>
<td valign="top" width="50%">

<img width="510" height="205" alt="Srs3" src="https://github.com/user-attachments/assets/e207411d-5d1e-4ff5-aac0-a2ffe6fd2f73" />

</td>
</tr>

<tr>
<td valign="top" width="50%">
 
```sql
-- Keskmine bruto kasumimarginaal tootekategooria kaupa
SELECT 
    category AS tootegrupp,
    ROUND(AVG(cost_price), 2) AS keskmine_ostuhind,
    ROUND(AVG(retail_price), 2) AS keskmine_müügihind,
    -- Keskmine brutomarginaal protsentides (%)
    ROUND (AVG((retail_price - cost_price) / retail_price * 100)::numeric)
    AS keskmine_marginaal_protsent
FROM products
WHERE retail_price > 0 -- Vältimaks nulliga jagamist
GROUP BY category
ORDER BY keskmine_marginaal_protsent DESC;
```

</td>
<td valign="top" width="50%">

<img width="510" height="205" alt="Screenshot 2026-10-07 at 00 36 46" src="https://github.com/user-attachments/assets/0aab24a6-2df2-4d8b-bb8c-4dfdeb9dc672" />

</td>
</tr>

</table>


## Kas on puuduvaid andmeid või duplikaate?
<table>
<tr>
<td><strong>SQL Query</strong></td>
<td><strong></strong></td>
</tr>
 
<tr>
<td valign="top" width="50%">

```sql
-- Kas on puuduvaid andmeid?
SELECT *
FROM products p
WHERE NOT (p IS NOT NULL) OR to_jsonb(p)::text LIKE '%""%';
```

</td>
<td valign="top" width="50%">


</td>
</tr>

<tr>
<td valign="top" width="50%">

```sql
-- Kas on duplikaate?
SELECT 
    COUNT(*) AS tooteid_kokku,
    COUNT(DISTINCT product_name) AS unikaalseid_kirjeldusi,
    COUNT(*) - COUNT(DISTINCT product_name) AS duplikaatide_arv
FROM products;
```

</td>

<td valign="top" width="50%">

```sql
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
```
</td>
</tr>
</table>



- Leidsin [peamine leid]
- Osalesin meeskonna andmemaastiku koostamisel

## Peamised õpid
- [Õppetund 1]
- [Õppetund 2]

## Failid
- `week1_[tabel]_exploration.sql` -- minu SQL päringud
- `week1_results_screenshot.png` -- tulemuste pilt

## Meeskonna töö
- [Link meeskonna Data Landscape slaidile]
