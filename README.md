# Netflix Content Analysis Project

![Netflix](https://img.shields.io/badge/Netflix-E50914?style=for-the-badge&logo=netflix&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=tableau&logoColor=white)

## Overview
An end-to-end data analysis project exploring Netflix's content catalogue of 8,794 titles. 
The project covers data cleaning in Python, business analysis in SQL, and an 
interactive dashboard in Tableau Public.

## Live Dashboard
🔗 [View Interactive Tableau Dashboard](https://public.tableau.com/app/profile/tess.kamau/viz/NetflixContentAnalysisDashboard_17793208304690/NetflixContentAnalysisDashboard)

## Hashnode article : https://netflixanalysis.hashnode.dev/what-netflix-s-data-reveals-about-its-global-content-strategy
## Tools Used
- **Python** — data cleaning, exploration and visualisation (Pandas, Matplotlib, Seaborn)
- **SQLite / DB Browser** — business questions answered with 10 SQL queries
- **Tableau Public** — interactive dashboard

## Dataset
Source: [Kaggle — Netflix Movies and TV Shows](https://www.kaggle.com/datasets/shivamb/netflix-shows)  
Rows: 8,794 titles | Columns: 12 (+ 5 engineered features)

## Key Findings

### Content Strategy
- Netflix's catalogue is **70% Movies and 30% TV Shows**
- **58.6% of content is International** — Netflix is a global platform, not just American
- Only 31.9% of content is US domestic

### Country Analysis
- **USA leads with 2,809 titles** — nearly 3x more than India (972) in second place
- **Spain has the highest adult content ratio at 82.1%** — all top 10 adult content 
  markets are non-English speaking
- Colombia, Thailand and Turkey have **0% children's content**

### Growth Trends
- **2016 was the turning point** — 420.7% growth when Netflix launched globally 
  in 130 new countries
- **2019 was peak year** with 2,016 titles added
- 2020-2021 saw decline due to COVID slowing production globally

### Content Patterns
- **TV-MA is the dominant rating** with 3,205 titles — Netflix targets adult audiences
- **July and December** are peak release months (827 and 813 titles respectively)
- **February is the slowest month** at 563 titles

## SQL Skills Demonstrated
| Query | Skill |
|-------|-------|
| Content type split | GROUP BY + COUNT |
| Top 10 countries | ORDER BY + LIMIT |
| TV-MA ratio by country | CASE WHEN + percentage calculation |
| Kids vs Adult gap | Multiple CASE WHEN + IN clause |
| Top genres per year | RANK() OVER (PARTITION BY) — window function |
| Year on year growth | LAG() window function |
| Country growth over time | CTE (WITH clause) + SUM() OVER |
| Average movie duration | AVG() + MIN() + MAX() + HAVING |
| Monthly release patterns | SUM() OVER() for percentage of total |
| International vs Domestic | CASE WHEN + subquery |

## Author
**Tess Kamau**  
[GitHub](https://github.com/Tee-ai63)
