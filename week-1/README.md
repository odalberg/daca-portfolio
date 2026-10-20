# Nädal 1: SQL Basics - UrbanStyle'i andmete uurimine

<img width="483" height="400" alt="Screenshot 2026-10-07 at 01 01 34" src="https://github.com/user-attachments/assets/914a1fd6-478a-46ab-8ba5-8965d2263fa3" />

## Skoop:
Products tabeli uurimine, dokumenteerimine ning kokkuvõte teistele meeskonna liikmetele

## Products Tabel:
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

## Päringud products tabeli uurimiseks:

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

<img width="1223" height="348" alt="Screenshot 2026-10-07 at 00 41 57" src="https://github.com/user-attachments/assets/4d70a569-96de-45c8-8889-244327fa3b94" />



## Kokkuvõte:
Uurisin urbanstyle toodete tabelit. Kokkuvõtvalt liiga palju tooteid ei olnud (362), mis omakorda jagunesid 5 kategooria vahel üpriski võrdselt (67-82 tooded ühes kategoorias). Tarnijaid omakorda oli nende toodete peale 15. Tootegruppide keskmine hinnaklass ei olnud väga madal kuid samas mitte ka kõrge nt. jalanõudel 214.10€. Võiks pakkuda mingil määral butiik tüüpi pood. Huvi pärast uurisin ka brutokasumi marginaale ja üle gruppide olid need väga sarnased ~33% üldise keskmise hinna järgi arvutades. Duplikaate tundus olevat 12 kirje jagu st. kattusid product_name, category, retail_price, mis annab üsa suure kindluse duplikaatide õigsuses. Üldiselt soovitaks tabelid korrastada duplikaatise osas, eco_certified veerus olid mõned NULL väärtused kuid hetkel seda liiga oluliseks ei pea kuna andmed võivadki lihtsalt tootja poolelt puudu olla.

## Meeskonna töö:
Meeskonna andmemaastiku koostamise: [link](https://docs.google.com/presentation/d/1HGrAEDhiSVFO7SssiodFCCP5E2eAqCFLvKtMVqyCAdk/)
