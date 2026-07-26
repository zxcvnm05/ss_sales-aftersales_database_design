# ss_sales-aftersales_database_design

## 📌 Executive Summary
This project delivers a relational database architecture on Supabase (PostgreSQL) modeling the end-to-end customer lifecycle for Samsung—from purchase to warranty and after-sales service (RMA). Using advanced SQL, the system tracks repair bottlenecks, product failure trends, and customer sentiment to support operational decision-making.

## 🛠️ Tech Stack & Tools
- **Database Engine:** PostgreSQL / Supabase
- **Data Modeling:** ER Diagramming (13 Relational Tables)
- **SQL Techniques:** Common Table Expressions (CTEs), Multi-table JOINs, Window Functions, Aggregations

## 📂 Project Structure
├── database/           # DDL scripts (table creation, foreign keys, constraints)
├── queries/            # Advanced SQL analytical scripts (CTEs, KPIs, backlog aging)
├── schema/             # ERD diagrams and relational schema documentation
└── README.md           # Project documentation

## 🚀 Key Results & Findings
- **Backlog Tracking:** Identified unresolved service requests exceeding **440 days** for specific product lines.
- **Quality Insights:** Correlated repair cost data ($6,770 per execution) with low customer sentiment scores to isolate defective product batches (e.g., Bluetooth speakers).
- **Polyglot Architecture Justification:** Evaluated and recommended RDBMS for transactional/financial integrity, paired with NoSQL (MongoDB/Redis) for high-volume IoT telemetry and caching.

## 💼 Business Impact & Recommendations
- **Early Defect Detection:** Provides R&D with operational feedback on product failure patterns.
- **Service Prioritization:** Enables dynamic workload allocation to clear unresolved repair backlogs.
