# Nädal 1: SQL Basics - UrbanStyle'i andmete uurimine
<img width="600" height="250" alt="header" src="https://github.com/user-attachments/assets/6f0561ac-5cad-4a68-91ca-73d1e6761ce9" />

## Mida ma tegin
- Uurisin Products tabelit SQL päringutega

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

## Päringud
Mitu toodet on? **362**

```sql
  SELECT
     COUNT(*) AS toodete_arv
  FROM
     products;
```


- Millised kategooriad? 
- Milline on hinnavahemik? 
- Kas on puuduvaid andmeid? */



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
