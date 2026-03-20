***Tennis Analytics Project***

This project focuses on building an end-to-end data pipeline using the Sportradar Tennis API. The objective is to collect tennis data, store it in a structured database, analyze it, and present insights through an interactive dashboard.

---

***Project Workflow***

The project follows a complete data pipeline:

API → Python Data Extraction → CSV Files → SQL Database → Data Analysis → Streamlit Dashboard

Each stage of this pipeline is handled by different team members.

---

***Team Responsibilities***

***1. Data Extraction (Python & API)***

* Connected to the Sportradar Tennis API using Python
* Fetched data from endpoints such as competitions, complexes, and rankings
* Processed JSON responses and extracted relevant fields
* Generated structured CSV files for further use

***Scripts Used:***

* main.py → extracts competitions data
* complexes.py → extracts complexes and venues
* rankings.py → extracts rankings and competitor data

***Output Files:***

* tennis_competitions.csv
* tennis_complexes.csv
* tennis_rankings.csv

These files were further structured into:

* category.csv
* competition.csv
* complexes.csv
* venues.csv
* competitors.csv
* competitor_ranking.csv

---

***2. Database Design (SQL)***

* Created database: tennis_analytics
* Designed relational tables with primary and foreign keys
* Tables include:

  * categories
  * competitions
  * complexes
  * venues
  * competitors
  * competitor_rankings
* Imported CSV data into the database

---

***3. Data Analysis (SQL Queries)***

* Wrote SQL queries to extract meaningful insights
* Performed joins between tables
* Generated analytical outputs such as:

  * Top ranked players
  * Competitions by category
  * Player distribution by country
  * Venues under each complex

---

***4. Visualization (Streamlit Dashboard)***

* Built an interactive dashboard using Streamlit
* Connected the dashboard to the SQL database
* Displayed insights using charts and tables
* Features include:

  * Player rankings visualization
  * Competition analysis
  * Venue and complex insights

---

***Technologies Used***

* Python
* Pandas
* Requests
* MySQL
* Streamlit
* Sportradar Tennis API

---

***How to Run the Project***

1. Install required libraries:
   pip install -r requirements.txt

2. Run data extraction scripts:
   python main.py
   python complexes.py
   python rankings.py

3. Load CSV files into the SQL database

4. Run the Streamlit dashboard:
   streamlit run stream_app.py



This project demonstrates a complete data analytics workflow, starting from raw API data to structured storage, analysis, and visualization. Each stage contributes to building a scalable and efficient data pipeline for tennis analytics.
